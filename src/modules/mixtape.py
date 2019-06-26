import tribool

class Mixtape:
    def __init__(self, enabled=False, use_cache=False):
        self.enabled = enabled
        if use_cache:
            # TODO: initialize cache
            pass

    def prune_by_column(self, proj, tsq):
        pass

    def prune_by_row(self, query, tsq):
        pass

    def verify(self, query, tsq):
        return Tribool(None)

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
