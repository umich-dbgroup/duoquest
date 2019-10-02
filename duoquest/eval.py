import math

from .proto.duoquest_pb2 import TRUE, FALSE, ProtoQuery, OR, IN, EQUALS

# does not consider subqueries or set ops
def matches_gold(gold, pq):
    pq.distinct = gold.distinct
    pq.limit = gold.limit

    pq.done_select = gold.done_select
    pq.done_where = gold.done_where
    pq.done_group_by = gold.done_group_by
    pq.done_having = gold.done_having
    pq.done_order_by = gold.done_order_by
    pq.done_limit = gold.done_limit
    pq.done_query = gold.done_query

    pq.min_select_cols = gold.min_select_cols
    pq.min_where_preds = gold.min_where_preds
    pq.min_group_by_cols = gold.min_group_by_cols
    pq.min_having_preds = gold.min_having_preds
    pq.min_order_by_cols = gold.min_order_by_cols

    # check alternate formulation of query for multiple equality predicates
    if gold.where.logical_op == OR:
        transformed = ProtoQuery()
        transformed.CopyFrom(gold)

        equal_preds = {}   # col_id -> [Predicates]

        for pred in transformed.where.predicates:
            if pred.op == EQUALS:
                if pred.col_id not in equal_preds:
                    equal_preds[pred.col_id] = []
                equal_preds[pred.col_id].append(pred)

        for col_id, preds in equal_preds.items():
            if len(preds) > 1:
                new_pred = transformed.where.predicates.add()
                new_pred.col_id = col_id
                new_pred.op = IN
                new_pred.has_subquery = FALSE
                new_pred.has_agg = FALSE

                for pred in preds:
                    new_pred.value.extend(pred.value)
                    transformed.where.predicates.remove(pred)

        return (str(gold) == str(pq)) or (str(transformed) == str(pq))
    else:
        return (str(gold) == str(pq))

def correct_rank(cqs, pq):
    for i, cq in enumerate(cqs):
        if matches_gold(pq, cq):
            return i + 1
    return None

def mrr(ranks):
    cum = 0
    for rank in ranks:
        if rank is None:
            continue
        cum += (1 / rank)
    return cum / len(ranks)

def print_ranks(ranks):
    n_vals_to_check = [1, 5, 10, 100, 1000]

    for n_val in n_vals_to_check:
        result = sum(1 for r in ranks if r is not None and r <= n_val)
        print(f'Top {n_val} Accuracy: {result}/{len(ranks)}' +
            f' ({(result/len(ranks)*100):.2f}%)')
    print(f'MRR: {mrr(ranks)}')

def print_ranks_by_level(ranks_by_level, n=10):
    for level, ranks in ranks_by_level.items():
        result = sum(1 for r in ranks if r is not None and r <= n)
        print(f'{level} Top-{n} Accuracy: {result}/{len(ranks)}' +
            f' ({(result/len(ranks)*100):.2f}%)')

def print_avg_time(times):
    avg_time = sum(t for t in times if t != math.inf) / len(times)
    print(f'Avg Time: {avg_time:.2f}s')

def print_cdf(ranks, times, n=None):
    length = len(times)

    if n is not None:
        times = map(lambda x: x[1],
            filter(lambda x: x[0] is not None and x[0] <= n \
                and x[1] != math.inf, zip(ranks, times)))
    else:
        times = map(lambda x: x[1],
            filter(lambda x: x[0] is not None and x[1] != math.inf,
                zip(ranks, times)))

    cdf = map(lambda t: f'({t[1]:.2f},{((t[0]+1) / length * 100):.2f})',
            enumerate(sorted(times)))
    print(f"CDF (n={n}):\n(0,0) {' '.join(cdf)}")

def detect_level(gold):
    if gold.has_group_by == TRUE:
        return 'hard'
    elif gold.has_where == TRUE:
        return 'medium'
    else:
        return 'easy'

def eval_duoquest(exp_set, n=None):
    ranks = []
    times = []

    ranks_by_level = {
        'easy': [],
        'medium': [],
        'hard': []
    }
    for exp in exp_set.exps:
        rank = correct_rank(exp.cqs, exp.gold)
        ranks.append(rank)
        times.append(exp.time)

        ranks_by_level[detect_level(exp.gold)].append(rank)

    print_ranks(ranks)
    print_ranks_by_level(ranks_by_level, n=10)
    print_avg_time(times)
    print_cdf(ranks, times)
