class TableSketchQuery:
    def __init__(self, num_cols, types=None, values=None, order=False,
        limit=None):
        self.num_cols = num_cols
        self.values = []

        self.set_types(types)    # array of 'string' or 'number' values
        self.set_values(values)  # array of rows of exact or range values
        self.order = order       # boolean
        self.limit = limit       # int or None

    def set_types(self, types):
        if types is None:
            return

        if len(types) != self.num_cols:
            raise Exception(
                f'{types} does not match number of columns: {self.num_cols}')

        self.types = types

    def add_row(self, row):
        if len(row) != self.num_cols:
            raise Exception(
                f'{row} does not match number of columns: {self.num_cols}')

        self.values.append(row)

    def set_values(self, values):
        if values:
            for row in values:
                self.add_row(row)
        else:
            self.values = []

    def __str__(self):
        return 'num_cols: {}\ntypes:{}\nvalues:{}\norder:{}\nlimit:{}'.format(
            self.num_cols, self.types, self.values, self.order, self.limit
        )
