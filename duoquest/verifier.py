from tribool import Tribool

from .query import Query, verify_sql_str
from .proto.query_pb2 import TRUE, UNKNOWN, FALSE, COUNT, SUM, MIN, MAX, AVG, \
    NO_SET_OP, INTERSECT, EXCEPT, UNION

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
        if agg_col.col_id == 0:
            # C0 for TSQ generation
            if agg_col.has_agg == FALSE:
                return Tribool(False)

            # only permit COUNT aggregate on * column
            if agg_col.has_agg == TRUE and agg_col.agg != COUNT:
                return Tribool(False)

        if tsq.types:
            tsq_type = tsq.types[pos]
            col_type = schema.get_col(agg_col.col_id).type
            if agg_col.has_agg == TRUE:
                # all aggs must produce a number
                if tsq_type != 'number':
                    return Tribool(False)

                # only COUNT is permitted for text
                if col_type == 'text' and agg_col.agg != COUNT:
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

    def prune_by_structure(self, query, tsq):
        order = to_tribool_proto(query.has_order_by)

        if order.value and not tsq.order:
            return Tribool(False)

        if order.value == False and tsq.order:
            return Tribool(False)

        limit = to_tribool_proto(query.has_limit)

        if limit.value and tsq.limit is None:
            return Tribool(False)

        if limit.value == False and tsq.limit:
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

        # only check structure if not child of a set op
        if lr is None:
            check_structure = self.prune_by_structure(query, tsq)
            if check_structure is not None:
                return check_structure

        if not query.select:        # hasn't even started with select
            return Tribool(None)

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
