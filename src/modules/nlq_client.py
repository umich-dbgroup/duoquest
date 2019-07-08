from multiprocessing.connection import Client

from .task_pb2 import ProtoTask, ProtoCandidates

class NLQClient:
    def __init__(self, port, authkey, dataset, mode):
        self.port = port
        self.authkey = authkey
        self.dataset = dataset
        self.mode = mode

    def connect(self):
        address = ('localhost', self.port)
        self.conn = Client(address, authkey=self.authkey)

    def run(self, tid, n, b, db_name, nlq, enable_duoquest):
        task = ProtoTask()
        task.id = tid
        task.dataset = self.dataset
        task.mode = self.mode
        task.n = n
        task.b = b
        task.enable_duoquest = enable_duoquest
        task.db_name = db_name
        if isinstance(nlq, list):
            for token in nlq:
                task.nlq_tokens.append(token)
        else:
            task.nlq_tokens.append(nlq)

        self.conn.send_bytes(task.SerializeToString())
        msg = self.conn.recv_bytes()
        proto_cands = ProtoCandidates()
        proto_cands.ParseFromString(msg)
        return list(proto_cands.cq)

    def close(self):
        self.conn.send_bytes(b'close')
        self.conn.close()
