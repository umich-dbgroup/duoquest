from tribool import Tribool

from .query import Query, verify_sql_str, generate_sql_str
from .proto.query_pb2 import TRUE, UNKNOWN, FALSE, COUNT, SUM, MIN, MAX, AVG, \
    NO_SET_OP, INTERSECT, EXCEPT, UNION, EQUALS, NEQ, LIKE, IN, NOT_IN, \
    BETWEEN, OR

def to_tribool_proto(proto_tribool):
    if proto_tribool == UNKNOWN:
        return Tribool(None)
    elif proto_tribool == TRUE:
        return Tribool(True)
    else:
        return Tribool(False)

class DuoquestVerifier:
    def __init__(self, use_cache=False, debug=False):
        if use_cache:
            # TODO: initialize cache
            pass

        self.debug = debug

    def prune_select_col_types(self, db, schema, agg_col, tsq, pos):
        if tsq.types:
            tsq_type = tsq.types[pos]
            col_type = schema.get_col(agg_col.col_id).type
            if agg_col.has_agg == TRUE:
                if tsq_type != 'number':
                    if self.debug:
                        print('Prune: all aggs must produce numeric output.')
                    return Tribool(False)
            elif agg_col.has_agg == UNKNOWN:
                if col_type == 'number' and tsq_type == 'text':
                    if self.debug:
                        print('Prune: cannot output text from numeric column.')
                    return Tribool(False)
            else:
                if col_type != tsq_type:
                    if self.debug:
                        print('Prune: column type does not match TSQ type.')
                    return Tribool(False)

    def prune_select_col_values(self, db, schema, agg_col, tsq, pos):
        for row in tsq.values:
            if row[pos] is None:                # empty cell
                continue
            elif isinstance(row[pos], list):    # range constraint
                pass                            # TODO
            else:                               # exact constraint
                if agg_col.has_agg == TRUE:
                    pass                        # TODO
                elif agg_col.has_agg == FALSE or \
                    (tsq.types and tsq.types[pos] == 'text'):
                    if not db.has_exact(schema, agg_col.col_id, row[pos]):
                        if self.debug:
                            col_name = schema.get_col(agg_col.col_id).sem_name
                            print(f'Prune: <{row[pos]}> not in <{col_name}>.')
                        return Tribool(False)
                else:        # if aggregate is UNKNOWN
                    pass

        return None

    def predicate_complete(self, pred):
        if pred.has_subquery == UNKNOWN:
            return False
        elif pred.has_subquery == TRUE:
            return pred.subquery.done_limit
        else:
            return len(pred.value) > 0

    def ready_for_row_check(self, query, tsq):
        if not query.done_select:
            return False

        # all WHERE/HAVING predicates must be complete if present
        if any(map(lambda x: not self.predicate_complete(x),
            query.where.predicates)):
            return False
        if any(map(lambda x: not self.predicate_complete(x),
            query.having.predicates)):
            return False

        # if logical op is an OR for WHERE/HAVING, the clause must be complete
        if query.where.logical_op == OR and not query.done_where:
            return False
        if query.having.logical_op == OR and not query.done_having:
            return False

        # if GROUP BY is present, must be done
        if query.has_group_by == TRUE and not query.done_group_by:
            return False

        # if query contains any aggregate, then WHERE must be done if present
        if any(map(lambda x: x.has_agg == TRUE, query.select)):
            if query.has_where == UNKNOWN or \
                (query.has_where == TRUE and not query.done_where):
                return False
        else:
            # when query has GROUP BY and no aggregate in select
            # make sure that HAVING and ORDER BY are both complete if present
            if query.has_group_by == TRUE:
                if query.has_having == UNKNOWN or \
                    query.has_order_by == UNKNOWN or \
                    (query.has_having == TRUE and not query.done_having) or \
                    (query.has_order_by == TRUE and not query.done_order_by):
                    return False

        return True

    def ready_for_order_check(self, query, tsq):
        if not tsq.order:
            return False

        if not query.order_by:
            return False

        # if aggregate is not set for any order_by, not ready
        if any(map(lambda x: x.agg_col.has_agg == UNKNOWN, query.order_by)):
            return False

        return True

    def prune_by_row(self, db, schema, query, tsq):
        conn = db.get_conn(db_name=schema.db_id)

        for row in tsq.values:
            cur = conn.cursor()
            verify_q = verify_sql_str(query, schema, row)
            if self.debug:
                print(f'VERIFY: {verify_q}')
            cur.execute(verify_q)

            if not cur.fetchone():
                return Tribool(False)

            cur.close()
        conn.close()

        return None

    def first_matching_row(self, db_row, tsq_rows):
        for i, tsq_row in enumerate(tsq_rows):
            try:
                if self.row_result_matches(db_row, tsq_row):
                    return i
            except Exception as e:
                # exception for non-utf-8 strings breaking when typecasting
                continue
        return None

    def row_result_matches(self, db_row, tsq_row):
        for pos, val in enumerate(tsq_row):
            if isinstance(val, list):     # range constraint
                if float(db_row[pos]) < val[0] or float(db_row[pos]) > val[1]:
                    return False
            else:                           # exact constraint
                if db_row[pos].decode('utf-8') != val:
                    return False
        return True

    def prune_by_order(self, db, schema, query, tsq):
        conn = db.get_conn(db_name=schema.db_id)
        conn.text_factory = bytes

        cur = conn.cursor()
        # TODO: to speed up instead of generate_sql_str, we could do a variation
        # of verify_sql_str where we put (col = val1 or col = val2) as part of
        # the sql_str for each value
        cur.execute(generate_sql_str(query, schema))

        values_copy = list(tsq.values)

        prune = False
        while values_copy:
            db_row = cur.fetchone()
            if db_row is None:
                break

            index = self.first_matching_row(db_row, values_copy)
            if index is None:
                continue
            elif index == 0:
                values_copy = values_copy[1:]
            else:
                prune = True
                break

        if prune:
            if self.debug:
                print('Prune: ordering is incorrect.')
            return Tribool(False)
        elif values_copy:
            raise Exception('Did not find matching row for all TSQ rows.')
        else:
            return None

    def prune_by_num_cols(self, query, tsq):
        if query.done_select and tsq.num_cols != len(query.select):
            if self.debug:
                print('Prune: number of columns does not match TSQ.')
            return Tribool(False)
        if tsq.num_cols < len(query.select):
            if self.debug:
                print('Prune: number of columns exceeds TSQ.')
            return Tribool(False)
        else:
            return None

    def prune_by_semantics(self, schema, query):
        if query.set_op != NO_SET_OP:
            left = self.prune_by_semantics(schema, query.left)
            right = self.prune_by_semantics(schema, query.right)

            if left is not None or right is not None:
                return Tribool(False)

        for agg_col in query.select:
            col_type = schema.get_col(agg_col.col_id).type
            if agg_col.has_agg == TRUE:
                if agg_col.agg != COUNT and \
                    (agg_col.col_id == 0 or col_type == 'text'):
                    if self.debug:
                        print('Prune: only COUNT() permitted for * and text.')
                    return Tribool(False)
            elif agg_col.has_agg == FALSE:
                if agg_col.col_id == 0:
                    if self.debug:
                        print('Prune: cannot have * without COUNT().')
                    return Tribool(False)

        for pred in query.where.predicates:
            if pred.col_id == 0:
                if self.debug:
                    print('Prune: cannot have * in WHERE clause.')
                return Tribool(False)

            col_type = schema.get_col(pred.col_id).type
            if col_type == 'text' and \
                pred.op not in (EQUALS, NEQ, LIKE, IN, NOT_IN):
                if self.debug:
                    print('Prune: invalid op for text column.')
                return Tribool(False)
            if col_type == 'number' and pred.op == LIKE:
                if self.debug:
                    print('Prune: cannot have LIKE with numeric column.')
                return Tribool(False)

            if pred.has_subquery == TRUE:
                if pred.op == BETWEEN:
                    if self.debug:
                        print('Prune: cannot have BETWEEN with subquery.')
                    return Tribool(False)
                subq = self.prune_by_semantics(schema, pred.subquery)
                if subq is not None:
                    return Tribool(False)

        for pred in query.having.predicates:
            if pred.op == LIKE:
                if self.debug:
                    print('Prune: cannot have LIKE in HAVING clause.')
                return Tribool(False)

            if pred.has_subquery == TRUE:
                if pred.op == BETWEEN:
                    if self.debug:
                        print('Prune: cannot have BETWEEN with subquery.')
                    return Tribool(False)
                subq = self.prune_by_semantics(schema, pred.subquery)
                if subq is not None:
                    return Tribool(False)

        if any(map(lambda x: x == 0, query.group_by)):
            if self.debug:
                print('Prune: cannot have * in GROUP BY.')
            return Tribool(False)

        if any(map(lambda x: x.agg_col.has_agg != UNKNOWN and \
            x.agg_col.agg != COUNT and x.agg_col.col_id == 0, query.order_by)):
                if self.debug:
                    print('Prune: cannot have * without COUNT() in ORDER BY.')
                return Tribool(False)

        if query.done_select:
            agg_present = False
            non_agg_present = False
            for agg_col in query.select:
                agg_present = agg_present or agg_col.has_agg == TRUE
                non_agg_present = non_agg_present or agg_col.has_agg == FALSE

            if agg_present and non_agg_present \
                and query.has_group_by == FALSE:
                if self.debug:
                    print('Prune: failed condition I2.')
                return Tribool(False)

            if not agg_present and non_agg_present \
                and query.has_group_by == TRUE:
                if query.has_having == FALSE:
                    if query.has_order_by == FALSE:
                        if self.debug:
                            print('Prune: failed condition I4.')
                        return Tribool(False)
                    elif query.has_order_by == TRUE and query.done_order_by \
                        and not any(map(lambda x: x.agg_col.has_agg == TRUE,
                            query.order_by)):
                        if self.debug:
                            print('Prune: failed condition I4.')
                        return Tribool(False)

            if agg_present and not non_agg_present \
                and query.has_group_by == TRUE:
                if self.debug:
                    print('Prune: failed condition I5.')
                return Tribool(False)

        return None

    def prune_by_clauses(self, query, tsq):
        if query.has_order_by == TRUE and not tsq.order:
            if self.debug:
                print('Prune: query has ORDER BY when TSQ has none.')
            return Tribool(False)
        if query.has_order_by == FALSE and tsq.order:
            if self.debug:
                print('Prune: query has no ORDER BY when TSQ does.')
            return Tribool(False)

        if query.has_limit == TRUE and not tsq.limit:
            if self.debug:
                print('Prune: query has LIMIT when TSQ has none.')
            return Tribool(False)
        if query.has_limit == FALSE and tsq.limit:
            if self.debug:
                print('Prune: query has no LIMIT when TSQ does.')
            return Tribool(False)

        return None

    def verify(self, db, schema, query, tsq, set_op=NO_SET_OP, lr=None):
        if self.debug:
            print(query)

        if query.set_op != NO_SET_OP:
            left = self.verify(db, schema, query.left, tsq, set_op=query.set_op,
                lr='left')
            right = self.verify(db, schema, query.right, tsq,
                set_op=query.set_op, lr='right')
            if left.value == False or right.value == False:
                return Tribool(False)
            else:
                return Tribool(None)

        # only check clauses if not child of a set op
        if lr is None:
            check_clauses = self.prune_by_clauses(query, tsq)
            if check_clauses is not None:
                return check_clauses

        if not query.select:        # hasn't even started with select
            return Tribool(None)

        check_semantics = self.prune_by_semantics(schema, query)
        if check_semantics is not None:
            return check_semantics

        check_num_cols = self.prune_by_num_cols(query, tsq)
        if check_num_cols is not None:
            return check_num_cols

        # if not child of UNION or right child of EXCEPT, can check values
        can_check_values = tsq.values and \
            set_op != UNION and \
            not (set_op == EXCEPT and lr == 'right')

        for i, aggcol in enumerate(query.select):
            check_types = self.prune_select_col_types(db, schema, aggcol, tsq,
                i)
            if check_types is not None:
                return check_types

            if can_check_values:
                check_values = self.prune_select_col_values(db, schema, aggcol,
                    tsq, i)
                if check_values is not None:
                    return check_values

        if can_check_values and self.ready_for_row_check(query, tsq):
            check_row = self.prune_by_row(db, schema, query, tsq)
            if check_row is not None:
                return check_row

        if self.ready_for_order_check(query, tsq):
            check_order = self.prune_by_order(db, schema, query, tsq)
            if check_order is not None:
                return check_order

        return Tribool(None)        # return indeterminate
