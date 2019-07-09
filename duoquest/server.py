import threading
from tribool import Tribool

from multiprocessing.connection import Listener
from threading import Event, Thread

from .proto.query_pb2 import ProtoQueryList, ProtoResult, FALSE, UNKNOWN, TRUE
from .external.eval import correct_rank

class DuoquestServer:
    def __init__(self, port, authkey, duoquest, out_path, gold_path, n, b):
        self.port = port
        self.authkey = authkey
        self.duoquest = duoquest
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
        tid=None, compare=None):
        nlqc.connect()
        f = open(self.out_path, 'w+')
        gold_f = open(self.gold_path, 'w+')
        for i, task in enumerate(tasks):
            task_id = i+1
            if tid and task_id != tid:
                continue

            schema = schemas[task['db_id']]
            cqs = self.run_task(task_id, task, len(tasks), schema, db, nlqc,
                tsq_level, tsq_rows)

            if compare:
                cm_cqs = self.run_task(task_id, task, len(tasks), schema,
                    db, nlqc, compare, tsq_rows)
                og_rank = correct_rank(db, task['db_id'], task['query'], cqs)
                cm_rank = correct_rank(db, task['db_id'], task['query'], cm_cqs)

                if cm_rank is not None:
                    if og_rank is None or og_rank > cm_rank:
                        print('Warning: Task degraded vs. {compare}!')

            if cqs is None:         # invalid task
                continue
            elif cqs:
                f.write(u'\t'.join(cqs))
            else:
                f.write('SELECT A FROM B')  # failure
            f.write('\n')

            gold_f.write(task['query'])
            gold_f.write(f'\t{task['db_id']}')
            gold_f.write('\n')
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
                    result = self.duoquest.verify(db, schema, query, tsq)

                if result.value is None:
                    response.results.append(UNKNOWN)
                elif result.value:
                    response.results.append(TRUE)
                else:
                    response.results.append(FALSE)

            conn.send_bytes(response.SerializeToString())
        listener.close()
