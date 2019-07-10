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
    # Invalid task conditions:
    # I1. Do not permit tasks where MIN/MAX/AVG/SUM is applied to a non-numeric
    #     column.
    # I2. Do not permit tasks where there is (a) a non-aggregated projection;
    #     (b) an aggregated projection; and (c) no GROUP BY.
    # I3. Do not permit tasks with * projection without COUNT.
    # I4. Do not permit tasks with a GROUP BY when there are only
    #     non-agg projections and no aggregates in ORDER BY or HAVING.
    # I5. Do not permit tasks with a GROUP BY when there are only agg
    #     projections.
    #
    # TSQ generation conditions:
    # C1. User will always correctly specify presence of ORDER BY + LIMIT.
    # C2. Superlatives (ORDER BY + LIMIT) will have empty `values'.
    # C3. If any queries contain nested subqueries in WHERE or HAVING clauses,
    #     `values' will be empty.
    #
    # TSQ levels
    # ----------
    #             non-aggs |  agg  | types | semantics
    # 'default':    exact  | range |   Y   |     Y
    # 'no_range':   exact  |   N   |   Y   |     Y
    # 'no_values':    N    |   N   |   Y   |     Y
    # 'no_duoquest':  N    |   N   |   N   |     N

    def generate_tsq(self, schema, sql_str, sql, tsq_level, tsq_rows):
        aggs = []
        types = []

        agg_present = False
        non_agg_present = False

        for agg, val_unit in sql['select'][1]:
            _, col_id, _ = val_unit[1]

            # check I3
            if col_id == 0 and agg != 3:
                print('Failed I3.')
                return None

            aggs.append(agg)   # store for later when getting `values'

            col_type = schema.get_col(col_id).type

            # check I1
            if agg in (1, 2, 4, 5) and col_type != 'number':
                print('Failed I1.')
                return None

            agg_present = agg_present or agg > 0
            non_agg_present = non_agg_present or agg == 0

            # all aggs must produce a number
            if agg > 0:
                types.append('number')
            else:
                types.append(col_type)

        # check I2
        if agg_present and non_agg_present and \
            not ('groupBy' in sql and sql['groupBy']):
            print('Failed I2.')
            return None

        # check I4
        if agg_present == False and non_agg_present == True \
            and 'groupBy' in sql and sql['groupBy'] \
            and not ('orderBy' in sql and sql['orderBy'] \
                and any(map(lambda x: x[1][0] > 0, sql['orderBy'][1]))) \
            and not ('having' in sql and sql['having']):
            print('Failed I4.')
            return None

        # check I5
        if agg_present == True and non_agg_present == False and \
            'groupBy' in sql and sql['groupBy']:
            print('Failed I5.')
            return None

        tsq = TableSketchQuery(len(types),
            types=types if tsq_level != 'no_type' else None)

        # perform C1
        has_order = 'orderBy' in sql and sql['orderBy']
        has_limit = 'limit' in sql and sql['limit']
        if has_order:
            tsq.order = True
        if has_limit:
            tsq.limit = sql['limit']

        # don't retrieve values for no_values or no_type
        if tsq_level in ('no_values', 'no_type'):
            return tsq

        # perform C2
        if has_order and has_limit:
            return tsq

        # perform C3
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
