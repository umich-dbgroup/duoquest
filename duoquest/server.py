import json
import math
import psycopg2
import threading
import time
import traceback
from tribool import Tribool

from multiprocessing.connection import Listener
from nltk import word_tokenize
from pprint import pprint
from threading import Event, Thread

from .proto.duoquest_pb2 import ProtoLiteralList, ProtoQueryList, ProtoResult, \
    FALSE, UNKNOWN, TRUE, ProtoExperimentSet
from .database import Database
from .eval import correct_rank, matches_gold, print_ranks, print_cdf, \
    print_avg_time
from .query import generate_sql_str
from .schema import Schema
from .tasks import is_valid_task
from .tsq import TableSketchQuery

def get_literals(pq, schema):
    literals = ProtoLiteralList()
    for pred in pq.where.predicates:
        col_type = schema.get_col(pred.col_id).type
        for val in pred.value:
            if col_type == 'text':
                text_lit = literals.text_lits.add()
                text_lit.col_id.append(pred.col_id)
                text_lit.value = val
            elif col_type == 'number':
                literals.num_lits.append(val)

    for pred in pq.having.predicates:
        for val in pred.value:
            literals.num_lits.append(val)

    return literals

class DuoquestServer:
    def __init__(self, port, authkey, verifier, out_base=None, db_cfg=None,
        minimal_join_paths=False):
        self.port = port
        self.authkey = authkey
        self.verifier = verifier
        self.out_base = out_base
        self.db_cfg = db_cfg

        self.minimal_join_paths = minimal_join_paths

    def reset_any_running(self):
        conn = psycopg2.connect(database=self.db_cfg['name'],
                host=self.db_cfg['host'],
                port=self.db_cfg['port'],
                user=self.db_cfg['user'],
                password=self.db_cfg['password'])
        cur = conn.cursor()
        cur.execute("SELECT tid FROM tasks WHERE status = %s", ('running',))
        for row in cur.fetchall():
            results_cur = conn.cursor()
            results_cur.execute('DELETE FROM results WHERE tid = %s', (row[0],))

            status_cur = conn.cursor()
            status_cur.execute('''UPDATE tasks SET status = %s, error_msg = %s
                                  WHERE tid = %s''', ('waiting', None, row[0]))
        conn.commit()
        conn.close()

    def run_next_in_queue(self, nlqc, timeout=None):
        conn = psycopg2.connect(database=self.db_cfg['name'],
                host=self.db_cfg['host'],
                port=self.db_cfg['port'],
                user=self.db_cfg['user'],
                password=self.db_cfg['password'])
        cur = conn.cursor()
        cur.execute('''SELECT t.tid, t.db, d.path, t.nlq, t.tsq_proto,
                              t.literals_proto, d.schema_proto
                       FROM tasks t JOIN databases d ON d.name = t.db
                       WHERE status = %s ORDER BY time ASC LIMIT 1''',
                    ('waiting',))
        row = cur.fetchone()

        if row is None:
            time.sleep(2)
            return

        tid, db_name, db_path, nlq, tsq_proto, literals_proto, \
            schema_proto = row

        schema = Schema.from_proto(schema_proto)
        db = Database(db_path, None, db_name=db_name)
        literals = ProtoLiteralList()
        literals.ParseFromString(literals_proto)

        print(f'Running task {tid}...')
        print(f'Database: {db_name} || NLQ: {nlq}')
        print('LITERALS')
        print(literals)

        cur = conn.cursor()
        cur.execute('UPDATE tasks SET status = %s WHERE tid = %s',
                    ('running', tid))
        conn.commit()

        try:
            if tsq_proto:
                tsq_level = 'default'
                tsq = TableSketchQuery.from_proto(tsq_proto)
                print(tsq)
            else:
                tsq_level = 'nlq_only'
                tsq = None

            status = 'done'
            error_msg = None

            ready = Event()
            t = threading.Thread(target=self.live_thread,
                args=(tid, db, schema, tsq, literals, ready, tsq_level))

            t.start()
            ready.wait()

            question_toks = [word.lower() for word in word_tokenize(nlq)]

            nlqc.connect()
            nlqc.run(tid, schema, question_toks, tsq_level, literals,
                timeout=timeout, minimal_join_paths=self.minimal_join_paths)
            nlqc.close()

            t.join()
        except Exception as e:
            traceback.print_exc()
            status = 'error'
            error_msg = str(e)

        print('Updating database with results...', end='')
        cur = conn.cursor()
        cur.execute('UPDATE tasks SET status = %s, error_msg = %s WHERE tid = %s',
                    (status, error_msg, tid))
        conn.commit()
        print('Done')

        conn.close()

    def run_experiment(self, task_id, task, task_count, nlqc, schema, db,
        tsq_level, tsq_rows, timeout=None):
        print('{}/{} || Database: {} || NLQ: {}'.format(task_id, task_count,
            task['db_id'], task['question_toks']))

        try:
            task['query'], task['pq'] = is_valid_task(schema, db, task['sql'])
        except Exception as e:
            traceback.print_exc()
            print('Skipping task because it is out of scope.')
            return None

        literals = get_literals(task['pq'], schema)

        if tsq_level == 'nlq_only':
            tsq = None
        else:
            tsq = db.generate_tsq(task_id, schema, task['query'], task['pq'],
                tsq_level, tsq_rows)
            print(tsq)

        ready = Event()
        t = threading.Thread(target=self.experiment_thread,
            args=(db, schema, tsq, literals, ready, tsq_level, task['pq']))
        t.start()
        ready.wait()

        proto_out = nlqc.run(task_id, schema, task['question_toks'], tsq_level,
            literals, timeout=timeout)

        t.join()

        return proto_out.cqs

    def run_experiments(self, schemas, db, nlqc, tasks, tsq_level, tsq_rows,
        tid=None, compare=None, start_tid=None, timeout=None):
        nlqc.connect()

        ranks = []
        times = []

        exp_set = ProtoExperimentSet()

        for i, task in enumerate(tasks):
            task_id = i+1
            if tid and task_id != tid:
                continue
            if start_tid and task_id < start_tid:
                continue

            schema = schemas[task['db_id']]
            start = time.time()
            cqs = self.run_experiment(task_id, task, len(tasks), nlqc, schema,
                db, tsq_level, tsq_rows, timeout=timeout)
            task_time = time.time() - start

            if cqs is None:         # invalid task
                continue

            og_rank = correct_rank(cqs, task['pq'])

            if og_rank is None:
                task_time = math.inf
            elif task_time > timeout:
                task_time = timeout
            ranks.append(og_rank)
            times.append(task_time)

            # debug, for comparing with other mode
            if compare:
                cm_cqs = self.run_experiment(task_id, task, len(tasks), schema,
                    db, nlqc, compare, tsq_rows, timeout=timeout)
                cm_rank = correct_rank(cm_cqs, task['pq'])

                print('\n{} RANK: {}\n{} RANK: {}\n'.format(
                    tsq_level, og_rank, compare, cm_rank
                ))

                if cm_rank is not None:
                    if og_rank is None or \
                        (cm_rank == 1 and og_rank > 1) or \
                        (cm_rank <= 5 and og_rank > 5):
                        print('---- ORIGINAL ----')
                        print(u'\n'.join(cqs))
                        print('\n---- COMPARE ----')
                        print(u'\n'.join(cm_cqs))
                        print()
                        raise Exception('Rank is lower than compare!')
            else:
                print(f'RANK: {og_rank}')
                print(f'TIME: {task_time}')

            exp = exp_set.exps.add()

            if cqs:
                for cq in cqs:
                    pq = exp.cqs.add()
                    pq.CopyFrom(cq)

            exp.gold.CopyFrom(task['pq'])

            exp.time = task_time

        nlqc.close()

        if tid or start_tid:
            print('Not saving .exp output because of tid/start_tid option.')
        else:
            if self.out_base:
                out_path = f'{self.out_base}.exp'
                with open(out_path, 'wb') as f:
                    f.write(exp_set.SerializeToString())

        print_ranks(ranks)
        print_avg_time(times)
        print_cdf(ranks, times)

    def live_thread(self, tid, db, schema, tsq, literals, ready, tsq_level):
        task_conn = psycopg2.connect(database=self.db_cfg['name'],
                host=self.db_cfg['host'],
                port=self.db_cfg['port'],
                user=self.db_cfg['user'],
                password=self.db_cfg['password'])

        address = ('', self.port)
        listener = Listener(address, authkey=self.authkey)
        ready.set()
        print(f'DuoquestServer listening on port {self.port}...')

        conn = listener.accept()
        print('DuoquestServer connection accepted from:',
            listener.last_accepted)

        seen_queries = set()

        last_done_check = 0

        while True:
            msg = conn.recv_bytes()

            try:
                if msg.decode('utf-8') == 'close':
                    conn.close()
                    break
            except Exception:
                pass

            protolist = ProtoQueryList()
            protolist.ParseFromString(msg)

            response = ProtoResult()

            # check only once every 2 seconds
            cur_time = time.time()
            if (cur_time - last_done_check) > 2:
                cur = task_conn.cursor()
                cur.execute('SELECT status FROM tasks WHERE tid = %s', (tid,))
                row = cur.fetchone()
                if row[0] == 'done':
                    response.results.append(TRUE)
                    response.answer_found = True
                    conn.send_bytes(response.SerializeToString())
                    continue
                last_done_check = cur_time

            for query in protolist.queries:
                if query.done_query:
                    if tsq_level == 'nlq_only':
                        result = Tribool(True)
                    else:
                        result = self.verifier.verify(db, schema, query, tsq,
                            literals)
                else:
                    if tsq_level == 'nlq_only' or tsq_level == 'chain':
                        result = Tribool(None)
                    else:
                        result = self.verifier.verify(db, schema, query, tsq,
                            literals)

                if result.value is None:
                    response.results.append(UNKNOWN)
                elif result.value:
                    response.results.append(TRUE)

                    sql_str = generate_sql_str(query, schema)
                    if sql_str not in seen_queries:
                        cur = task_conn.cursor()
                        cur.execute('INSERT INTO results (tid, query) VALUES (%s,%s)',
                                    (tid, sql_str))
                        task_conn.commit()
                        seen_queries.add(sql_str)
                else:
                    response.results.append(FALSE)

            conn.send_bytes(response.SerializeToString())

        listener.close()
        task_conn.close()

    def experiment_thread(self, db, schema, tsq, literals, ready, tsq_level,
        gold):
        address = ('', self.port)
        listener = Listener(address, authkey=self.authkey)
        ready.set()
        print(f'DuoquestServer listening on port {self.port}...')

        conn = listener.accept()
        print('DuoquestServer connection accepted from:',
            listener.last_accepted)

        self.verifier.init_stats()

        while True:
            msg = conn.recv_bytes()

            try:
                if msg.decode('utf-8') == 'close':
                    conn.close()
                    break
            except Exception:
                pass

            protolist = ProtoQueryList()
            protolist.ParseFromString(msg)

            response = ProtoResult()
            for query in protolist.queries:
                if query.done_query:
                    if tsq_level == 'nlq_only':
                        result = Tribool(True)
                    else:
                        result = self.verifier.verify(db, schema, query, tsq,
                            literals)
                else:
                    if tsq_level == 'nlq_only' or tsq_level == 'chain':
                        result = Tribool(None)
                    else:
                        result = self.verifier.verify(db, schema, query, tsq,
                            literals)

                if result.value is None:
                    response.results.append(UNKNOWN)
                elif result.value:
                    response.results.append(TRUE)

                    if matches_gold(gold, query):
                        response.answer_found = True
                else:
                    response.results.append(FALSE)

            conn.send_bytes(response.SerializeToString())

        pprint(self.verifier.stats)
        listener.close()
