from tribool import Tribool

from .query_pb2 import TRUE, UNKNOWN, FALSE, COUNT, SUM, MIN, MAX, AVG

class Mixtape:
    def __init__(self, use_cache=False):
        if use_cache:
            # TODO: initialize cache
            pass

    def prune_by_column(self, proj, tsq):
        pass

    def prune_by_row(self, query, tsq):
        pass

    def verify(self, schema, query, tsq):
        # check types
        if tsq.types and query.select:
            if len(tsq.types) != len(query.select):
                return Tribool(False)

            for i, agg_col in enumerate(query.select):
                tsq_type = tsq.types[i]
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
