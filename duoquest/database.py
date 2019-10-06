import os
import random
import sqlite3
import traceback

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

        q = 'SELECT MIN("{}"), MAX("{}") FROM "{}"'.format(
            col.syn_name, col.syn_name, col.table.syn_name
        )
        cur.execute(q)

        valid = False
        row = cur.fetchone()
        try:
            if row:
                col_min = float(row[0])
                col_max = float(row[1])

                if max(col_min, range_val[0]) <= min(col_max, range_val[1]):
                    valid = True
        except Exception as e:
            traceback.print_exc()
        finally:
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

    def generate_tsq(self, tid, schema, sql_str, pq, tsq_level, tsq_rows):
        types = []
        for ac in pq.select:
            if ac.has_agg == TRUE:
                types.append('number')
            else:
                types.append(schema.get_col(ac.col_id).type)

        tsq = TableSketchQuery(len(types), types=types)

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
                elif tsq_level in ('default', 'chain', 'partial'):
                    value_row.append([val*0.5, val*1.5])
                else:                         # otherwise keep empty
                    value_row.append(None)
            tsq.add_row(value_row)

        cur.close()
        conn.close()

        if tsq is not None:
            if tsq_level == 'partial':
                # only do partial if > 1 column
                if len(tsq.values) > 0 and tsq.num_cols > 1:
                    random.seed(tid)
                    clear_col = random.randint(0, tsq.num_cols-1)
                    for row in tsq.values:
                        row[clear_col] = None

            if tsq_level == 'minimal':
                tsq.values = []

        return tsq
