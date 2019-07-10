import threading
from tribool import Tribool

from multiprocessing.connection import Listener
from threading import Event, Thread

from .proto.query_pb2 import ProtoQueryList, ProtoResult, FALSE, UNKNOWN, TRUE
from .external.eval import correct_rank

class DuoquestServer:
    def __init__(self, port, authkey, verifier, out_path, gold_path, n, b):
        self.port = port
        self.authkey = authkey
        self.verifier = verifier
        self.out_path = out_path
        self.gold_path = gold_path
        self.n = n
        self.b = b

    def run_task(self, task_id, task, task_count, schema, db, nlqc, tsq_level,
        tsq_rows):
        print('{}/{} || Database: {} || NLQ: {}'.format(task_id, task_count,
            task['db_id'], task['question_toks']))

        duoquest_enabled = (tsq_level != 'no_duoquest')

        tsq = db.generate_tsq(schema, task['query'], task['sql'], tsq_level,
            tsq_rows)
        if tsq is None:
            print('Skipping task because it is out of scope.')
            return None

        if duoquest_enabled:
            print(tsq)
            ready = Event()
            t = threading.Thread(target=self.task_thread,
                args=(db, schema, nlqc, tsq, ready))
            t.start()
            ready.wait()

        cqs = nlqc.run(task_id, self.n, self.b, task['db_id'],
            task['question_toks'], duoquest_enabled)

        if duoquest_enabled:
            t.join()

        return cqs

    def run_tasks(self, schemas, db, nlqc, tasks, tsq_level, tsq_rows,
        tid=None, compare=None, kmaps=None):
        nlqc.connect()
        f = open(self.out_path, 'w+')
        gold_f = open(self.gold_path, 'w+')

        top_1 = 0
        top_5 = 0
        top_10 = 0
        all_tasks = 0

        for i, task in enumerate(tasks):
            task_id = i+1
            if tid and task_id != tid:
                continue

            schema = schemas[task['db_id']]
            cqs = self.run_task(task_id, task, len(tasks), schema, db, nlqc,
                tsq_level, tsq_rows)

            if cqs is None:         # invalid task
                continue

            og_rank = correct_rank(db, task['db_id'], kmaps, task['query'], cqs)
            all_tasks += 1
            if og_rank:
                if og_rank == 1:
                    top_1 += 1
                if og_rank <= 5:
                    top_5 += 1
                if og_rank <= 10:
                    top_10 += 1

            if compare:
                cm_cqs = self.run_task(task_id, task, len(tasks), schema,
                    db, nlqc, compare, tsq_rows)
                cm_rank = correct_rank(db, task['db_id'], kmaps, task['query'],
                    cm_cqs)

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
                print('RANK: {}\n'.format(og_rank))

            if cqs:
                f.write(u'\t'.join(cqs))
            else:
                f.write('SELECT A FROM B')  # failure
            f.write('\n')

            gold_f.write(task['query'])
            gold_f.write(f"\t{task['db_id']}")
            gold_f.write('\n')

        print(f'Top 1: {top_1}/{all_tasks} ({(top_1/all_tasks*100):.2f}%)')
        print(f'Top 5: {top_5}/{all_tasks} ({(top_5/all_tasks*100):.2f}%)')
        print(f'Top 10: {top_10}/{all_tasks} ({(top_10/all_tasks*100):.2f}%)')

        f.close()
        gold_f.close()
        nlqc.close()

    def task_thread(self, db, schema, nlqc, tsq, ready):
        address = ('localhost', self.port)
        listener = Listener(address, authkey=self.authkey)
        ready.set()
        print(f'DuoquestServer listening on port {self.port}...')

        conn = listener.accept()
        print('DuoquestServer connection accepted from:', listener.last_accepted)
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
                result = Tribool(None)
                if tsq is not None:
                    result = self.verifier.verify(db, schema, query, tsq)

                if result.value is None:
                    response.results.append(UNKNOWN)
                elif result.value:
                    response.results.append(TRUE)
                else:
                    response.results.append(FALSE)

            conn.send_bytes(response.SerializeToString())
        listener.close()
