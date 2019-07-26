from multiprocessing.connection import Client

from .proto.duoquest_pb2 import ProtoTask, ProtoCandidates
from .query import generate_sql_str

class NLQClient:
    def __init__(self, port, authkey, dataset, mode):
        self.port = port
        self.authkey = authkey
        self.dataset = dataset
        self.mode = mode

    def connect(self):
        address = ('localhost', self.port)
        self.conn = Client(address, authkey=self.authkey)

    def run(self, tid, schema, nlq, tsq_level, timeout=None):
        task = ProtoTask()
        task.id = tid
        task.dataset = self.dataset
        task.mode = self.mode
        task.tsq_level = tsq_level
        task.db_name = schema.db_id
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
            map(lambda x: generate_sql_str(x, schema), proto_cands.cqs)
        )

    def close(self):
        self.conn.send_bytes(b'close')
        self.conn.close()
