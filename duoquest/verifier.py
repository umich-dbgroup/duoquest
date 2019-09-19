import timeout_decorator

from numbers import Number
from tribool import Tribool

from .query import Query, verify_sql_str, generate_sql_str
from .proto.duoquest_pb2 import TRUE, UNKNOWN, FALSE, COUNT, SUM, MIN, MAX, AVG, \
    NO_SET_OP, INTERSECT, EXCEPT, UNION, EQUALS, NEQ, LIKE, IN, NOT_IN, \
    BETWEEN, OR

def to_tribool_proto(proto_tribool):
    if proto_tribool == UNKNOWN:
        return Tribool(None)
    elif proto_tribool == TRUE:
        return Tribool(True)
    else:
        return Tribool(False)

class DuoquestVerifier:
    def __init__(self, use_cache=False, debug=False, no_fk_select=False,
        no_pk_where=False, no_fk_where=False, group_by_in_select=False):
        if use_cache:
            # TODO: initialize cache
            pass

        self.no_fk_select = no_fk_select
        self.no_pk_where = no_pk_where
        self.no_fk_where = no_fk_where
        self.group_by_in_select = group_by_in_select

        self.debug = debug

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

    @timeout_decorator.timeout(5, use_signals=False)
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

        lits_count = len(literals.text_lits) + len(literals.num_lits)
        if query.min_where_preds > lits_count:
            if self.debug:
                print('Prune: number of where preds exceeds literal count.')
            return Tribool(false)

        subquery_count = 0

        for pred in query.where.predicates:
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
                if pred.has_subquery == FALSE:
                    if pred.col_id not in \
                        [cid for lit in literals.text_lits for cid in lit.col_id]:
                        if self.debug:
                            print(f'Prune: no literals for col <{pred.col_id}>')
                        return Tribool(False)
            if col_type == 'number' and pred.op == LIKE:
                if self.debug:
                    print('Prune: cannot have LIKE with numeric column.')
                return Tribool(False)

            if pred.has_subquery == TRUE:
                subquery_count += 1
                subq = self.prune_by_subquery(schema, pred, literals)
                if subq is not None:
                    return subq

        for pred in query.having.predicates:
            if pred.op == LIKE:
                if self.debug:
                    print('Prune: cannot have LIKE in HAVING clause.')
                return Tribool(False)

            if pred.has_subquery == TRUE:
                subquery_count += 1
                subq = self.prune_by_subquery(schema, pred, literals)
                if subq is not None:
                    return subq

        if subquery_count > 1:
            if self.debug:
                print('Prune: failed condition I7.')
            return Tribool(False)

        for col_id in query.group_by:
            if col_id == 0:
                if self.debug:
                    print('Prune: cannot have * in GROUP BY.')
                return Tribool(False)

            if self.group_by_in_select \
                and col_id not in list(map(lambda x: x.col_id,
                    filter(lambda x: x.has_agg == FALSE, query.select))):
                if self.debug:
                    print('Prune: group by columns must be an unaggregated column in the SELECT clause.')
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
            if query.has_where == FALSE and literals.text_lits:
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

    def prune_by_literals(self, query, literals):
        for literal in literals.text_lits:
            if not self.find_literal_usage(query, literal):
                if self.debug:
                    print(f'Prune: No literal {literal.col_id}:{literal.value}')
                return Tribool(False)
        for literal in literals.num_lits:
            if not self.find_literal_usage(query, literal):
                if self.debug:
                    print(f'Prune: No literal {literal.col_id}:{literal.value}')
                return Tribool(False)
        return None

    def verify(self, db, schema, query, tsq, literals, set_op=NO_SET_OP,
        lr=None):
        if self.debug:
            print(query)

        if query.set_op != NO_SET_OP:
            left = self.verify(db, schema, query.left, tsq, literals,
                set_op=query.set_op, lr='left')
            right = self.verify(db, schema, query.right, tsq, literals,
                set_op=query.set_op, lr='right')
            if left.value == False or right.value == False:
                return Tribool(False)
            else:
                return Tribool(None)

        check_clauses = self.prune_by_clauses(query, tsq, set_op, literals)
        if check_clauses is not None:
            return check_clauses

        check_num_cols = self.prune_by_num_cols(query, tsq)
        if check_num_cols is not None:
            return check_num_cols

        check_semantics = self.prune_by_semantics(schema, query, literals)
        if check_semantics is not None:
            return check_semantics

        # if not child of UNION or right child of EXCEPT, can check values
        can_check_values = tsq.values and \
            set_op != UNION and \
            not (set_op == EXCEPT and lr == 'right')

        for i, aggcol in enumerate(query.select):
            check_types = self.prune_select_col_types(db, schema, aggcol, tsq,
                i)
            if check_types is not None:
                return check_types

            if can_check_values:
                check_values = self.prune_select_col_values(db, schema, aggcol,
                    tsq, i)
                if check_values is not None:
                    return check_values

        if can_check_values and self.ready_for_row_check(query, tsq):
            try:
                check_row = self.prune_by_row(db, schema, query, tsq)
                if check_row is not None:
                    return check_row
            except Exception as e:
                pass


        if query.done_query:
            # only perform on top-level query
            if lr is None:
                check_literals = self.prune_by_literals(query, literals)
                if check_literals is not None:
                    return check_literals

            if self.ready_for_order_check(query, tsq):
                check_order = self.prune_by_order(db, schema, query, tsq)
                if check_order is not None:
                    return check_order

            if self.debug:
                print('Success: Query verified.')
            return Tribool(True)

        return Tribool(None)        # return indeterminate
