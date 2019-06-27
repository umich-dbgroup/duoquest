from tribool import Tribool

from .query_pb2 import TRUE, UNKNOWN, FALSE, COUNT, SUM, MIN, MAX, AVG

class Mixtape:
    def __init__(self, use_cache=False):
        if use_cache:
            # TODO: initialize cache
            pass

    def prune_select_column(self, db, schema, agg_col, tsq, pos):
        if tsq.types:
            tsq_type = tsq.types[pos]
            col_type = schema.get_col(agg_col.col_id).type
            if agg_col.has_agg == TRUE:
                # count/sum must produce a number
                if agg_col.agg in (COUNT, SUM) and tsq_type != 'number':
                    return Tribool(False)
                # min/max/avg can never produce a string
                if agg_col.agg in (MIN, MAX, AVG) and tsq_type == 'string':
                    return Tribool(False)
            elif agg_col.has_agg == UNKNOWN:
                # no agg func can convert num -> str
                if col_type == 'number' and tsq_type == 'string':
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
                    pass
                else:                               # exact constraint
                    if not db.has_exact(schema, agg_col.col_id, row[pos]):
                        return Tribool(False)

        return None

    def prune_by_row(self, query, tsq):
        pass

    def prune_by_num_cols(self, query, tsq):
        if tsq.num_cols > len(query.select):
            return Tribool(None)     # may not be finished generating SQL
        elif tsq.num_cols < len(query.select):
            return Tribool(False)    # exceeded max columns already
        else:
            return None              # nothing to prune

    def verify(self, db, schema, query, tsq):
        # check types
        if query.select:
            check_num_cols = self.check_num_cols(query, tsq)
            if check_num_cols is not None:
                return check_num_cols

            for i, aggcol in enumerate(query.select):
                check_col = self.prune_select_column(db, schema, aggcol, tsq, i)
                if check_col is not None:
                    return check_col

        return Tribool(None)        # return indeterminate

        # if not query.joinpath:
            # TODO: calculate join path
            # pass

        # stores tsq positions fulfilling each proj
        # proj_tsq_poses = []

        # TODO: check projs size and tsq cols size
        # TODO: check projs types and tsq cols types

        # for proj in query.projs():
            # TODO: returns Tribool result and tsq positions fulfilling it
            # result, tsq_poses = self.prune_by_column(proj, tsq)

            # if not result.value:
                # TODO: cache bad projection somehow
                # return Tribool(False)

        # TODO: check each permutation of proj ordering matching tsqs
        # for each valid permutation:
            # TODO: reorder query projs, then execute
            # self.prune_by_row(query, tsq)

        # TODO
        # if query is finished:
            # run query and check ordering, flip if necessary

        # TODO: T, F, or None for indeterminate goes in constructor
        # return Tribool()
