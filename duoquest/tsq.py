from .proto.duoquest_pb2 import ProtoTSQ
from .schema import proto_col_type_to_text

class TableSketchQuery:
    def __init__(self, num_cols, types=None, values=None, order=False,
        limit=None):
        self.num_cols = num_cols
        self.types = None
        self.values = []

        self.set_types(types)    # array of 'string' or 'number' values
        self.set_values(values)  # array of rows of exact or range values
        self.order = order       # boolean
        self.limit = limit       # int or None

    @staticmethod
    def from_proto(proto_tsq_str):
        proto_tsq = ProtoTSQ()
        proto_tsq.ParseFromString(proto_tsq_str)

        types = []
        for type in proto_tsq.types:
            types.append(proto_col_type_to_text(type))

        values = []
        for row in proto_tsq.rows:
            row = []
            for i, cell in enumerate(row.cells):
                if types[i] == 'number':
                    row.append(float(cell))
                else:
                    row.append(cell)
            values.append(row)

        limit = proto_tsq.limit or None
        return TableSketchQuery(proto_tsq.num_cols, types=types, values=values,
            order=proto_tsq.order, limit=limit)

    def set_types(self, types):
        if types is None:
            self.types = types
            return

        if len(types) != self.num_cols:
            raise Exception(
                f'{types} does not match number of columns: {self.num_cols}')

        self.types = types

    def add_row(self, row):
        if len(row) != self.num_cols:
            raise Exception(
                f'{row} does not match number of columns: {self.num_cols}')

        # if all are None, don't add
        if all(map(lambda x: x is None, row)):
            return

        self.values.append(row)

    def set_values(self, values):
        if values:
            for row in values:
                self.add_row(row)
        else:
            self.values = []

    def __str__(self):
        return 'TSQ\n num_cols: {}\n types:{}\n values:{}\n order:{}\n limit:{}'.format(
            self.num_cols, self.types, self.values, self.order, self.limit
        )
