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
        task.nlq = nlq

        print('sending: {}'.format(task.SerializeToString()))
        self.conn.send_bytes(task.SerializeToString())
        msg = self.conn.recv_bytes()
        sqls = ProtoCandidates.ParseFromString(msg)
        return sqls

    def close(self):
        self.conn.send_bytes(b'close')
        self.conn.close()
