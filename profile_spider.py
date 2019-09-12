import configparser
import json

from operator import add

from experiments import load_schemas

WHERE_OPS = ('not', 'between', '=', '>', '<', '>=', '<=', '!=', 'in',
    'like', 'is', 'exists')

def contains_subquery(sql):
    for a, b in sql['from']['table_units']:
        if a == 'sql':
            return True, True
    for cond_unit in sql['from']['conds'][::2]:
        if isinstance(cond_unit[3], dict) or isinstance(cond_unit[4], dict):
            return True, True
    for cond_unit in sql['where'][::2] + sql['having'][::2]:
        if isinstance(cond_unit[3], dict) or isinstance(cond_unit[4], dict):
            return True, False

    return False, False

def get_subq_preds(sql):
    preds = []      # (col_id, op, subquery)
    for cond_unit in sql['where'][::2] + sql['having'][::2]:
        if isinstance(cond_unit[3], dict):
            preds.append(
                (cond_unit[2][1][1], WHERE_OPS[cond_unit[1]], cond_unit[3])
            )
        if isinstance(cond_unit[4], dict):
            preds.append(
                (cond_unit[2][1][1], WHERE_OPS[cond_unit[1]], cond_unit[3])
            )
    return preds

def subq_info(sql, schema):
    # Info:
    #  0. SQL has exactly one subquery per set operation child query.
    #  1. Each subquery has exactly one projection.
    #  2. Subquery projection matches predicate column or is FK of it.
    #  3. Subquery has WHERE.
    #  4. Subquery has 1 WHERE predicate at most.
    #  5. Subquery has GROUP BY.
    #  6. Subquery has exactly 1 GROUP BY column.
    #  7. Subquery has HAVING.
    #  8. Subquery has exactly 1 HAVING predicate.
    #  9. Subquery has ORDER BY.
    # 10. Subquery has exactly 1 ORDER BY column.
    # 11. Subquery projection has COUNT.

    info = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

    preds = get_subq_preds(sql)

    info[0] = int(len(preds) == 1)

    pred_col, op, subq = preds[0]

    info[1] = int(len(subq['select'][1]) == 1)

    subq_col = subq['select'][1][0][1][1][1]

    info[2] = (pred_col == subq_col or \
        pred_col == schema.get_col(subq_col).fk_ref)

    info[3] = int('where' in subq and bool(subq['where']))
    info[4] = int('where' in subq and bool(subq['where']) \
        and len(subq['where']) == 1)
    info[5] = int('groupBy' in subq and bool(subq['groupBy']))
    info[6] = int('groupBy' in subq and bool(subq['groupBy']) \
        and len(subq['groupBy']) == 1)
    info[7] = int('having' in subq and bool(subq['having']))
    info[8] = int('having' in subq and bool(subq['having']) \
        and len(subq['having']) == 1)
    info[9] = int('orderBy' in subq and bool(subq['orderBy']))
    info[10] = int('orderBy' in subq and bool(subq['orderBy']) \
        and len(subq['orderBy'][1]) == 1)
    info[11] = (subq['select'][1][0][0] == 3)

    return info

def main():
    config = configparser.ConfigParser()
    config.read('config.ini')

    subq_count = 0
    cum_subq_infos = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    from_subq_count = 0
    order_by_2 = 0
    order_by_3 = 0

    fk_in_select = 0
    pk_in_where = 0
    fk_in_where = 0

    for mode in ('dev', 'test'):
        data = json.load(open(config['spider'][f'{mode}_path']))
        db_path = config['spider'][f'{mode}_db_path']
        schemas_path = config['spider'][f'{mode}_tables_path']

        schemas, _ = load_schemas(schemas_path)

        for i, task in enumerate(data):
            schema = schemas[task['db_id']]

            subq, in_from = contains_subquery(task['sql'])

            found_fk_in_select = False
            for agg, val_unit in task['sql']['select'][1]:
                if agg == 0 and schema.get_col(val_unit[1][1]).fk_ref:
                    found_fk_in_select = True
            if found_fk_in_select:
                fk_in_select += 1

            # contains more than 1 ORDER BY column
            if 'orderBy' in task['sql'] and task['sql']['orderBy'] \
                and len(task['sql']['orderBy'][1]) > 1:
                if len(task['sql']['orderBy'][1]) == 2:
                    order_by_2 += 1
                elif len(task['sql']['orderBy'][1]) == 3:
                    order_by_3 += 1

            found_fk_in_where = False
            found_pk_in_where = False
            for item in task['sql']['where']:
                if not isinstance(item, str):
                    col = schema.get_col(item[2][1][1])
                    if col.fk_ref:
                        found_fk_in_where = True
                    elif col.pk:
                        found_pk_in_where = True
            if found_fk_in_where:
                fk_in_where += 1
            if found_pk_in_where:
                pk_in_where += 1

            if subq:
                if in_from:
                    from_subq_count += 1
                else:
                    subq_count += 1
                    cum_subq_infos = list(
                        map(add, cum_subq_infos,
                            subq_info(task['sql'], schemas[task['db_id']]))
                    )
                    if task['sql']['intersect'] is not None and \
                        contains_subquery(task['sql']['intersect']):
                        subq_count += 1
                        cum_subq_infos = list(
                            map(add, cum_subq_infos,
                                subq_info(task['sql']['intersect'],
                                    schemas[task['db_id']]))
                        )
                    elif task['sql']['except'] is not None and \
                        contains_subquery(task['sql']['except']):
                        subq_count += 1
                        cum_subq_infos = list(
                            map(add, cum_subq_infos,
                                subq_info(task['sql']['except'],
                                    schemas[task['db_id']]))
                        )
                    elif task['sql']['union'] is not None and \
                        contains_subquery(task['sql']['union']):
                        subq_count += 1
                        cum_subq_infos = list(
                            map(add, cum_subq_infos,
                                subq_info(task['sql']['union'],
                                    schemas[task['db_id']]))
                        )

                    print(f'Spider || Mode: {mode} || Task ID: {i+1}')
                    print(f"QUESTION: {task['question']}")
                    print(f"QUERY: {task['query']}\n")
                print(f"-- SUBQUERIES: {subq_count}")
                print(f"-- COVERAGE INFO: {cum_subq_infos}")
                print(f"-- FROM SUBQUERIES: {from_subq_count}\n")

        print(f'ORDER BY (2 Columns): {order_by_2}')
        print(f'ORDER BY (3 Columns): {order_by_3}')

        print(f'FK IN SELECT: {fk_in_select}')
        print(f'FK IN WHERE: {fk_in_where}')
        print(f'PK IN WHERE: {pk_in_where}')


if __name__ == '__main__':
    main()
