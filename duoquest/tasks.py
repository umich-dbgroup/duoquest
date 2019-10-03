from .proto.duoquest_pb2 import *
from .query import *

def is_number(val):
    try:
        float(val)
        return True
    except Exception as e:
        return False

def is_valid_task(schema, db, spider_sql):
    pq = load_pq_from_spider(schema, spider_sql)

    agg_projs = []
    non_agg_projs = []
    for ac in pq.select:
        if ac.col_id == 0:
            if ac.has_agg == FALSE:
                raise WildcardColumnException()
            elif ac.agg != COUNT:
                raise AggTypeMismatchException()

        col_type = schema.get_col(ac.col_id).type
        if col_type not in ('text', 'number'):
            raise UnsupportedColumnTypeException()

        if schema.get_col(ac.col_id).fk_ref:
            raise ForeignKeyException()

        if ac.agg in (MIN, MAX, AVG, SUM) and col_type != 'number':
            raise AggTypeMismatchException()

        if ac.has_agg == TRUE:
            agg_projs.append(ac)
        if ac.has_agg == FALSE:
            non_agg_projs.append(ac)

    for pred in pq.where.predicates:
        col_type = schema.get_col(pred.col_id).type
        if col_type not in ('text', 'number'):
            raise UnsupportedColumnTypeException()

        if schema.get_col(pred.col_id).fk_ref:
            raise ForeignKeyException()

        if pred.has_subquery == TRUE:
            raise SubqueryException()

        if col_type == 'text' and pred.op in (GT, LT, GEQ, LEQ, BETWEEN):
            raise OpTypeMismatchException()
        if col_type == 'number' and pred.op == LIKE:
            raise OpTypeMismatchException()

    for col_id in pq.group_by:
        col_type = schema.get_col(col_id).type
        if col_type not in ('text', 'number'):
            raise UnsupportedColumnTypeException()

        if schema.get_col(col_id).fk_ref:
            raise ForeignKeyException()

    for pred in pq.having.predicates:
        col_type = schema.get_col(pred.col_id).type
        if col_type not in ('text', 'number'):
            raise UnsupportedColumnTypeException()

        if schema.get_col(pred.col_id).fk_ref:
            raise ForeignKeyException()

        if pred.has_subquery == TRUE:
            raise SubqueryException()

        if ac.agg in (MIN, MAX, AVG, SUM) and col_type != 'number':
            raise AggTypeMismatchException()

        if pred.op == LIKE:
            raise OpTypeMismatchException()

    for oc in pq.order_by:
        col_type = schema.get_col(oc.agg_col.col_id).type
        if col_type not in ('text', 'number'):
            raise UnsupportedColumnTypeException()

        if schema.get_col(oc.agg_col.col_id).fk_ref:
            raise ForeignKeyException()

        if oc.agg_col.has_agg and oc.agg_col.agg in (MIN, MAX, AVG, SUM) \
            and col_type != 'number':
            raise AggTypeMismatchException()

        if oc.agg_col.col_id == 0 and oc.agg_col.has_agg == FALSE:
            raise WildcardColumnException()

    conn = db.get_conn(db_name=schema.db_id)
    cur = conn.cursor()
    query_str = generate_sql_str(pq, schema)
    cur.execute(query_str)

    row = cur.fetchone()
    if row is None or all(val is None for val in row):
        raise EmptyResultException()

    return query_str, pq
