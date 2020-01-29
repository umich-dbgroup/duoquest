import argparse
import configparser
import json
import traceback

from pprint import pprint
from tqdm import tqdm

from experiments import load_schemas

from duoquest.database import Database
from duoquest.eval import detect_level
from duoquest.proto.duoquest_pb2 import NO_AGG, NEQ, NOT_IN, LIKE
from duoquest.query import *
from duoquest.schema import JoinPathException
from duoquest.tasks import *

def is_squid_valid(schema, pq):
    if len(pq.select) >= 3:
        return False

    for agg_col in pq.select:
        if agg_col.agg != NO_AGG:
            return False
        col = schema.get_col(agg_col.col_id)
        if col.type != 'text':
            return False

    for pred in pq.where.predicates:
        if pred.op in (NEQ, NOT_IN, LIKE):
            return False

    if len(pq.order_by) > 0:
        return False

    return True

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('mode', choices=['dev', 'test'])
    args = parser.parse_args()

    config = configparser.ConfigParser()
    config.read('config.ini')

    data = json.load(open(config['spider'][f'{args.mode}_path']))
    db_path = config['spider'][f'{args.mode}_db_path']
    schemas_path = config['spider'][f'{args.mode}_tables_path']

    schemas, _ = load_schemas(schemas_path)
    db = Database(db_path, 'spider')

    errors = {
        'agg_type': 0,
        'op_type': 0,
        'subquery': 0,
        'empty': 0,
        'group_by': 0,
        'wildcard': 0,
        'col_type': 0,
        'inconsistent_predicate': 0,
        'foreign_key': 0,
        'col_binary_op': 0,
        'logical_op': 0,
        'multi_order_by': 0,
        'set_op': 0,
        'join_path': 0,
        'value': 0,
        'misc': 0
    }
    valid = 0
    tasks_by_level = {
        'easy': 0,
        'medium': 0,
        'hard': 0
    }

    squid_valid = 0
    squid_tasks_by_level = {
        'easy': 0,
        'medium': 0,
        'hard': 0
    }
    squid_multi_projections = 0
    squid_dbs = set()

    dbs = set()

    num_preds_acc = 0
    by_op = {}

    for i, task in enumerate(tqdm(data)):
        try:
            schema = schemas[task['db_id']]
            query, pq = is_valid_task(schema, db, task['sql'])
            dbs.add(task['db_id'])
            level = detect_level(pq)
            tasks_by_level[level] += 1

            if is_squid_valid(schema, pq):
                squid_valid += 1
                squid_tasks_by_level[level] += 1
                squid_dbs.add(task['db_id'])

                if len(pq.select) > 1:
                    squid_multi_projections += 1

            tsq = db.generate_tsq(i+1, schemas[task['db_id']], query, pq,
                'default', 1)
            valid += 1
        except AggTypeMismatchException as e:
            errors['agg_type'] += 1
        except OpTypeMismatchException as e:
            errors['op_type'] += 1
        except (SubqueryException, FromSubqueryException) as e:
            errors['subquery'] += 1
        except EmptyResultException as e:
            errors['empty'] += 1
        except InvalidGroupByException as e:
            errors['group_by'] += 1
        except WildcardColumnException as e:
            errors['wildcard'] += 1
        except UnsupportedColumnTypeException as e:
            errors['col_type'] += 1
        except ForeignKeyException as e:
            errors['foreign_key'] += 1
        except ColumnBinaryOpException as e:
            errors['col_binary_op'] += 1
        except MultipleLogicalOpException as e:
            errors['logical_op'] += 1
        except MultipleOrderByException as e:
            errors['multi_order_by'] += 1
        except SetOpException as e:
            errors['set_op'] += 1
        except JoinPathException as e:
            errors['join_path'] += 1
        except InvalidValueException as e:
            errors['value'] += 1
        except InconsistentPredicateException as e:
            errors['inconsistent_predicate'] += 1
        except Exception as e:
            traceback.print_exc()
            errors['misc'] += 1

    print(f'\nVALID: {valid}')
    for level, num in tasks_by_level.items():
        print(f' - {level}: {num}')

    print(f'\nSQUID VALID: {squid_valid}')
    for level, num in squid_tasks_by_level.items():
        print(f' - {level}: {num}')
    print(f'SQUID MULTI PROJECTIONS: {squid_multi_projections}')
    print(f'SQUID DBS ({len(squid_dbs)}): {squid_dbs}')

    print(f'\nUNIQUE DATABASES: {len(dbs)}')

    cum_tables = 0
    cum_cols = 0
    cum_fkpk = 0
    for dbid in dbs:
        cum_tables += len(schemas[dbid].tables)
        cum_cols += len(schemas[dbid].columns) - 1
        cum_fkpk += len(list(filter(lambda c: c.fk_ref, schemas[dbid].columns)))
    print(f' - AVG TBLS: {cum_tables / len(dbs)}')
    print(f' - AVG COLS: {cum_cols / len(dbs)}')
    print(f' - AVG FKPK: {cum_fkpk / len(dbs)}')

    print('ERRORS')
    print('------')
    pprint(errors)

if __name__ == '__main__':
    main()
