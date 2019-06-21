from multiprocessing.connection import Client

from .task_pb2 import ProtoTask, ProtoCandidates

class TaskClient:
    def __init__(self, port, authkey):
        self.port = port
        self.authkey = authkey

    def connect(self):
        address = ('localhost', self.port)
        self.conn = Client(address, authkey=self.authkey)

    def run(self, db_name, nlq):
        task = ProtoTask()
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
