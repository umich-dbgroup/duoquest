import math

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

    return (gold.SerializeToString() == pq.SerializeToString())

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
    n_vals_to_check = [1, 10, 100, 1000]

    for n_val in n_vals_to_check:
        result = sum(1 for r in ranks if r is not None and r <= n_val)
        print(f'Top {n_val} Accuracy: {result}/{len(ranks)}' +
            f' ({(result/len(ranks)*100):.2f}%)')
    print(f'MRR: {mrr(ranks)}')

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

def eval_duoquest(exp_set, n=None):
    ranks = []
    times = []
    for exp in exp_set.exps:
        rank = correct_rank(exp.cqs, exp.gold)
        ranks.append(rank)
        times.append(exp.time)

    print_ranks(ranks)
    print_avg_time(times)
    print_cdf(ranks, times)
