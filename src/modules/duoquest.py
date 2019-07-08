from tribool import Tribool

from .query import Query
from .query_pb2 import TRUE, UNKNOWN, FALSE, COUNT, SUM, MIN, MAX, AVG, \
    NO_SET_OP, INTERSECT, EXCEPT, UNION

def to_tribool_proto(proto_tribool):
    if proto_tribool == UNKNOWN:
        return Tribool(None)
    elif proto_tribool == TRUE:
        return Tribool(True)
    else:
        return Tribool(False)

class Duoquest:
    def __init__(self, use_cache=False):
        if use_cache:
            # TODO: initialize cache
            pass

    def prune_select_column(self, db, schema, agg_col, tsq, pos):
        if agg_col.col_id == 0:
            # C0 for TSQ generation
            if agg_col.has_agg == FALSE:
                return Tribool(False)

            # only permit COUNT aggregate on * column
            if agg_col.has_agg and agg_col.agg != COUNT:
                return Tribool(False)

        if tsq.types:
            tsq_type = tsq.types[pos]
            col_type = schema.get_col(agg_col.col_id).type
            if agg_col.has_agg == TRUE:
                # all aggs must produce a number
                if agg_col.agg in (MIN, MAX, AVG, COUNT, SUM) and \
                    tsq_type != 'number':
                    return Tribool(False)
            elif agg_col.has_agg == UNKNOWN:
                # no agg func can convert num -> str
                if col_type == 'number' and tsq_type == 'text':
                    return Tribool(False)
            else:
                # col type must match tsq type
                if col_type != tsq_type:
                    return Tribool(False)

        if tsq.values:
            for row in tsq.values:
                if row[pos] is None:                # empty cell
                    continue
                elif isinstance(row[pos], list):    # range constraint
                    pass                            # TODO
                else:                               # exact constraint
                    if agg_col.has_agg:
                        pass                        # TODO
                    else:
                        if not db.has_exact(schema, agg_col.col_id, row[pos]):
                            return Tribool(False)

        return None

    def ready_for_row_check(self, query, tsq):
        if query.set_op == NO_SET_OP:
            # query must have same # of columns as TSQ
            if tsq.num_cols != len(query.select):
                return False

            # if query contains AVG/COUNT/SUM, then GROUP BY must be complete
            # this is because these functions change the output domain
            if any(map(lambda x: x.agg in (AVG, COUNT, SUM), query.select)):
                if query.has_group_by == UNKNOWN or \
                    (query.has_group_by == TRUE and not query.group_by):
                    return False
        elif query.set_op == UNION:
            # if UNION, both subqueries must be ready
            return self.ready_for_row_check(query.left) and \
                self.ready_for_row_check(query.right)
        elif query.set_op == INTERSECT:
            # if INTERSECT, at least one subquery must be ready
            return self.ready_for_row_check(query.left) or \
                self.ready_for_row_check(query.right)
        elif query.set_op == EXCEPT:
            # if EXCEPT, only left subquery must be ready
            return self.ready_for_row_check(query.left)
        else:
            raise Exception(f'Unknown set_op: {query.set_op}')

        return True

    def prune_by_row(self, db, schema, query, tsq):
        query = Query(schema, query)

        for sql, jp in query.sqls():
            # TODO: cache join path generation somehow

            # TODO: wrap SQL query to check TSQ values
            pass

        # TODO: if none of the SQLs worked, return Tribool(False)

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

    def verify(self, db, schema, query, tsq):
        check_structure = self.prune_by_structure(query, tsq)
        if check_structure is not None:
            return check_structure

        if not query.select:
            return Tribool(None)    # hasn't even started with select

        check_num_cols = self.prune_by_num_cols(query, tsq)
        if check_num_cols is not None:
            return check_num_cols

        for i, aggcol in enumerate(query.select):
            check_col = self.prune_select_column(db, schema, aggcol, tsq, i)
            if check_col is not None:
                return check_col

        # TODO
        # if self.ready_for_row_check(query, tsq):
        #     check_row = self.prune_by_row(db, schema, query, tsq)
        #     if check_row is not None:
        #         return check_row

        return Tribool(None)        # return indeterminate
