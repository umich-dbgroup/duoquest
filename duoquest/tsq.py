import json

from .proto.duoquest_pb2 import ProtoTSQ
from .schema import proto_col_type_to_text, text_to_proto_col_type

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

    def to_proto(self):
        proto_tsq = ProtoTSQ()
        proto_tsq.num_cols = self.num_cols
        proto_tsq.order = self.order
        proto_tsq.limit = self.limit or 0

        for t in self.types:
            proto_tsq.types.append(text_to_proto_col_type(t))

        for row in self.values:
            proto_row = proto_tsq.rows.add()
            for cell in row:
                proto_row.cells.append(cell or '')
        return proto_tsq

    @staticmethod
    def from_proto(proto_tsq_str):
        proto_tsq = ProtoTSQ()
        proto_tsq.ParseFromString(proto_tsq_str)

        types = []
        for type in proto_tsq.types:
            types.append(proto_col_type_to_text(type))

        values = []
        for proto_row in proto_tsq.rows:
            row = []
            for i, cell in enumerate(proto_row.cells):
                if cell == '':
                    row.append(None)
                else:
                    if types[i] == 'number':
                        if cell.startswith('[') and cell.endswith(']'):
                            row.append(json.loads(cell))
                        else:
                            float_val = float(cell)
                            if float_val.is_integer():
                                row.append(int(float_val))
                            else:
                                row.append(float_val)
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
