from tribool import Tribool

from .query import Query, verify_sql_str
from .proto.query_pb2 import TRUE, UNKNOWN, FALSE, COUNT, SUM, MIN, MAX, AVG, \
    NO_SET_OP, INTERSECT, EXCEPT, UNION, EQUALS, LIKE, IN, NOT_IN, BETWEEN

def to_tribool_proto(proto_tribool):
    if proto_tribool == UNKNOWN:
        return Tribool(None)
    elif proto_tribool == TRUE:
        return Tribool(True)
    else:
        return Tribool(False)

class DuoquestVerifier:
    def __init__(self, use_cache=False):
        if use_cache:
            # TODO: initialize cache
            pass

    def prune_select_col_types(self, db, schema, agg_col, tsq, pos):
        if tsq.types:
            tsq_type = tsq.types[pos]
            col_type = schema.get_col(agg_col.col_id).type
            if agg_col.has_agg == TRUE:
                # all aggs must produce a number
                if tsq_type != 'number':
                    return Tribool(False)
            elif agg_col.has_agg == UNKNOWN:
                # no agg func can convert num -> str
                if col_type == 'number' and tsq_type == 'text':
                    return Tribool(False)
            else:
                # col type must match tsq type
                if col_type != tsq_type:
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
        # query must have same # of columns as TSQ
        if tsq.num_cols != len(query.select):
            return False

        # if any select are not yet complete (i.e. UNKNOWN), not ready
        if any(map(lambda x: x.has_agg == UNKNOWN, query.select)):
            return False

        # if query contains any aggregate, then both WHERE and GROUP BY
        # must be done, if present.
        if any(map(lambda x: x.has_agg == TRUE, query.select)):
            if query.has_where == UNKNOWN or \
                (query.has_where == TRUE and not query.done_where) or \
                query.has_group_by == UNKNOWN or \
                (query.has_group_by == TRUE and not query.done_group_by):
                return False

        # all predicates must be complete if present
        if any(map(lambda x: not self.predicate_complete(x),
            query.where.predicates)):
            return False
        if any(map(lambda x: not self.predicate_complete(x),
            query.having.predicates)):
            return False

        return True

    def prune_by_row(self, db, schema, query, tsq):
        conn = db.get_conn(db_name=schema.db_id)

        for row in tsq.values:
            cur = conn.cursor()
            verify_q = verify_sql_str(query, schema, row)
            print(f'VERIFY: {verify_q}')         # TODO: remove, for debugging
            cur.execute(verify_q)

            if not cur.fetchone():
                return Tribool(False)

            cur.close()
        conn.close()

        return None

    def prune_by_num_cols(self, query, tsq):
        if tsq.num_cols < len(query.select):
            return Tribool(False)    # exceeded max columns already
        else:
            return None              # nothing to prune

    def prune_by_semantics(self, schema, query):
        if query.set_op != NO_SET_OP:
            left = self.prune_by_semantics(schema, query.left)
            right = self.prune_by_semantics(schema, query.right)

            if left is not None or right is not None:
                return Tribool(False)

        for agg_col in query.select:
            col_type = schema.get_col(agg_col.col_id).type
            if agg_col.has_agg == TRUE:
                # for * and text columns, only allow COUNT agg
                if agg_col.agg != COUNT and \
                    (agg_col.col_id == 0 or col_type == 'text'):
                    return Tribool(False)
            elif agg_col.has_agg == FALSE:
                # see I3 in database.py:generate_tsq
                if agg_col.col_id == 0:
                    return Tribool(False)

        for pred in query.where.predicates:
            if pred.col_id == 0:        # cannot have * in where
                return Tribool(False)

            # type-check ops for predicates
            col_type = schema.get_col(pred.col_id).type
            if col_type == 'text' and pred.op not in (EQUALS, LIKE, IN, NOT_IN):
                return Tribool(False)
            if col_type == 'number' and pred.op == LIKE:
                return Tribool(False)

            if pred.has_subquery == TRUE:
                # cannot have BETWEEN op with subqueries
                if pred.op == BETWEEN:
                    return Tribool(False)
                subq = self.prune_by_semantics(schema, pred.subquery)
                if subq is not None:
                    return Tribool(False)

        for pred in query.having.predicates:
            # type check ops; for having, it is always numbers
            if pred.op == LIKE:
                return Tribool(False)

            if pred.has_subquery == TRUE:
                # cannot have BETWEEN op with subqueries
                if pred.op == BETWEEN:
                    return Tribool(False)
                subq = self.prune_by_semantics(schema, pred.subquery)
                if subq is not None:
                    return Tribool(False)

        # ensure there are no * in group by, order by
        if any(map(lambda x: x == 0, query.group_by)):
            return Tribool(False)
        if any(map(lambda x: x.agg_col.col_id == 0, query.order_by)):
            return Tribool(False)

        agg_present = False
        non_agg_present = False
        for agg_col in query.select:
            agg_present = agg_present or agg_col.has_agg == TRUE
            non_agg_present = non_agg_present or agg_col.has_agg == FALSE

        # see I2 in database.py:generate_tsq
        if agg_present and non_agg_present and query.has_group_by == FALSE:
            return Tribool(False)

        # see I4 in database.py:generate_tsq
        if not agg_present and non_agg_present and query.has_group_by == TRUE:
            if query.has_having == FALSE:
                if query.has_order_by == FALSE:
                    return Tribool(False)
                elif query.has_order_by == TRUE and query.done_order_by and \
                    not any(map(lambda x: x.agg_col.has_agg == TRUE,
                        query.order_by)):
                    return Tribool(False)

        # see I5 in database.py:generate_tsq
        if agg_present and not non_agg_present and query.has_group_by == TRUE:
            return Tribool(False)

        return None

    def prune_by_clauses(self, query, tsq):
        # check order by
        if query.has_order_by == TRUE and not tsq.order:
            return Tribool(False)
        if query.has_order_by == FALSE and tsq.order:
            return Tribool(False)

        # check limit
        if query.has_limit == TRUE and not tsq.limit:
            return Tribool(False)
        if query.has_limit == FALSE and tsq.limit:
            return Tribool(False)

        return None

    def verify(self, db, schema, query, tsq, set_op=NO_SET_OP, lr=None):
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

        return Tribool(None)        # return indeterminate
