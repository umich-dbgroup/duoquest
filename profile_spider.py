import argparse
import configparser
import json

from pprint import pprint
from tqdm import tqdm

from experiments import load_schemas

from duoquest.database import Database
from duoquest.query import *
from duoquest.schema import JoinPathException
from duoquest.tasks import *

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
        'foreign_key': 0,
        'col_binary_op': 0,
        'logical_op': 0,
        'multi_order_by': 0,
        'set_op': 0,
        'join_path': 0,
        'value': 0
    }
    valid = 0
    for task in tqdm(data):
        try:
            is_valid_task(schemas[task['db_id']], db, task['sql'])
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

    print(f'VALID: {valid}')
    print('ERRORS')
    print('------')
    pprint(errors)

if __name__ == '__main__':
    main()
