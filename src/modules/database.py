import os
import sqlite3

from .tsq import TableSketchQuery

class Database(object):
    def __init__(self, db_path, dataset):
        self.db_path = db_path
        self.dataset = dataset

        if dataset == 'spider':
            self.db_names = os.listdir(self.db_path)
            self.conn = None
        else:
            self.conn = sqlite3.connect(self.db_path)
            cur = self.conn.cursor()
            cur.execute("SELECT name FROM sqlite_master WHERE type = 'table'")
            self.db_names = [row[0] for row in cur.fetchall()]
            cur.close()

    def has_db(self, db_name):
        return db_name in self.db_names

    def get_conn(self, db_name=None):
        if self.dataset == 'spider':
            db_path = os.path.join(self.db_path, db_name,
                '{}.sqlite'.format(db_name))
            conn = sqlite3.connect(db_path)
        else:
            db_path = self.db_path
            conn = self.conn
        return conn

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


    # TSQ generation process
    # ----------------------
    # Assume: User will always correctly specify presence of ORDER BY + LIMIT.
    # C0. Do not permit any tasks with `*' projection without COUNT
    #     (ambiguous TSQ).
    # C1. Superlatives (ORDER BY + LIMIT) will have empty `values'.
    # C2. If any queries contain nested subqueries in WHERE or HAVING clauses,
    #     `values' will be empty.
    #
    # TSQ levels
    # ----------
    #             non-aggs |  agg  | types |
    # 'default':    exact  | range |   Y   |
    # 'no_range':   exact  |   N   |   Y   |
    # 'no_values':    N    |   N   |   Y   |
    # 'no_duoquest':  N    |   N   |   N   |

    def generate_tsq(self, schema, sql_str, sql, tsq_level, tsq_rows):
        aggs = []
        types = []
        for agg, val_unit in sql['select'][1]:
            _, col_id, _ = val_unit[1]

            # check C0
            if col_id == 0 and agg != 3:
                return None

            aggs.append(agg)   # store for later when getting `values'

            if agg == 3:   # COUNT is always numeric result
                types.append('number')
            else:
                types.append(schema.get_col(col_id).type)

        tsq = TableSketchQuery(len(types),
            types=types if tsq_level != 'no_type' else None)

        has_order = 'orderBy' in sql and sql['orderBy']
        has_limit = 'limit' in sql and sql['limit']
        if has_order:
            tsq.order = True
        if has_limit:
            tsq.limit = sql['limit']

        # don't retrieve values for no_values or no_type
        if tsq_level in ('no_values', 'no_type'):
            return tsq

        # check C1
        if has_order and has_limit:
            return tsq

        # check C2
        for item in sql['where']:
            if isinstance(item, list):
                val1 = item[3]
                if isinstance(val1, dict):
                    return tsq
        for item in sql['having']:
            if isinstance(item, list):
                val1 = item[3]
                if isinstance(val1, dict):
                    return tsq

        # Finding values
        conn = self.get_conn(db_name=schema.db_id)
        cur = conn.cursor()
        try:
            cur.execute(sql_str)
            rows = cur.fetchmany(size=tsq_rows)
            for row in rows:
                value_row = []
                for i, val in enumerate(row):
                    if aggs[i] == 0:              # non-agg case, get exact
                        value_row.append(val)
                    elif tsq_level == 'default':  # agg case, only for default
                        value_row.append([val*0.5, val*1.5])
                    else:                         # otherwise keep empty
                        value_row.append(None)
                tsq.add_row(value_row)
        except Exception as e:
            print(e)
            tsq = None
        finally:
            cur.close()
            conn.close()
            return tsq
