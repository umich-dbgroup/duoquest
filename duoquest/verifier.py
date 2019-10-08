import timeout_decorator

from numbers import Number
from tribool import Tribool

from .query import Query, verify_sql_str, generate_sql_str
from .proto.duoquest_pb2 import TRUE, UNKNOWN, FALSE, COUNT, SUM, MIN, MAX, \
    AVG, NO_SET_OP, INTERSECT, EXCEPT, UNION, EQUALS, NEQ, LIKE, IN, NOT_IN, \
    BETWEEN, OR, NO_AGG

def to_tribool_proto(proto_tribool):
    if proto_tribool == UNKNOWN:
        return Tribool(None)
    elif proto_tribool == TRUE:
        return Tribool(True)
    else:
        return Tribool(False)

class DuoquestVerifier:
    def __init__(self, use_cache=False, debug=False,
        # do not permit any foreign key usage in any of these clauses
        no_fk_select=False, no_fk_where=False, no_fk_having=False,
        no_fk_group_by=False,

        # do not permit primary key usage in this clause
        no_pk_where=False,

        # enforce that all used aggregates must be visible in the SELECT clause
        agg_projected=False,

        # enforce that any inequality predicates in WHERE are visible in SELECT
        inequality_projected=False,

        # the grouped-by column must be included in the SELECT clause
        group_by_in_select=False,

        # disallow queries with set operations and/or subqueries
        disable_set_ops=False,
        disable_subquery=False,

        # enforce minimal join paths necessary to link query fragments
        minimal_join_paths=False,

        # if literals will be given
        literals_given=False,

        # set an integer value
        max_group_by=None,

        disable_clauses=False,
        disable_semantics=False,
        disable_column=False,
        disable_literals=False
        ):
        if use_cache:
            # TODO: initialize cache
            pass

        self.no_fk_select = no_fk_select
        self.no_pk_where = no_pk_where
        self.no_fk_where = no_fk_where
        self.no_fk_having = no_fk_having
        self.group_by_in_select = group_by_in_select
        self.disable_set_ops = disable_set_ops
        self.no_fk_group_by = no_fk_group_by
        self.minimal_join_paths = minimal_join_paths
        self.max_group_by = max_group_by
        self.disable_subquery = disable_subquery
        self.agg_projected = agg_projected
        self.inequality_projected = inequality_projected
        self.literals_given = literals_given


        # disabling features in verifier
        self.disable_clauses = disable_clauses
        self.disable_semantics = disable_semantics
        self.disable_column = disable_column
        self.disable_literals = disable_literals

        self.debug = debug

    def init_stats(self):
        self.stats = {
            'clauses': 0,
            'num_cols': 0,
            'semantics': 0,
            'types': 0,
            'select_vals': 0,
            'row': 0,
            'order': 0
        }

    def prune_select_col_types(self, db, schema, agg_col, tsq, pos):
        if tsq.types:
            tsq_type = tsq.types[pos]
            col_type = schema.get_col(agg_col.col_id).type

            if self.no_fk_select and schema.get_col(agg_col.col_id).fk_ref:
                if self.debug:
                    print('Prune: foreign keys are not to be projected.')
                return Tribool(False)

            if agg_col.has_agg == TRUE:
                if tsq_type != 'number':
                    if self.debug:
                        print('Prune: all aggs must produce numeric output.')
                    return Tribool(False)
            elif agg_col.has_agg == UNKNOWN:
                if col_type == 'number' and tsq_type == 'text':
                    if self.debug:
                        print('Prune: cannot output text from numeric column.')
                    return Tribool(False)
            else:
                if col_type != tsq_type:
                    if self.debug:
                        print('Prune: column type does not match TSQ type.')
                    return Tribool(False)

    def prune_select_col_values(self, db, schema, agg_col, tsq, pos):
        if agg_col.has_agg == UNKNOWN:
            return None

        col_id = agg_col.col_id
        col_name = schema.get_col(col_id).sem_name

        for row in tsq.values:
            if row[pos] is None:                # empty cell
                continue
            elif isinstance(row[pos], list):    # range constraint
                if agg_col.has_agg == FALSE or \
                    (agg_col.has_agg == TRUE and \
                        agg_col.agg in (MIN, MAX, AVG)):
                    if not db.intersects_range(schema, col_id, row[pos]):
                        if self.debug:
                            print(f'Prune: <{row[pos]}> doesn\'t ' + \
                                f'intersect range of <{col_name}>.')
                        return Tribool(False)
            else:                               # exact constraint
                if (tsq.types and tsq.types[pos] == 'text') or \
                    agg_col.has_agg == FALSE or \
                    (agg_col.has_agg == TRUE and agg_col.agg in (MIN, MAX)):
                        if not db.has_exact(schema, col_id, row[pos]):
                            if self.debug:
                                print(f'Prune: <{row[pos]}> not ' +
                                    f'in <{col_name}>.')
                            return Tribool(False)
                elif agg_col.has_agg == TRUE and agg_col.agg == AVG:
                    if not db.intersects_range(schema, col_id,
                        [row[pos], row[pos]]):
                        if self.debug:
                            print(f'Prune: <{row[pos]}> doesn\'t ' + \
                                f'intersect range of <{col_name}>.')
                        return Tribool(False)

        return None

    def predicate_complete(self, pred):
        if pred.has_subquery == UNKNOWN:
            return False
        elif pred.has_subquery == TRUE:
            return pred.subquery.done_limit
        else:
            return len(pred.value) > 0

    def ready_for_row_check(self, query, tsq):
        if not query.done_select:
            return False

        # all WHERE/HAVING predicates must be complete if present
        if any(map(lambda x: not self.predicate_complete(x),
            query.where.predicates)):
            return False
        if any(map(lambda x: not self.predicate_complete(x),
            query.having.predicates)):
            return False

        # if logical op is an OR for WHERE/HAVING, the clause must be complete
        if query.where.logical_op == OR and not query.done_where:
            return False
        if query.having.logical_op == OR and not query.done_having:
            return False

        # if query contains any aggregate, then WHERE and GROUP BY must be done
        if any(map(lambda x: x.has_agg == TRUE, query.select)):
            if query.has_where == UNKNOWN or \
                (query.has_where == TRUE and not query.done_where):
                return False
            if query.has_group_by == TRUE and not query.done_group_by:
                return False
        # else:
            # when query has GROUP BY and no aggregate in select
            # make sure that HAVING and ORDER BY are both complete if present
            # if query.has_group_by == TRUE:
            #     if query.has_having == UNKNOWN or \
            #         query.has_order_by == UNKNOWN or \
            #         (query.has_having == TRUE and not query.done_having) or \
            #         (query.has_order_by == TRUE and not query.done_order_by):
            #         return False

        return True

    def ready_for_order_check(self, query, tsq):
        if not tsq.order or not tsq.values or len(tsq.values) <= 1:
            return False

        if not query.order_by:
            return False

        # if aggregate is not set for any order_by, not ready
        if any(map(lambda x: x.agg_col.has_agg == UNKNOWN, query.order_by)):
            return False

        return True

    @timeout_decorator.timeout(3, use_signals=False)
    def prune_by_row(self, db, schema, query, tsq):
        conn = db.get_conn(db_name=schema.db_id)

        for row in tsq.values:
            cur = conn.cursor()
            verify_q = verify_sql_str(query, schema, row)
            if self.debug:
                print(f'VERIFY: {verify_q}')
            cur.execute(verify_q)

            if not cur.fetchone():
                if self.debug:
                    print('Prune: Verify failed.')
                return Tribool(False)

            cur.close()
        conn.close()

        return None

    def first_matching_row(self, db_row, tsq_rows):
        for i, tsq_row in enumerate(tsq_rows):
            try:
                if self.row_result_matches(db_row, tsq_row):
                    return i
            except Exception as e:
                # exception for non-utf-8 strings breaking when typecasting
                continue
        return None

    def row_result_matches(self, db_row, tsq_row):
        for pos, val in enumerate(tsq_row):
            if val is None:
                continue

            if isinstance(val, list):     # range constraint
                if float(db_row[pos]) < val[0] or float(db_row[pos]) > val[1]:
                    return False
            else:                           # exact constraint
                if isinstance(db_row[pos], Number):
                    if db_row[pos] != val:
                        return False
                else:
                    if db_row[pos].decode('utf-8') != val:
                        return False
        return True

    @timeout_decorator.timeout(10, use_signals=False)
    def prune_by_order(self, db, schema, query, tsq):
        conn = db.get_conn(db_name=schema.db_id)
        conn.text_factory = bytes

        cur = conn.cursor()
        # TODO: to speed up instead of generate_sql_str, we could do a variation
        # of verify_sql_str where we put (col = val1 or col = val2) as part of
        # the sql_str for each value
        order_sql = generate_sql_str(query, schema)
        if self.debug:
            print(f'ORDER SQL: {order_sql}')
        cur.execute(order_sql)

        values_copy = list(tsq.values)

        prune = False
        while values_copy:
            db_row = cur.fetchone()
            if db_row is None:
                break

            index = self.first_matching_row(db_row, values_copy)
            if index is None:
                continue
            elif index == 0:
                values_copy = values_copy[1:]
            else:
                prune = True
                break

        if prune:
            if self.debug:
                print('Prune: ordering is incorrect.')
            return Tribool(False)
        elif values_copy:
            if self.debug:
                for val in values_copy:
                    print(f'Prune: could not find match for: {val}.')
            return Tribool(False)
        else:
            return None

    def prune_by_num_cols(self, query, tsq):
        if query.done_select and tsq.num_cols != len(query.select):
            if self.debug:
                print('Prune: number of columns does not match TSQ.')
            return Tribool(False)
        if tsq.num_cols < max(len(query.select), query.min_select_cols):
            if self.debug:
                print('Prune: number of columns exceeds TSQ.')
            return Tribool(False)
        else:
            return None

    def prune_by_subquery(self, schema, pred, literals):
        if pred.op == BETWEEN:
            if self.debug:
                print('Prune: cannot have BETWEEN with subquery.')
            return Tribool(False)
        if max(pred.subquery.min_select_cols, len(pred.subquery.select)) > 1:
            if self.debug:
                print('Prune: subquery cannot have more than 1 SELECT column.')
            return Tribool(False)
        if pred.subquery.select:
            subq_col_id = pred.subquery.select[0].col_id
            if subq_col_id != pred.col_id and \
                schema.get_col(subq_col_id).fk_ref != pred.col_id:
                if self.debug:
                    print('Prune: failed condition I8.')
                return Tribool(False)
            if pred.subquery.select[0].has_agg == TRUE and \
                pred.subquery.select[0].agg == COUNT:
                if self.debug:
                    print('Prune: Subquery cannot project COUNT().')
                return Tribool(False)
        if max(pred.subquery.min_where_preds,
            len(pred.subquery.where.predicates)) > 1:
            if self.debug:
                print('Prune: failed condition I9.')
            return Tribool(False)
        if max(pred.subquery.min_group_by_cols,
            len(pred.subquery.group_by)) > 1:
            if self.debug:
                print('Prune: subquery cannot have more than 1 GROUP BY column.')
            return Tribool(False)
        if max(pred.subquery.min_having_preds,
            len(pred.subquery.having.predicates)) > 1:
            if self.debug:
                print('Prune: subquery cannot have more than 1 HAVING predicate.')
            return Tribool(False)
        if max(pred.subquery.min_order_by_cols,
            len(pred.subquery.order_by)) > 1:
            if self.debug:
                print('Prune: subquery cannot have more than 1 ORDER BY column.')
            return Tribool(False)

        if pred.subquery.has_order_by == TRUE and \
            pred.subquery.has_limit == FALSE:
            if self.debug:
                print('Prune: subquery cannot have ORDER BY without LIMIT.')
            return Tribool(False)

        subq = self.prune_by_semantics(schema, pred.subquery, literals)
        if subq is not None:
            return subq

        return None

    def prune_by_semantics(self, schema, query, literals, set_op=None):
        for agg_col in query.select:
            col_type = schema.get_col(agg_col.col_id).type
            if agg_col.has_agg == TRUE:
                if agg_col.agg != COUNT and \
                    (agg_col.col_id == 0 or col_type == 'text'):
                    if self.debug:
                        print('Prune: only COUNT() permitted for * and text.')
                    return Tribool(False)
            elif agg_col.has_agg == FALSE:
                if agg_col.col_id == 0:
                    if self.debug:
                        print('Prune: cannot have * without COUNT().')
                    return Tribool(False)

        if self.literals_given and not self.disable_literals:
            lits_count = len(literals.text_lits) + len(literals.num_lits)
            if query.min_where_preds > lits_count:
                if self.debug:
                    print('Prune: number of where preds exceeds literal count.')
                return Tribool(False)

        subquery_count = 0

        for i, pred in enumerate(query.where.predicates):
            if pred.col_id == 0:
                if self.debug:
                    print('Prune: cannot have * in WHERE clause.')
                return Tribool(False)

            if self.no_fk_where and schema.get_col(pred.col_id).fk_ref:
                if self.debug:
                    print('Prune: cannot have foreign key in WHERE clause.')
                return Tribool(False)

            if self.no_pk_where and schema.get_col(pred.col_id).pk:
                if self.debug:
                    print('Prune: cannot have primary key in WHERE clause.')
                return Tribool(False)

            col_type = schema.get_col(pred.col_id).type
            if col_type == 'text':
                if pred.op not in (EQUALS, NEQ, LIKE, IN, NOT_IN):
                    if self.debug:
                        print('Prune: invalid op for text column.')
                    return Tribool(False)
                if not self.disable_literals and self.literals_given and \
                    (self.disable_subquery or pred.has_subquery == FALSE):
                    if pred.col_id not in \
                        [c for l in literals.text_lits for c in l.col_id]:
                        if self.debug:
                            print(f'Prune: no literals for col <{pred.col_id}>')
                        return Tribool(False)
            if col_type == 'number':
                if pred.op == LIKE:
                    if self.debug:
                        print('Prune: cannot have LIKE with numeric column.')
                    return Tribool(False)
                if not self.disable_literals and self.literals_given and \
                    (self.disable_subquery or pred.has_subquery == FALSE):
                    if len(literals.num_lits) == 0:
                        if self.debug:
                            print(f'Prune: no literals for col <{pred.col_id}>')
                        return Tribool(False)

            if pred.has_subquery == TRUE:
                if self.disable_subquery:
                    if self.debug:
                        print('Prune: subqueries disabled.')
                    return Tribool(False)
                subquery_count += 1
                subq = self.prune_by_subquery(schema, pred, literals)
                if subq is not None:
                    return subq

            if self.inequality_projected and pred.op not in (EQUALS, IN):
                if not any(pred.col_id == a.col_id for a in query.select):
                    if self.debug:
                        print('Prune: inequality predicates must be in SELECT.')
                    return Tribool(False)

            for j in range(i+1, len(query.where.predicates)):
                pred2 = query.where.predicates[j]
                if pred.col_id == pred2.col_id and pred.op == EQUALS \
                    and pred2.op == EQUALS:
                    if self.debug:
                        print('Prune: only one equality permitted per column.')
                    return Tribool(False)

        for pred in query.having.predicates:
            if pred.op == LIKE:
                if self.debug:
                    print('Prune: cannot have LIKE in HAVING clause.')
                return Tribool(False)

            if pred.has_subquery == TRUE:
                if self.disable_subquery:
                    if self.debug:
                        print('Prune: subqueries disabled.')
                    return Tribool(False)
                subquery_count += 1
                subq = self.prune_by_subquery(schema, pred, literals)
                if subq is not None:
                    return subq

            if self.no_fk_having and schema.get_col(pred.col_id).fk_ref:
                if self.debug:
                    print('Prune: cannot have foreign key in HAVING clause.')
                return Tribool(False)

            if self.agg_projected:
                if not any(pred.col_id == ac.col_id for ac in query.select):
                    if self.debug:
                        print('Prune: HAVING col must be in SELECT also.')
                    return Tribool(False)

                if pred.agg != NO_AGG:
                    if not any(pred.col_id == ac.col_id and pred.agg == ac.agg \
                        for ac in query.select):
                        if self.debug:
                            print('Prune: HAVING agg must be in SELECT also.')
                        return Tribool(False)


        if subquery_count > 1:
            if self.debug:
                print('Prune: failed condition I7.')
            return Tribool(False)

        if self.max_group_by is not None and \
            query.min_group_by_cols > self.max_group_by:
            if self.debug:
                print('Prune: max group by columns exceeded.')
            return Tribool(False)

        for col_id in query.group_by:
            if col_id == 0:
                if self.debug:
                    print('Prune: cannot have * in GROUP BY.')
                return Tribool(False)

            if self.no_fk_group_by and schema.get_col(col_id).fk_ref:
                if self.debug:
                    print('Prune: FK cannot be used in GROUP BY.')
                return Tribool('False')

            if self.group_by_in_select \
                and col_id not in list(map(lambda x: x.col_id,
                    filter(lambda x: x.has_agg == FALSE, query.select))):
                if self.debug:
                    print('Prune: GROUP BY col must be unaggregated in SELECT.')
                return Tribool(False)

        if any(map(lambda x: x.agg_col.has_agg != UNKNOWN and \
            x.agg_col.agg != COUNT and x.agg_col.col_id == 0, query.order_by)):
                if self.debug:
                    print('Prune: cannot have * without COUNT() in ORDER BY.')
                return Tribool(False)

        agg_present = False
        non_agg_present = False

        if query.done_select:
            for agg_col in query.select:
                agg_present = agg_present or agg_col.has_agg == TRUE
                non_agg_present = non_agg_present or agg_col.has_agg == FALSE

            if self.agg_projected and query.has_group_by == TRUE and \
                not agg_present:
                if self.debug:
                    print('Prune: aggregates must be visible in SELECT clause.')
                return Tribool(False)

        for oc in query.order_by:
            agg_present = agg_present or oc.agg_col.has_agg == TRUE

        if agg_present and non_agg_present and query.has_group_by == FALSE:
            if self.debug:
                print('Prune: failed condition I2.')
            return Tribool(False)

        if not (query.has_order_by == TRUE and not query.done_order_by):
            if not agg_present and non_agg_present \
                and query.has_group_by == TRUE and query.has_having == FALSE:
                if self.debug:
                    print('Prune: failed condition I4.')
                return Tribool(False)

        if agg_present and not non_agg_present \
            and query.has_group_by == TRUE:
            if self.debug:
                print('Prune: failed condition I5.')
            return Tribool(False)

        return None

    def prune_by_clauses(self, query, tsq, set_op, literals):
        if set_op != NO_SET_OP:
            if query.has_order_by == TRUE:
                if self.debug:
                    print('Prune: child of set operation cannot have ORDER BY.')
                return Tribool(False)
            if query.has_limit == TRUE:
                if self.debug:
                    print('Prune: child of set operation cannot have LIMIT.')
                return Tribool(False)
        else:
            if not self.disable_literals and query.has_where == FALSE \
                and literals.text_lits:
                if self.debug:
                    print('Prune: text literal requires WHERE clause.')
                return Tribool(False)
            if query.has_order_by == TRUE and not tsq.order:
                if self.debug:
                    print('Prune: query has ORDER BY when TSQ has none.')
                return Tribool(False)
            if query.has_order_by == FALSE and tsq.order:
                if self.debug:
                    print('Prune: query has no ORDER BY when TSQ does.')
                return Tribool(False)

            if query.has_limit == TRUE and not tsq.limit:
                if self.debug:
                    print('Prune: query has LIMIT when TSQ has none.')
                return Tribool(False)
            if query.has_limit == FALSE and tsq.limit:
                if self.debug:
                    print('Prune: query has no LIMIT when TSQ does.')
                return Tribool(False)

        return None

    def find_literal_usage(self, query, literal):
        if query.set_op != NO_SET_OP:
            if self.find_literal_usage(query.left) or \
                self.find_literal_usage(query.right):
                return True

        for pred in query.where.predicates:
            if pred.has_subquery == TRUE:
                if self.find_literal_usage(pred.subquery, literal):
                    return True
            else:
                if isinstance(literal, str):
                    if literal in pred.value:
                        return True
                else:
                    if pred.col_id in literal.col_id \
                        and literal.value in pred.value:
                        return True

        for pred in query.having.predicates:
            if pred.has_subquery == TRUE:
                if self.find_literal_usage(pred.subquery, literal):
                    return True
            else:
                if isinstance(literal, str):
                    if literal in pred.value:
                        return True
                else:
                    if pred.col_id in literal.col_id \
                        and literal.value in pred.value:
                        return True

        return False

    def prune_by_text_literals(self, query, literals):
        for literal in literals.text_lits:
            if not self.find_literal_usage(query, literal):
                if self.debug:
                    print(f'Prune: No literal {literal.col_id}:{literal.value}')
                return Tribool(False)
        return None

    def prune_by_num_literals(self, query, literals):
        for literal in literals.num_lits:
            if not self.find_literal_usage(query, literal):
                if self.debug:
                    print(f'Prune: No literal {literal}')
                return Tribool(False)
        return None

    def verify(self, db, schema, query, tsq, literals, set_op=NO_SET_OP,
        lr=None):
        if self.debug:
            print(query)

        if query.set_op != NO_SET_OP:
            if self.disable_set_ops:
                if self.debug:
                    print('Prune: set operations are disabled.')
                return Tribool(False)
            else:
                left = self.verify(db, schema, query.left, tsq, literals,
                    set_op=query.set_op, lr='left')
                right = self.verify(db, schema, query.right, tsq, literals,
                    set_op=query.set_op, lr='right')
                if left.value == False or right.value == False:
                    return Tribool(False)
                else:
                    return Tribool(None)

        if not self.disable_clauses:
            check_clauses = self.prune_by_clauses(query, tsq, set_op, literals)
            if check_clauses is not None:
                if hasattr(self, 'stats'):
                    self.stats['clauses'] += 1
                return check_clauses

        if not self.disable_semantics:
            check_semantics = self.prune_by_semantics(schema, query, literals)
            if check_semantics is not None:
                if hasattr(self, 'stats'):
                    self.stats['semantics'] += 1
                return check_semantics

        # if not child of UNION or right child of EXCEPT, can check values
        can_check_values = tsq.values and \
            set_op != UNION and \
            not (set_op == EXCEPT and lr == 'right')

        if not self.disable_column:
            check_num_cols = self.prune_by_num_cols(query, tsq)
            if check_num_cols is not None:
                if hasattr(self, 'stats'):
                    self.stats['num_cols'] += 1
                return check_num_cols

            for i, aggcol in enumerate(query.select):
                check_types = self.prune_select_col_types(db, schema, aggcol,
                    tsq, i)
                if check_types is not None:
                    if hasattr(self, 'stats'):
                        self.stats['types'] += 1
                    return check_types

                if can_check_values:
                    check_values = self.prune_select_col_values(db, schema,
                        aggcol, tsq, i)
                    if check_values is not None:
                        if hasattr(self, 'stats'):
                            self.stats['select_vals'] += 1
                        return check_values

        if query.done_where:
            # only perform on top-level query, checks recursively
            if not self.disable_literals and self.literals_given and lr is None:
                check_literals = self.prune_by_text_literals(query, literals)
                if check_literals is not None:
                    return check_literals

        if query.done_where and query.done_having:
            # only perform on top-level query, checks recursively
            if not self.disable_literals and self.literals_given and lr is None:
                check_literals = self.prune_by_num_literals(query, literals)
                if check_literals is not None:
                    return check_literals

        if can_check_values and self.ready_for_row_check(query, tsq):
            try:
                check_row = self.prune_by_row(db, schema, query, tsq)
                if check_row is not None:
                    if hasattr(self, 'stats'):
                        self.stats['row'] += 1
                    return check_row
            except Exception as e:
                if self.debug:
                    print('Prune: Verify query timed out.')
                return Tribool(False)

        if query.done_query:
            if self.ready_for_order_check(query, tsq):
                try:
                    check_order = self.prune_by_order(db, schema, query, tsq)
                    if check_order is not None:
                        if hasattr(self, 'stats'):
                            self.stats['order'] += 1
                        return check_order
                except Exception as e:
                    if self.debug:
                        print('Prune: Order query timed out.')
                    return Tribool(False)

            if self.debug:
                print('Success: Query verified.')
            return Tribool(True)

        return Tribool(None)        # return indeterminate
