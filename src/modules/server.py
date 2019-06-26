import threading

from multiprocessing.connection import Listener
from threading import Event, Thread

from .query_pb2 import ProtoQueryList, ProtoResult, FALSE, UNKNOWN, TRUE

class MixtapeServer:
    def __init__(self, port, authkey, mixtape, out_path, n, b):
        self.port = port
        self.authkey = authkey
        self.mixtape = mixtape
        self.out_path = out_path
        self.n = n
        self.b = b

    def run_tasks(self, nlqc, tasks):
        nlqc.connect()
        f = open(self.out_path, 'w+')
        for i, task in enumerate(tasks):
            print('{}/{} || Database: {} || NLQ: {}'.format(i+1, len(tasks),
                task['db_id'], task['question_toks']))

            if self.mixtape.enabled:
                tsq = task['tsq'] if 'tsq' in task else None
                ready = Event()
                t = threading.Thread(target=self.run_task,
                    args=(nlqc, tsq, ready))
                t.start()
                ready.wait()

            cqs = nlqc.run(self.n, self.b, task['db_id'],
                task['question_toks'], self.mixtape.enabled)

            if self.mixtape.enabled:
                t.join()

            if cqs:
                f.write(u'\t'.join(cqs))
            else:
                f.write('SELECT A FROM B')  # failure
            f.write('\n')
        f.close()
        nlqc.close()

    def run_task(self, nlqc, tsq, ready):
        address = ('localhost', self.port)
        listener = Listener(address, authkey=self.authkey)
        ready.set()
        print(f'MixtapeServer listening on port {self.port}...')

        conn = listener.accept()
        print('MixtapeServer connection accepted from:', listener.last_accepted)
        while True:
            msg = conn.recv_bytes()

            if msg == 'close':
                conn.close()
                break

            protolist = ProtoQueryList()
            protolist.ParseFromString(msg)

            response = ProtoResult()
            for query in protolist.queries:
                if tsq is not None:
                    result = self.mixtape.verify(query, tsq)

                if result.value is None:
                    response.results.append(UNKNOWN)
                elif result.value:
                    response.results.append(TRUE)
                else:
                    response.results.append(FALSE)

            conn.send_bytes(response.SerializeToString())
        listener.close()
