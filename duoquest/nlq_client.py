from multiprocessing.connection import Client

from .proto.task_pb2 import ProtoTask, ProtoCandidates

class NLQClient:
    def __init__(self, port, authkey, dataset, mode):
        self.port = port
        self.authkey = authkey
        self.dataset = dataset
        self.mode = mode

    def connect(self):
        address = ('localhost', self.port)
        self.conn = Client(address, authkey=self.authkey)

    def run(self, tid, n, db_name, nlq, tsq_level, timeout=None):
        task = ProtoTask()
        task.id = tid
        task.dataset = self.dataset
        task.mode = self.mode
        task.n = n
        task.tsq_level = tsq_level
        task.db_name = db_name
        task.timeout = timeout
        if isinstance(nlq, list):
            for token in nlq:
                task.nlq_tokens.append(token)
        else:
            task.nlq_tokens.append(nlq)

        self.conn.send_bytes(task.SerializeToString())
        msg = self.conn.recv_bytes()
        proto_cands = ProtoCandidates()
        proto_cands.ParseFromString(msg)
        return list(
            map(lambda x: str(x).encode('unicode_escape').decode('utf-8'),
                proto_cands.cq)
        )

    def close(self):
        self.conn.send_bytes(b'close')
        self.conn.close()
