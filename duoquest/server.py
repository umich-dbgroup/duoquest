import json
import math
import sqlite3
import threading
import time
import traceback
from tribool import Tribool

from multiprocessing.connection import Listener
from nltk import word_tokenize
from threading import Event, Thread

from .proto.duoquest_pb2 import ProtoLiteralList, ProtoQueryList, ProtoResult, \
    FALSE, UNKNOWN, TRUE
from .external.eval import correct_rank, is_correct, print_ranks, print_cdf, \
    print_avg_time
from .database import Database
from .query import generate_sql_str
from .schema import Schema
from .tsq import TableSketchQuery

class DuoquestServer:
    def __init__(self, port, authkey, verifier, out_base=None, task_db=None,
        minimal_join_paths=False):
        self.port = port
        self.authkey = authkey
        self.verifier = verifier
        self.out_base = out_base
        self.task_db = task_db

        self.minimal_join_paths = minimal_join_paths

    def reset_any_running(self):
        conn = sqlite3.connect(self.task_db)
        cur = conn.cursor()
        cur.execute("SELECT tid FROM tasks WHERE status = ?", ('running',))
        for row in cur.fetchall():
            results_cur = conn.cursor()
            results_cur.execute('DELETE FROM results WHERE tid = ?', (row[0],))

            status_cur = conn.cursor()
            status_cur.execute('''UPDATE tasks SET status = ?, error_msg = ?
                                  WHERE tid = ?''', ('waiting', None, row[0]))
        conn.commit()
        conn.close()

    def run_next_in_queue(self, nlqc, timeout=None):
        conn = sqlite3.connect(self.task_db)
        cur = conn.cursor()
        cur.execute('''SELECT t.tid, t.db, d.path, t.nlq, t.tsq_proto,
                              t.literals_proto, d.schema_proto
                       FROM tasks t JOIN databases d ON d.name = t.db
                       WHERE status = ? ORDER BY time ASC LIMIT 1''',
                    ('waiting',))
        row = cur.fetchone()

        if row is None:
            time.sleep(2)
            return

        nlqc.connect()
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
        cur.execute('UPDATE tasks SET status = ? WHERE tid = ?',
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
            t = threading.Thread(target=self.task_thread,
                args=(tid, db, schema, nlqc, tsq, literals, ready, tsq_level))

            t.start()
            ready.wait()

            question_toks = [word.lower() for word in word_tokenize(nlq)]

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
        cur.execute('UPDATE tasks SET status = ?, error_msg = ? WHERE tid = ?',
                    (status, error_msg, tid))
        conn.commit()
        print('Done')

        conn.close()

    def run_task(self, task_id, task, task_count, schema, db, nlqc, tsq_level,
        tsq_rows, eval_kmaps=None, timeout=None):
        print('{}/{} || Database: {} || NLQ: {}'.format(task_id, task_count,
            task['db_id'], task['question_toks']))

        # TODO: load this in from the experiment datasets somehow
        literals = ProtoLiteralList()
        print('LITERALS')
        print(literals)

        tsq = db.generate_tsq(schema, task['query'], task['sql'], tsq_level,
            tsq_rows)
        if tsq is None:
            print('Skipping task because it is out of scope.')
            return None

        if tsq_level == 'nlq_only':
            tsq = None
        else:
            print(tsq)

        ready = Event()
        t = threading.Thread(target=self.experiment_thread,
            args=(db, schema, nlqc, tsq, literals, ready, tsq_level,
                task['query'], eval_kmaps))
        t.start()
        ready.wait()

        proto_out = nlqc.run(task_id, schema, task['question_toks'], tsq_level,
            literals, timeout=timeout)
        cqs = list(map(lambda x: generate_sql_str(x, schema), proto_out.cqs))

        t.join()

        return cqs

    def run_tasks(self, schemas, db, nlqc, tasks, tsq_level, tsq_rows,
        eval_kmaps, tid=None, compare=None, start_tid=None, timeout=None):
        nlqc.connect()

        if self.out_base:
            out_path = f'{self.out_base}.sqls'
            gold_path = f'{self.out_base}.gold'
            time_path = f'{self.out_base}.times'

            f = open(out_path, 'w+')
            gold_f = open(gold_path, 'w+')
            time_f = open(time_path, 'w+')

        ranks = []
        times = []

        for i, task in enumerate(tasks):
            task_id = i+1
            if tid and task_id != tid:
                continue
            if start_tid and task_id < start_tid:
                continue

            schema = schemas[task['db_id']]
            start = time.time()
            cqs = self.run_task(task_id, task, len(tasks), schema, db, nlqc,
                tsq_level, tsq_rows, eval_kmaps=eval_kmaps, timeout=timeout)
            task_time = time.time() - start

            if cqs is None:         # invalid task
                continue

            og_rank = correct_rank(db, task['db_id'], eval_kmaps, task['query'],
                cqs)
            if task_time > timeout or og_rank is None:
                task_time = math.inf
            ranks.append(og_rank)
            times.append(task_time)

            # debug, for comparing with other mode
            if compare:
                cm_cqs = self.run_task(task_id, task, len(tasks), schema,
                    db, nlqc, compare, tsq_rows, eval_kmaps, timeout=timeout)
                cm_rank = correct_rank(db, task['db_id'], eval_kmaps,
                    task['query'], cm_cqs)

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
                print('RANK: {}'.format(og_rank))

            if self.out_base:
                if cqs:
                    f.write(u'\t'.join(
                        list(map(lambda q: q.replace('\n', ' '), cqs))
                    ))
                    f.write('\n')
                else:
                    f.write('SELECT A FROM B\n')  # failure

                gold_f.write(task['query'].replace('\t', ' '))
                gold_f.write(f"\t{task['db_id']}")
                gold_f.write('\n')

                print(f'TIME: {task_time:.2f}s\n')
                time_f.write(f'{task_time:.2f}')
                time_f.write('\n')

        if self.out_base:
            f.close()
            gold_f.close()
            time_f.close()

        nlqc.close()

        print_ranks(ranks)
        print_avg_time(times)
        print_cdf(ranks, times, 10)

    def task_thread(self, tid, db, schema, nlqc, tsq, literals, ready,
        tsq_level):
        task_conn = sqlite3.connect(self.task_db)

        address = ('localhost', self.port)
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
                cur.execute('SELECT status FROM tasks WHERE tid = ?', (tid,))
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
                        cur.execute('INSERT INTO results (tid, query) VALUES (?,?)',
                                    (tid, sql_str))
                        task_conn.commit()
                        seen_queries.add(sql_str)
                else:
                    response.results.append(FALSE)

            conn.send_bytes(response.SerializeToString())
        listener.close()
        task_conn.close()

    def experiment_thread(self, db, schema, nlqc, tsq, literals, ready,
        tsq_level, eval_gold, eval_kmaps):
        address = ('localhost', self.port)
        listener = Listener(address, authkey=self.authkey)
        ready.set()
        print(f'DuoquestServer listening on port {self.port}...')

        conn = listener.accept()
        print('DuoquestServer connection accepted from:',
            listener.last_accepted)
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

                    if eval_gold and eval_kmaps and is_correct(db, schema.db_id,
                        eval_kmaps, eval_gold, generate_sql_str(query, schema)):
                        response.answer_found = True
                else:
                    response.results.append(FALSE)

            conn.send_bytes(response.SerializeToString())
        listener.close()
