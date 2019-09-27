import os
import sqlite3

from .proto.duoquest_pb2 import *
from .tsq import TableSketchQuery

def get_subq_preds(sql):
    preds = []      # (col_id, subquery)
    for cond_unit in sql['where'][::2] + sql['having'][::2]:
        if isinstance(cond_unit[3], dict):
            preds.append(
                (cond_unit[2][1][1], cond_unit[3])
            )
        if isinstance(cond_unit[4], dict):
            preds.append(
                (cond_unit[2][1][1], cond_unit[3])
            )
    return preds

class Database(object):
    def __init__(self, db_path, dataset, db_name=None):
        self.db_path = db_path
        self.dataset = dataset

        if dataset == 'spider':
            self.db_names = os.listdir(self.db_path)
            self.conn = None
        elif dataset == 'wikisql':
            self.conn = sqlite3.connect(self.db_path)
            cur = self.conn.cursor()
            cur.execute("SELECT name FROM sqlite_master WHERE type = 'table'")
            self.db_names = [row[0] for row in cur.fetchall()]
            cur.close()
        else:
            self.db_names = [db_name]

    def has_db(self, db_name):
        return db_name in self.db_names

    def get_conn(self, db_name=None):
        if self.dataset == 'spider':
            db_path = os.path.join(self.db_path, db_name,
                '{}.sqlite'.format(db_name))
            conn = sqlite3.connect(db_path)
        elif self.dataset == 'wikisql':
            conn = self.conn
        else:
            conn = sqlite3.connect(self.db_path)
        return conn

    def intersects_range(self, schema, col_id, range_val):
        conn = self.get_conn(db_name=schema.db_id)
        cur = conn.cursor()

        col = schema.get_col(col_id)

        # star cannot have value
        if col.syn_name == '*':
            return False

        q = '''SELECT 1 FROM "{}" WHERE CAST("{}" AS FLOAT) >= ?
               AND CAST("{}" AS FLOAT) <= ? LIMIT 1'''.format(
            col.table.syn_name, col.syn_name, col.syn_name
        )

        cur.execute(q, (range_val[0], range_val[1]))

        valid = False
        if cur.fetchone():
            valid = True

        cur.close()
        conn.close()

        return valid

    def has_exact(self, schema, col_id, value):
        conn = self.get_conn(db_name=schema.db_id)
        cur = conn.cursor()

        col = schema.get_col(col_id)

        # star cannot have value
        if col.syn_name == '*':
            return False

        cur.execute('SELECT 1 FROM "{}" WHERE "{}" = ? LIMIT 1'.format(
            col.table.syn_name, col.syn_name
        ), (value,))

        valid = False
        if cur.fetchone():
            valid = True

        cur.close()
        conn.close()

        return valid

    # TSQ generation conditions
    # ----------------------
    # C1. User will always correctly specify presence of ORDER BY + LIMIT.
    # C2. If ORDER BY present, at least 2 rows will be generated
    #     to allow for ordering enforcement.
    #
    # TSQ levels
    # ----------
    #             non-aggs |  agg  | types | semantics | clauses | order
    # 'default':    exact  | range |   Y   |     Y     |    Y    |   Y
    # 'no_range':   exact  |   N   |   Y   |     Y     |    Y    |   Y
    # 'no_values':    N    |   N   |   Y   |     Y     |    Y    |   N
    # 'no_duoquest':  N    |   N   |   N   |     N     |    N    |   N

    def generate_tsq(self, schema, sql_str, pq, tsq_level, tsq_rows):
        types = []
        for ac in pq.select:
            if ac.has_agg == TRUE:
                types.append('number')
            else:
                types.append(schema.get_col(ac.col_id).type)

        tsq = TableSketchQuery(len(types),
            types=types if tsq_level != 'no_type' else None)

        # perform C1
        tsq.order = (pq.has_order_by == TRUE)
        if pq.has_limit == TRUE:
            tsq.limit = pq.limit

        # Finding values
        conn = self.get_conn(db_name=schema.db_id)
        cur = conn.cursor()
        cur.execute(sql_str)

        # perform C2
        if tsq.order:
            fetch_rows = max(tsq_rows, 2)
        else:
            fetch_rows = tsq_rows

        rows = cur.fetchmany(size=fetch_rows)

        for row in rows:
            value_row = []
            for i, val in enumerate(row):
                if pq.select[i].has_agg == FALSE:  # non-agg case, get exact
                    value_row.append(val)
                elif tsq_level in ('default', 'chain'):
                    value_row.append([val*0.5, val*1.5])
                else:                         # otherwise keep empty
                    value_row.append(None)
            tsq.add_row(value_row)

        cur.close()
        conn.close()

        if tsq is not None:
            # don't retrieve values for no_values or no_type
            if tsq_level in ('no_values', 'no_type'):
                tsq.values = []

        return tsq
