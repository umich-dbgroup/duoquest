import tribool

class Mixtape:
    def __init__(self, use_cache=False):
        if use_cache:
            # TODO: initialize cache
            pass

    def prune_by_column(self, proj, spec):
        pass

    def prune_by_row(self, query, spec):
        pass

    def verify(self, query, spec):
        if not query.joinpath:
            # TODO: calculate join path
            pass

        # stores spec positions fulfilling each proj
        proj_spec_poses = []

        # TODO: check projs size and spec cols size
        # TODO: check projs types and spec cols types

        for proj in query.projs():
            # TODO: returns Tribool result and spec positions fulfilling it
            result, spec_poses = self.prune_by_column(proj, spec)

            if not result.value:
                # TODO: cache bad projection somehow
                return Tribool(False)

        # TODO: check each permutation of proj ordering matching specs
        # for each valid permutation:
            # TODO: reorder query projs, then execute
            # self.prune_by_row(query, spec)

        # TODO
        # if query is finished:
            # run query and check ordering, flip if necessary

        # TODO: T, F, or None for indeterminate goes in constructor
        return Tribool()
