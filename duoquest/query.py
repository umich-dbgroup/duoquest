from numbers import Number

from .proto.duoquest_pb2 import *
from .schema import JoinEdge

from .external.process_sql import AGG_OPS, WHERE_OPS

def to_str_tribool(proto_tribool):
    if proto_tribool == UNKNOWN:
        return None
    elif proto_tribool == TRUE:
        return True
    else:
        return False

def to_proto_tribool(boolval):
    if boolval is None:
        return UNKNOWN
    elif boolval:
        return TRUE
    else:
        return FALSE

def to_proto_set_op(set_op):
    if set_op == 'none':
        return NO_SET_OP
    elif set_op == 'intersect':
        return INTERSECT
    elif set_op == 'except':
        return EXCEPT
    elif set_op == 'union':
        return UNION
    else:
        raise Exception('Unknown set_op: {}'.format(set_op))

def to_proto_agg(agg):
    if agg == 'none':
        return NO_AGG
    elif agg == 'max':
        return MAX
    elif agg == 'min':
        return MIN
    elif agg == 'count':
        return COUNT
    elif agg == 'sum':
        return SUM
    elif agg == 'avg':
        return AVG
    else:
        raise Exception('Unrecognized agg: {}'.format(agg))

def to_str_agg(proto_agg):
    if proto_agg == MAX:
        return 'max'
    elif proto_agg == MIN:
        return 'min'
    elif proto_agg == COUNT:
        return 'count'
    elif proto_agg == SUM:
        return 'sum'
    elif proto_agg == AVG:
        return 'avg'
    else:
        raise Exception('Unrecognized agg: {}'.format(proto_agg))

def to_proto_logical_op(logical_op):
    if logical_op == 'and':
        return AND
    elif logical_op == 'or':
        return OR
    else:
        raise Exception('Unknown logical_op: {}'.format(logical_op))

def to_str_logical_op(proto_logical_op):
    if proto_logical_op == AND:
        return 'and'
    elif proto_logical_op == OR:
        return 'or'
    else:
        raise Exception('Unknown logical_op: {}'.format(proto_logical_op))

def to_proto_old_op(not_op, op):
    if op == 'between':
        return BETWEEN
    elif op == '=':
        return EQUALS
    elif op == '>':
        return GT
    elif op == '<':
        return LT
    elif op == '>=':
        return GEQ
    elif op == '<=':
        return LEQ
    elif op == '!=':
        return NEQ
    elif op == 'in' and not not_op:
        return IN
    elif op == 'in' and not_op:
        return NOT_IN
    elif op == 'like':
        return LIKE
    else:
        raise Exception('Unrecognized op: {}'.format(op))

def to_proto_op(op):
    if op == '=':
        return EQUALS
    elif op == '>':
        return GT
    elif op == '<':
        return LT
    elif op == '>=':
        return GEQ
    elif op == '<=':
        return LEQ
    elif op == '!=':
        return NEQ
    elif op == 'like':
        return LIKE
    elif op == 'in':
        return IN
    elif op == 'not in':
        return NOT_IN
    elif op == 'between':
        return BETWEEN
    else:
        raise Exception('Unrecognized op: {}'.format(op))

def to_str_op(proto_op):
    if proto_op == EQUALS:
        return '='
    elif proto_op == GT:
        return '>'
    elif proto_op == LT:
        return '<'
    elif proto_op == GEQ:
        return '>='
    elif proto_op == LEQ:
        return '<='
    elif proto_op == NEQ:
        return '!='
    elif proto_op == LIKE:
        return 'like'
    elif proto_op == IN:
        return 'in'
    elif proto_op == NOT_IN:
        return 'not in'
    elif proto_op == BETWEEN:
        return 'between'
    else:
        raise Exception('Unrecognized op: {}'.format(proto_op))

def to_proto_dir(dir):
    if dir == 'desc':
        return DESC
    elif dir == 'asc':
        return ASC
    else:
        raise Exception('Unrecognized dir: {}'.format(dir))

def to_str_dir(proto_dir):
    if proto_dir == DESC:
        return 'desc'
    elif proto_dir == ASC:
        return 'asc'
    else:
        raise Exception('Unrecognized dir: {}'.format(proto_dir))

def gen_alias(alias_idx, alias_prefix):
    if alias_prefix:
        return '{}t{}'.format(alias_prefix, alias_idx)
    else:
        return 't{}'.format(alias_idx)

def from_clause_str(pq, schema, alias_prefix):
    aliases = {}
    join_exprs = ['FROM']

    tables = list(map(lambda x: schema.get_table(x),
        pq.from_clause.edge_map.keys()))
    tbl = min(tables, key=lambda x: x.syn_name)

    # single table case, no aliases
    if len(tables) == 1:
        join_exprs.append(u'{}'.format(tbl.syn_name))
        return u' '.join(join_exprs), aliases

    alias = gen_alias(len(aliases) + 1, alias_prefix)
    aliases[tbl.syn_name] = alias
    join_exprs.append(u'{} AS {}'.format(tbl.syn_name, alias))

    stack = [tbl]

    while stack:
        tbl = stack.pop()
        for edge in pq.from_clause.edge_map[tbl.id].edges:
            edge = JoinEdge(
                schema.get_col(edge.fk_col_id),
                schema.get_col(edge.pk_col_id)
            )
            other_tbl = edge.other(tbl)
            if other_tbl.syn_name in aliases:
                continue

            alias = gen_alias(len(aliases) + 1, alias_prefix)
            aliases[other_tbl.syn_name] = alias
            join_exprs.append(
                u'JOIN {} AS {} ON {}.{} = {}.{}'.format(
                    other_tbl.syn_name, alias,
                    aliases[tbl.syn_name], edge.key(tbl).syn_name,
                    aliases[other_tbl.syn_name], edge.key(other_tbl).syn_name
                )
            )
            stack.append(other_tbl)

    return u' '.join(join_exprs), aliases

def select_clause_str(pq, schema, aliases, select_aliases=None):
    projs = []
    for i, agg_col in enumerate(pq.select):
        if agg_col.has_agg == TRUE:
            if agg_col.agg == COUNT and \
                schema.get_col(agg_col.col_id).syn_name != '*':
                proj_str = u'{}(DISTINCT {})'.format(
                    to_str_agg(agg_col.agg),
                    schema.get_aliased_col(aliases, agg_col.col_id)
                )
            else:
                proj_str = u'{}({})'.format(
                    to_str_agg(agg_col.agg),
                    schema.get_aliased_col(aliases, agg_col.col_id)
                )

            if select_aliases:
                proj_str = f'{proj_str} AS {select_aliases[i]}'

            projs.append(proj_str)
        else:
            projs.append(schema.get_aliased_col(aliases, agg_col.col_id))

    if pq.distinct:
        return u'SELECT DISTINCT ' + ', '.join(projs)
    else:
        return u'SELECT ' + ', '.join(projs)

def where_clause_str(pq, schema, aliases, verify=None):
    where_exprs = []

    predicates = []
    for i, pred in enumerate(pq.where.predicates):
        if i != 0:
            predicates.append(to_str_logical_op(pq.where.logical_op))

        col_type = schema.get_col(pred.col_id).type

        where_val = None
        if pred.has_subquery == TRUE:
            where_val = u'({})'.format(
                generate_sql_str(pred.subquery, schema,
                    alias_prefix='w{}'.format(i))
            )
        else:
            if not pred.value:
                raise Exception('Value is empty when generating where clause.')

            if pred.op in (IN, NOT_IN):
                where_val = u"({})".format(
                    u','.join(
                        map(lambda x: format_literal(col_type, x),
                            pred.value)
                    ))
            elif pred.op == BETWEEN:
                where_val = u"{} AND {}".format(
                    format_literal(col_type, pred.value[0]),
                    format_literal(col_type, pred.value[1])
                )
            else:
                where_val = format_literal(col_type, pred.value[0])

        pred_str = u' '.join([
            schema.get_aliased_col(aliases, pred.col_id),
            to_str_op(pred.op),
            where_val
        ])
        predicates.append(pred_str)

    verify_preds = []
    if verify:
        for i, item in enumerate(verify):
            agg_col, tsq_const = item

            assert(agg_col.has_agg == FALSE)
            assert(tsq_const is not None)

            col_type = schema.get_col(agg_col.col_id).type

            if col_type == 'number':
                where_col = 'CAST({} AS FLOAT)'.format(
                    schema.get_aliased_col(aliases, agg_col.col_id)
                )
            else:
                where_col = schema.get_aliased_col(aliases, agg_col.col_id)

            if isinstance(tsq_const, list):         # range constraint
                verify_preds.append(
                    u' '.join([where_col, '>=', str(tsq_const[0])])
                )
                verify_preds.append(
                    u' '.join([where_col, '<=', str(tsq_const[1])])
                )
            else:                                   # exact constraint
                verify_preds.append(u' '.join([
                    where_col,
                    '=',
                    format_literal(col_type, tsq_const)
                ]))

    if predicates and verify_preds:
        where_exprs.append(u'({})'.format(u' '.join(predicates)))
        where_exprs.append(u'({})'.format(u' AND '.join(verify_preds)))
    else:
        if predicates:
            where_exprs.append(u'{}'.format(u' '.join(predicates)))
        if verify_preds:
            where_exprs.append(u'{}'.format(u' AND '.join(verify_preds)))

    return u'WHERE {}'.format(u' AND '.join(where_exprs))

def group_by_clause_str(pq, schema, aliases):
    group_by_cols = []
    for col_id in pq.group_by:
        group_by_cols.append(schema.get_aliased_col(aliases, col_id))
    return u'GROUP BY {}'.format(u', '.join(group_by_cols))

def having_clause_str(pq, schema, aliases, verify=None):
    having_exprs = []

    predicates = []
    for i, pred in enumerate(pq.having.predicates):
        if i != 0:
            predicates.append(to_str_logical_op(pq.having.logical_op))

        assert(pred.has_agg == TRUE)

        if pred.agg == COUNT and \
            schema.get_col(pred.col_id).syn_name != '*':
            having_col = u'{}(DISTINCT {})'.format(
                to_str_agg(pred.agg),
                schema.get_aliased_col(aliases, pred.col_id)
            )
        else:
            having_col = u'{}({})'.format(
                to_str_agg(pred.agg),
                schema.get_aliased_col(aliases, pred.col_id)
            )

        col_type = schema.get_col(pred.col_id).type

        having_val = None
        if pred.has_subquery == TRUE:
            having_val = '({})'.format(
                generate_sql_str(pred.subquery, schema,
                    alias_prefix='h{}'.format(i))
            )
        elif pred.op in (IN, NOT_IN):
            having_val = u"({})".format(
                u','.join(
                    map(lambda x: format_literal('number', x),
                        pred.value)
                ))
        elif pred.op == BETWEEN:
            having_val = u"{} AND {}".format(
                format_literal('number', pred.value[0]),
                format_literal('number', pred.value[1])
            )
        else:
            having_val = format_literal('number', pred.value[0])

        pred_str = u' '.join([having_col, to_str_op(pred.op), having_val])
        predicates.append(pred_str)

    verify_preds = []
    if verify:
        for i, item in enumerate(verify):
            agg_col, tsq_const = item

            assert(agg_col.has_agg == TRUE)
            assert(tsq_const is not None)

            col_type = schema.get_col(agg_col.col_id).type

            if agg_col.col_id == 0:
                having_col = u'{}({})'.format(
                    to_str_agg(agg_col.agg),
                    schema.get_aliased_col(aliases, agg_col.col_id)
                )
            elif agg_col.agg == COUNT:
                having_col = u'{}(DISTINCT {})'.format(
                    to_str_agg(agg_col.agg),
                    schema.get_aliased_col(aliases, agg_col.col_id)
                )
            else:
                having_col = u'{}(DISTINCT CAST({} AS FLOAT))'.format(
                    to_str_agg(agg_col.agg),
                    schema.get_aliased_col(aliases, agg_col.col_id)
                )
            if isinstance(tsq_const, list):         # range constraint
                verify_preds.append(
                    u' '.join([having_col, '>=', str(tsq_const[0])])
                )
                verify_preds.append(
                    u' '.join([having_col, '<=', str(tsq_const[1])])
                )
            else:                                   # exact constraint
                verify_preds.append(u' '.join([
                    having_col,
                    '=',
                    format_literal('number', tsq_const)
                ]))

    if predicates and verify_preds:
        having_exprs.append(u'({})'.format(u' '.join(predicates)))
        having_exprs.append(u'({})'.format(u' AND '.join(verify_preds)))
    else:
        if predicates:
            having_exprs.append(u'{}'.format(u' '.join(predicates)))
        if verify_preds:
            having_exprs.append(u'{}'.format(u' AND '.join(verify_preds)))

    return u'HAVING {}'.format(u' AND '.join(having_exprs))

def order_by_clause_str(pq, schema, aliases):
    order_by_cols = []
    for ordered_col in pq.order_by:
        if ordered_col.agg_col.has_agg == TRUE:
            order_by_cols.append('{}({}) {}'.format(
                to_str_agg(ordered_col.agg_col.agg),
                schema.get_aliased_col(aliases, ordered_col.agg_col.col_id),
                to_str_dir(ordered_col.dir)
            ))
        else:
            order_by_cols.append('{} {}'.format(
                schema.get_aliased_col(aliases, ordered_col.agg_col.col_id),
                to_str_dir(ordered_col.dir)
            ))
    return u'ORDER BY {}'.format(u', '.join(order_by_cols))

def limit_clause_str(pq):
    if pq.limit == 0:       # if not set, default to 1
        pq.limit = 1
    return u'LIMIT {}'.format(pq.limit)

def format_literal(type, literal):
    if isinstance(literal, Number):
        return str(literal)

    # escape apostrophes
    literal = literal.replace("'", "''")

    if type == 'number':
        try:
            float(literal)
            return literal
        except Exception as e:
            raise InvalidValueException()
    else:
        return f"'{literal}'"

def verify_sql_str(pq, schema, tsq_row, strict=False):
    verify_agg = []             # tuples: (agg_col, tsq constraint)
    verify_non_agg = []         # tuples: (agg_col, tsq constraint)

    for i, agg_col in enumerate(pq.select):
        if tsq_row[i] is None:
            continue

        if agg_col.has_agg == TRUE:
            verify_agg.append((agg_col, tsq_row[i]))
        elif agg_col.has_agg == FALSE:
            verify_non_agg.append((agg_col, tsq_row[i]))
        else:
            raise Exception('Cannot verify AggCol with has_agg UNKNOWN.')

    if not verify_agg and not verify_non_agg:
        return None         # nothing to verify!

    from_clause, aliases = from_clause_str(pq, schema, None)
    if from_clause is None:
        raise Exception('FROM clause not generated.')

    # Special Case: all aggregates and no group by, because SQLite does not
    # permit HAVING clause without a GROUP BY
    if verify_agg and not verify_non_agg and pq.has_group_by == FALSE:
        select_aliases = []
        where_preds = []
        for i, agg_col in enumerate(pq.select):
            tsq_const = tsq_row[i]

            select_alias = f's{i}'
            select_aliases.append(select_alias)

            if tsq_const is None:
                continue

            col_type = schema.get_col(agg_col.col_id).type

            if isinstance(tsq_const, list):         # range constraint
                where_preds.append(
                    u' '.join([select_alias, '>=', str(tsq_const[0])])
                )
                where_preds.append(
                    u' '.join([select_alias, '<=', str(tsq_const[1])])
                )
            else:                                   # exact constraint
                where_preds.append(u' '.join([
                    select_alias,
                    '=',
                    format_literal(col_type, tsq_const)
                ]))

        return 'SELECT 1 FROM ({}) WHERE {}'.format(
            generate_sql_str(pq, schema, select_aliases=select_aliases,
                no_order_by=True),
            u' AND '.join(where_preds)
        )


    else:
        clauses = []
        clauses.append('SELECT 1')
        clauses.append(from_clause)
        if (pq.has_where == TRUE and pq.where.predicates) or verify_non_agg:
            clauses.append(where_clause_str(pq, schema, aliases,
                verify=verify_non_agg))
        if pq.has_group_by == TRUE and pq.done_group_by:
            clauses.append(group_by_clause_str(pq, schema, aliases))
        if (pq.has_having == TRUE and pq.having.predicates) or verify_agg:
            clauses.append(having_clause_str(pq, schema, aliases,
                verify=verify_agg))
        clauses.append('LIMIT 1')

        return u' '.join(clauses)

def generate_sql_str(pq, schema, alias_prefix=None, select_aliases=None,
    no_order_by=False):
    if pq.set_op != NO_SET_OP:
        set_op_str = None
        if pq.set_op == INTERSECT:
            set_op_str = 'INTERSECT'
        elif pq.set_op == UNION:
            set_op_str = 'UNION'
        elif pq.set_op == EXCEPT:
            set_op_str = 'EXCEPT'

        return u'{} {} {}'.format(
            generate_sql_str(pq.left, schema),
            set_op_str,
            generate_sql_str(pq.right, schema, alias_prefix=set_op_str[0])
        )

    from_clause, aliases = from_clause_str(pq, schema, alias_prefix)
    if from_clause is None:
        raise Exception('FROM clause not generated.')

    clauses = []
    clauses.append(select_clause_str(pq, schema, aliases,
        select_aliases=select_aliases))
    clauses.append(from_clause)
    if pq.has_where == TRUE and pq.where.predicates:
        clauses.append(where_clause_str(pq, schema, aliases))
    if pq.has_group_by == TRUE:
        clauses.append(group_by_clause_str(pq, schema, aliases))
    if pq.has_having == TRUE and pq.having.predicates:
        clauses.append(having_clause_str(pq, schema, aliases))
    if pq.has_order_by == TRUE and not no_order_by:
        clauses.append(order_by_clause_str(pq, schema, aliases))
    if pq.has_limit == TRUE and not no_order_by:
        clauses.append(limit_clause_str(pq))

    return u' '.join(clauses)

# Get all tables used in PQ. Does not consider subqueries.
def get_tables(schema, pq):
    # assuming no duplicate tables, change to list() if allowing self-join
    tables = set()
    for agg_col in pq.select:
        tbl = schema.get_col(agg_col.col_id).table
        if tbl:         # check in case tbl is None for '*' column case
            tables.add(tbl)
    if pq.has_where == TRUE:
        for pred in pq.where.predicates:
            tbl = schema.get_col(pred.col_id).table
            if tbl:
                tables.add(tbl)
    if pq.has_group_by == TRUE:
        for col_id in pq.group_by:
            tbl = schema.get_col(col_id).table
            if tbl:
                tables.add(tbl)
    if pq.has_having == TRUE:
        for pred in pq.having.predicates:
            tbl = schema.get_col(pred.col_id).table
            if tbl:
                tables.add(tbl)
    if pq.has_order_by == TRUE:
        for ordered_col in pq.order_by:
            tbl = schema.get_col(ordered_col.agg_col.col_id).table
            if tbl:
                tables.add(tbl)
    return tables

# Only considers whether join path for current localized pq needs updating.
# Does not consider for subqueries or set op children
# Returns:
# - True: if join path needs to be and can be updated
# - False: if join path needs no updating
def join_path_needs_update(schema, pq):
    tables_in_cur_jp = set(map(lambda x: schema.get_table(x),
        pq.from_clause.edge_map.keys()))

    # if SELECT has a column (i.e. inference started) and there are no tables
    if pq.select and len(tables_in_cur_jp) == 0:
        return True

    # if the current join path doesn't account for all tables in protoquery
    tables = get_tables(schema, pq)
    if tables_in_cur_jp >= tables:
        return False
    else:
        return True

def with_updated_join_paths(schema, pq, minimal_join_paths=False):
    for agg_col in pq.select:
        if agg_col.agg == COUNT and agg_col.col_id == 0:
            minimal_join_paths = False
    jps = schema.get_join_paths(get_tables(schema, pq),
        minimal_join_paths=minimal_join_paths)

    new_pqs = []
    for jp in jps:
        new_pq = ProtoQuery()
        new_pq.CopyFrom(pq)
        set_proto_from(new_pq, jp)
        new_pqs.append(new_pq)
    return new_pqs

def set_proto_from(pq, jp):
    # reset from clause
    del pq.from_clause.edge_list.edges[:]
    for key in pq.from_clause.edge_map.keys():
        del pq.from_clause.edge_map[key]

    if jp.distinct:
        pq.distinct = True

    for edge in jp.edges:
        proto_edge = ProtoJoinEdge()
        proto_edge.fk_col_id = edge.fk_col.id
        proto_edge.pk_col_id = edge.pk_col.id
        pq.from_clause.edge_list.edges.append(proto_edge)

    for tbl, edges in jp.edge_map.items():
        # initialize table in protobuf even if edges don't exist
        pq.from_clause.edge_map.get_or_create(tbl.id)
        for edge in edges:
            proto_edge = ProtoJoinEdge()
            proto_edge.fk_col_id = edge.fk_col.id
            proto_edge.pk_col_id = edge.pk_col.id
            pq.from_clause.edge_map[tbl.id].edges.append(proto_edge)

class ColumnBinaryOpException(Exception):
    pass

class FromSubqueryException(Exception):
    pass

class MultipleLogicalOpException(Exception):
    pass

class MultipleOrderByException(Exception):
    pass

class SetOpException(Exception):
    pass

class InvalidValueException(Exception):
    pass

class InvalidGroupByException(Exception):
    pass

class AggTypeMismatchException(Exception):
    pass

class OpTypeMismatchException(Exception):
    pass

class SubqueryException(Exception):
    pass

class EmptyResultException(Exception):
    pass

class WildcardColumnException(Exception):
    pass

class UnsupportedColumnTypeException(Exception):
    pass

class ForeignKeyException(Exception):
    pass

class InconsistentPredicateException(Exception):
    pass

def load_pq_from_spider(schema, spider_sql, set_op=None):
    pq = ProtoQuery()

    if set_op is None:
        if 'intersect' in spider_sql and spider_sql['intersect']:
            raise SetOpException()
            # pq.set_op = INTERSECT
            # pq.left = load_pq_from_spider(schema, spider_sql,
            #     set_op='intersect')
            # pq.right = load_pq_from_spider(schema, spider_sql['intersect'],
            #     set_op='intersect')
            return pq
        elif 'except' in spider_sql and spider_sql['except']:
            raise SetOpException()
            # pq.set_op = EXCEPT
            # pq.left = load_pq_from_spider(schema, spider_sql, set_op='except')
            # pq.right = load_pq_from_spider(schema, spider_sql['except'],
            #     set_op='except')
            return pq
        elif 'union' in spider_sql and spider_sql['union']:
            raise SetOpException()
            # pq.set_op = UNION
            # pq.left = load_pq_from_spider(schema, spider_sql, set_op='union')
            # pq.right = load_pq_from_spider(schema, spider_sql['union'],
            #     set_op='union')
            return pq

    tables = set()

    # SELECT
    pq.distinct = spider_sql['select'][0]

    agg_projs = []
    non_agg_projs = []

    for agg, val_unit in spider_sql['select'][1]:
        if val_unit[0] != 0:
            raise ColumnBinaryOpException()
        proj = pq.select.add()

        col = schema.get_col(val_unit[1][1])
        if col.fk_ref:
            proj.col_id = col.fk_ref
            tables.add(schema.get_col(col.fk_ref).table)
        else:
            proj.col_id = col.id
            if col.id != 0:
                tables.add(col.table)
        proj.agg = to_proto_agg(AGG_OPS[agg])
        if proj.agg != NO_AGG:
            proj.has_agg = TRUE
            agg_projs.append(proj)
        else:
            proj.has_agg = FALSE
            non_agg_projs.append(proj)

    pq.min_select_cols = len(pq.select)

    # WHERE
    equality_cols = set()

    if 'where' in spider_sql and spider_sql['where']:
        pq.has_where = TRUE

        logical_op_set = False
        for cond in spider_sql['where']:
            if cond in ('and', 'or'):
                if logical_op_set and \
                    to_proto_logical_op(cond) != pq.where.logical_op:
                    raise MultipleLogicalOpException()
                else:
                    pq.where.logical_op = to_proto_logical_op(cond)
                    logical_op_set = True
            else:
                if cond[2][0] != 0:
                    raise ColumnBinaryOpException()
                pred = pq.where.predicates.add()
                pred.has_agg = FALSE

                col = schema.get_col(cond[2][1][1])
                if col.fk_ref:
                    pred.col_id = col.fk_ref
                    tables.add(schema.get_col(col.fk_ref).table)
                else:
                    pred.col_id = col.id
                    tables.add(col.table)

                pred.op = to_proto_old_op(cond[0], WHERE_OPS[cond[1]])

                if pred.op == EQUALS:
                    if pred.col_id in equality_cols:
                        raise InconsistentPredicateException()
                    equality_cols.add(pred.col_id)

                if isinstance(cond[3], dict):
                    pred.has_subquery = TRUE
                    pred.subquery.CopyFrom(load_pq_from_spider(schema, cond[3]))
                elif isinstance(cond[3], Number) or isinstance(cond[3], str):
                    pred.has_subquery = FALSE
                    val_str = str(cond[3]).replace('"', '')
                    pred.value.append(val_str)
                else:
                    raise InvalidValueException()

                if cond[4] is not None:
                    pred.value.append(str(cond[4]))
        pq.min_where_preds = len(pq.where.predicates)
    else:
        pq.has_where = FALSE

    # GROUP BY
    if 'groupBy' in spider_sql and spider_sql['groupBy']:
        pq.has_group_by = TRUE
        for col_unit in spider_sql['groupBy']:
            col = schema.get_col(col_unit[1])
            if col.fk_ref:
                pq.group_by.append(col.fk_ref)
                tables.add(schema.get_col(col.fk_ref).table)
            else:
                pq.group_by.append(col.id)
                tables.add(col.table)
        pq.min_group_by_cols = len(pq.group_by)
    else:
        pq.has_group_by = FALSE

    # HAVING
    if pq.has_group_by == TRUE:
        if 'having' in spider_sql and spider_sql['having']:
            pq.has_having = TRUE

            logical_op_set = False
            for cond in spider_sql['having']:
                if cond in ('and', 'or'):
                    if logical_op_set and \
                        to_proto_logical_op(cond) != pq.having.logical_op:
                        raise MultipleLogicalOpException()
                    else:
                        pq.having.logical_op = to_proto_logical_op(cond)
                        logical_op_set = True
                else:
                    if cond[2][0] != 0:
                        raise ColumnBinaryOpException()

                    pred = pq.having.predicates.add()
                    pred.has_agg = TRUE
                    pred.agg = to_proto_agg(AGG_OPS[cond[2][1][0]])

                    if pred.agg == NO_AGG:
                        raise AggTypeMismatchException()

                    col = schema.get_col(cond[2][1][1])
                    if col.fk_ref:
                        pred.col_id = col.fk_ref
                        tables.add(schema.get_col(col.fk_ref).table)
                    else:
                        pred.col_id = col.id
                        tables.add(col.table)

                    pred.op = to_proto_old_op(cond[0], WHERE_OPS[cond[1]])
                    if isinstance(cond[3], dict):
                        pred.has_subquery = TRUE
                        pred.subquery.CopyFrom(load_pq_from_spider(schema,
                            cond[3]))
                    elif isinstance(cond[3], Number) or isinstance(cond[3],
                        str):
                        pred.has_subquery = FALSE
                        val_str = str(cond[3]).replace('"', '')
                        pred.value.append(val_str)
                    else:
                        raise InvalidValueException()

                    if cond[4] is not None:
                        pred.value.append(str(cond[4]))
            pq.min_having_preds = len(pq.having.predicates)
        else:
            pq.has_having = FALSE

    # ORDER BY
    if 'orderBy' in spider_sql and spider_sql['orderBy']:
        pq.has_order_by = TRUE

        if len(spider_sql['orderBy'][1]) != 1:
            raise MultipleOrderByException()
        if spider_sql['orderBy'][1][0][0] != 0:
            raise ColumnBinaryOpException()

        order_col = pq.order_by.add()
        order_col.dir = to_proto_dir(spider_sql['orderBy'][0])
        order_col.agg_col.agg = to_proto_agg(
            AGG_OPS[spider_sql['orderBy'][1][0][1][0]])
        if order_col.agg_col.agg != NO_AGG:
            order_col.agg_col.has_agg = TRUE
        else:
            order_col.agg_col.has_agg = FALSE

        col = schema.get_col(spider_sql['orderBy'][1][0][1][1])
        if col.fk_ref:
            order_col.agg_col.col_id = col.fk_ref
            tables.add(schema.get_col(col.fk_ref).table)
        else:
            order_col.agg_col.col_id = col.id
            tables.add(col.table)

        pq.min_order_by_cols = len(pq.order_by)
    else:
        pq.has_order_by = FALSE

    # LIMIT
    if pq.has_order_by == TRUE:
        if 'limit' in spider_sql and spider_sql['limit']:
            pq.has_limit = TRUE
            pq.limit = spider_sql['limit']
        else:
            pq.has_limit = FALSE

    if len(agg_projs) > 0 and len(non_agg_projs) > 0:
        # GROUP BY must exist if both agg and non_agg exist
        if pq.has_group_by == FALSE:
            raise InvalidGroupByException()
    elif len(agg_projs) > 0:
        # if only agg exists and there is GROUP BY,
        # add GROUP BY columns to projection
        if pq.has_group_by == TRUE:
            for col_id in pq.group_by:
                proj = pq.select.add()
                proj.has_agg = FALSE
                proj.col_id = col_id
    else:
        # if only non-agg exists and there is GROUP BY,
        # add aggregated columns from elsewhere to projection
        if pq.has_group_by == TRUE:
            added = False
            for pred in pq.having.predicates:
                proj = pq.select.add()
                proj.has_agg = TRUE
                proj.col_id = pred.col_id
                proj.agg = pred.agg
                added = True
            for oc in pq.order_by:
                if oc.agg_col.has_agg == TRUE:
                    proj = pq.select.add()
                    proj.CopyFrom(oc.agg_col)
                    added = True
            if not added:
                raise InvalidGroupByException()

    # FROM
    self_join_check = set()
    for tbl_unit in spider_sql['from']['table_units']:
        if tbl_unit[0] != 'table_unit':
            raise FromSubqueryException()

        tables.add(schema.get_table(tbl_unit[1]))

    jp = schema.steiner(tables)
    set_proto_from(pq, jp)

    pq.done_select = True
    pq.done_where = True
    pq.done_group_by = True
    pq.done_having = True
    pq.done_order_by = True
    pq.done_limit = True
    pq.done_query = True
    return pq

class Query():
    def __init__(self, schema, protoquery=None):
        self.schema = schema

        if protoquery is None:
            protoquery = ProtoQuery()
        self.pq = protoquery

    def copy(self):
        new_query = Query(self.schema)
        new_query.pq.CopyFrom(self.pq)
        return new_query

    @staticmethod
    def from_spider(schema, spider_sql):
        new_query = Query(schema)
        new_query.pq = load_pq_from_spider(schema, spider_sql)
        return new_query
