import math
import threading
import time
from tribool import Tribool

from multiprocessing.connection import Listener
from threading import Event, Thread

from .proto.duoquest_pb2 import ProtoQueryList, ProtoResult, FALSE, UNKNOWN, TRUE
from .external.eval import correct_rank, is_correct, print_ranks, print_cdf, \
    print_avg_time
from .query import generate_sql_str

class DuoquestServer:
    def __init__(self, port, authkey, verifier, out_base):
        self.port = port
        self.authkey = authkey
        self.verifier = verifier
        self.out_base = out_base

    def run_task(self, task_id, task, task_count, schema, db, nlqc, tsq_level,
        tsq_rows, eval_kmaps, timeout=None):
        print('{}/{} || Database: {} || NLQ: {}'.format(task_id, task_count,
            task['db_id'], task['question_toks']))

        if tsq_level == 'nlq_only':
            tsq = None
        else:
            tsq = db.generate_tsq(schema, task['query'], task['sql'], tsq_level,
                tsq_rows)
            if tsq is None:
                print('Skipping task because it is out of scope.')
                return None
            print(tsq)

        ready = Event()
        t = threading.Thread(target=self.task_thread,
            args=(db, schema, nlqc, tsq, ready, eval_kmaps, task['query'],
                tsq_level))
        t.start()
        ready.wait()

        cqs = nlqc.run(task_id, schema, task['question_toks'], tsq_level,
            timeout=timeout)

        t.join()

        return cqs

    def run_tasks(self, schemas, db, nlqc, tasks, tsq_level, tsq_rows,
        eval_kmaps, tid=None, compare=None, start_tid=None, timeout=None):
        nlqc.connect()
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
                tsq_level, tsq_rows, eval_kmaps, timeout=timeout)
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
                    db, nlqc, compare, tsq_rows)
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

            if cqs:
                f.write(u'\t'.join(
                    list(map(lambda q: q.replace('\n', ' '), cqs))
                ))
            else:
                f.write('SELECT A FROM B')  # failure
            f.write('\n')

            gold_f.write(task['query'])
            gold_f.write(f"\t{task['db_id']}")
            gold_f.write('\n')

            print(f'TIME: {task_time:.2f}s\n')
            time_f.write(f'{task_time:.2f}')
            time_f.write('\n')

        f.close()
        gold_f.close()
        time_f.close()
        nlqc.close()

        print_ranks(ranks)
        print_avg_time(times)
        print_cdf(ranks, times, 20)

    def task_thread(self, db, schema, nlqc, tsq, ready, eval_kmaps, eval_gold,
        tsq_level):
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
                        result = self.verifier.verify(db, schema, query, tsq)

                    if is_correct(db, schema.db_id, eval_kmaps, eval_gold,
                        generate_sql_str(query, schema)):
                        response.answer_found = True
                else:
                    if tsq_level == 'nlq_only' or tsq_level == 'chain':
                        result = Tribool(None)
                    else:
                        result = self.verifier.verify(db, schema, query, tsq)

                if result.value is None:
                    response.results.append(UNKNOWN)
                elif result.value:
                    response.results.append(TRUE)
                else:
                    response.results.append(FALSE)

            conn.send_bytes(response.SerializeToString())
        listener.close()
