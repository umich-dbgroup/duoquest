import os
import sqlite3

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


    # TSQ generation process
    # ----------------------
    # Invalid task conditions:
    # I1. Do not permit tasks where MIN/MAX/AVG/SUM is applied to a non-numeric
    #     column.
    # I2. Do not permit tasks where there is (a) a non-aggregated column;
    #     (b) an aggregated column; and (c) no GROUP BY.
    # I3. Do not permit tasks with * projection without COUNT.
    # I4. Do not permit tasks with a GROUP BY when there are only
    #     non-aggregate columns..
    # I5. Do not permit tasks with a GROUP BY when there are only agg
    #     projections.
    # I6. Do not permit tasks where operators are incorrectly applied to a
    #     column with the wrong type.
    # Invalid tasks with subqueries:
    # I7. Do not permit tasks with more than one subquery per set operation
    #     child query.
    # I8. Do not permit tasks where subquery projection is neither (a) the same
    #     as the preceding predicate column nor (b) a FK for it.
    # I9. Do not permit tasks where a subquery has more than 1 WHERE predicate.
    #
    # TSQ generation conditions:
    # C1. User will always correctly specify presence of ORDER BY + LIMIT.
    # C2. Superlatives (ORDER BY + LIMIT) will have empty `values'.
    # C3. If any queries contain nested subqueries in WHERE or HAVING clauses,
    #     `values' will be empty.
    # C4. If ORDER BY present without LIMIT, at least 2 rows will be generated
    #     to allow for ordering enforcement.
    # C5. If result resulting from an aggregate is 0, don't produce range value.
    #
    # TSQ levels
    # ----------
    #             non-aggs |  agg  | types | semantics | clauses | order
    # 'default':    exact  | range |   Y   |     Y     |    Y    |   Y
    # 'no_range':   exact  |   N   |   Y   |     Y     |    Y    |   Y
    # 'no_values':    N    |   N   |   Y   |     Y     |    Y    |   N
    # 'no_duoquest':  N    |   N   |   N   |     N     |    N    |   N

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
        if not agg_present and non_agg_present \
            and 'groupBy' in sql and sql['groupBy'] \
            and not ('orderBy' in sql and sql['orderBy'] \
                and any(map(lambda x: x[1][0] > 0, sql['orderBy'][1]))) \
            and not ('having' in sql and sql['having']):
            print('Failed I4.')
            return None

        # check I5
        if agg_present and not non_agg_present and \
            'groupBy' in sql and sql['groupBy']:
            print('Failed I5.')
            return None

        for pred in sql['where']:
            if isinstance(pred, list):
                op_id = pred[1]
                col_id = pred[2][1][1]

                col_type = schema.get_col(col_id).type
                # 1, 3, 4, 5, 6 = BETWEEN, >, <, >=, <=
                if col_type == 'text' and op_id in (1, 3, 4, 5, 6):
                    print('Failed I6.')
                    return None

                # 9 == LIKE
                if col_type == 'number' and op_id == 9:
                    print('Failed I6.')
                    return None

        for pred in sql['having']:
            if isinstance(pred, list):
                op_id = pred[1]

                # 9 == LIKE
                if op_id == 9:
                    print('Failed I6.')
                    return None

        subq_preds = get_subq_preds(sql)
        if len(subq_preds) > 1:
            print('Failed I7.')
            return None

        set_op_subq_preds = []
        if sql['intersect'] is not None:
            set_op_subq_preds = get_subq_preds(sql['intersect'])
            if len(set_op_subq_preds) > 1:
                print('Failed I7.')
                return None
        elif sql['except'] is not None:
            set_op_subq_preds = get_subq_preds(sql['except'])
            if len(set_op_subq_preds) > 1:
                print('Failed I7.')
                return None
        elif sql['union'] is not None:
            set_op_subq_preds = get_subq_preds(sql['union'])
            if len(set_op_subq_preds) > 1:
                print('Failed I7.')
                return None

        for pred in subq_preds + set_op_subq_preds:
            pred_col, subq = pred

            assert(len(subq['select'][1]) == 1)

            subq_col = subq['select'][1][0][1][1][1]

            if (pred_col != subq_col and \
                pred_col != schema.get_col(subq_col).fk_ref):
                print('Failed I8.')
                return None

            if 'where' in subq and subq['where'] and len(subq['where']) > 1:
                print('Failed I9.')
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

            # perform C4
            if has_order:
                fetch_rows = max(tsq_rows, 2)
            else:
                fetch_rows = tsq_rows

            rows = cur.fetchmany(size=fetch_rows)
            for row in rows:
                value_row = []
                for i, val in enumerate(row):
                    if aggs[i] == 0:              # non-agg case, get exact
                        value_row.append(val)
                    elif tsq_level == 'default' and val != 0:
                        # agg case, only for default
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
