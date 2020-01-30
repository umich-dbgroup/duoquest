import argparse
import configparser
import json
import os
from pprint import pprint
import subprocess
import time
import traceback

from duoquest.database import Database
from duoquest.files import squid_results_path
from duoquest.proto.duoquest_pb2 import NO_AGG, NEQ, NOT_IN, LIKE
from duoquest.schema import Schema
from duoquest.tasks import is_valid_task
from duoquest.vars import *

#########################
# CONFIGURATION VARIABLES
#########################
SQUID_DIR = '/Users/cjbaik/dev/squid-public/'
SQUID_SCHEMAS = '/Users/cjbaik/dev/duoquest/squid/schema_test/'
CLASSPATH = '/Users/cjbaik/dev/squid-public/out/production/squid-public/'
LIB_PATH = '/Users/cjbaik/dev/squid-public/lib'
PG_DUMP_PATH = '/usr/local/opt/postgresql@9.6/bin/pg_dump'
DB_USER = 'afariha'
DB_PW = '123456'
LOG_LEVEL = 'SEVERE'
RHO = '0.1'
ETA = '100'
GAMMA = '1'
TAU_A = '0'
TAU_S = '0'

for filename in os.listdir(LIB_PATH):
    if filename.endswith('.jar'):
        CLASSPATH += ':' + os.path.join(LIB_PATH, filename)
###########################


def load_schemas(schemas_path):
    schemas = {}
    schema_file = json.load(open(schemas_path))

    for schema_info in schema_file:
        schemas[schema_info['db_id']] = Schema(schema_info)
    return schemas

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('dataset', choices=DATASETS)
    parser.add_argument('mode', choices=MODES)
    parser.add_argument('--config_path', default='docker_cfg.ini')
    parser.add_argument('--tsq_rows', type=int, default=2)

    parser.add_argument('--tid', default=None, type=int, help='debug task id')
    parser.add_argument('--start_tid', default=None, type=int,
        help='start task id')

    args = parser.parse_args()

    config = configparser.ConfigParser()
    config.read(args.config_path)

    tasks = json.load(open(config['spider'][f'{args.mode}_path']))
    db_path = config['spider'][f'{args.mode}_db_path']
    schemas_path = config['spider'][f'{args.mode}_tables_path']

    schemas = load_schemas(schemas_path)
    db = Database(db_path, args.dataset)

    out_base = squid_results_path(config, args.dataset, args.mode, args.tsq_rows)

    run_squid_experiments(tasks, db, schemas, args.tsq_rows, tid=args.tid,
        start_tid=args.start_tid)

def get_primary_attr_from_meta(meta, table):
    for attr in meta['primaryAttributeWithinDimension']:
        attr_tbl, attr_col = attr.split(':')
        if attr_tbl.lower() == table.lower():
            return attr_col.lower()
    return None

def check_attribute_changes(meta, table, attr):
    for change in meta['attributeChanges']:
        orig_tbl, orig_col = change[0].split(':')
        if orig_tbl.lower() == table.lower() and \
            orig_col.lower() == attr.lower():
            return change[1].lower().split(':')
    return table.lower(), attr.lower()

def eval_squid(schema, pq, filters):
    if len(pq.where.predicates) == 0:
        return True
    else:
        if len(filters) == 0:
            return False

        meta = json.load(open(os.path.join(SQUID_SCHEMAS, 'meta',
            f'{schema.db_id}.json')))

        answer_set = set()
        for pred in pq.where.predicates:
            col = schema.get_col(pred.col_id)
            table, attr = check_attribute_changes(meta, col.table.syn_name,
                col.syn_name)

            if 'id' in attr:
                primary_attr = get_primary_attr_from_meta(meta, table)
                if primary_attr:
                    attr = primary_attr

            answer_set.add(f'{table}:{attr}'.lower())

        filter_set = set()
        for f in filters:
            table, attr = check_attribute_changes(meta, f['table'], f['attr'])

            if 'id' in attr:
                primary_attr = get_primary_attr_from_meta(meta, f['table'])
                if primary_attr:
                    attr = primary_attr

            filter_set.add(f'{table}:{attr}'.lower())

        print(answer_set)
        print(filter_set)

        return filter_set >= answer_set

def run_squid_experiments(tasks, db, schemas, tsq_rows, tid=None,
    start_tid=None):
    invalid_count = 0
    squid_unsupported_count = 0
    correct_count = 0
    incorrect_count = 0

    easy_count = 0
    easy_correct_count = 0

    times = []

    for i, task in enumerate(tasks):
        task_id = i+1
        if tid and task_id != tid:
            continue
        if start_tid and task_id < start_tid:
            continue

        schema = schemas[task['db_id']]
        start = time.time()
        filters, invalid, squid_unsupported = run_experiment(task_id, len(tasks), task,
            db, schema, tsq_rows)
        task_time = time.time() - start

        if invalid:
            invalid_count += 1
        elif squid_unsupported:
            squid_unsupported_count += 1
        else:
            correct = eval_squid(schema, task['pq'], filters)

            if len(task['pq'].where.predicates) == 0:
                easy_count += 1

            if correct:
                correct_count += 1
                if len(task['pq'].where.predicates) == 0:
                    easy_correct_count += 1
                print('CORRECT :D')
            else:
                incorrect_count += 1
                print('INCORRECT !!!')

            times.append(task_time)

    total_count = len(tasks) - invalid_count
    print(f'CORRECT: {correct_count}/{total_count} ({correct_count/total_count*100:.2f}%)')
    print(f'- EASY: {easy_correct_count}/{easy_count}')
    print(f'- MEDIUM: {correct_count - easy_correct_count}/{total_count - easy_count}')
    print(f'INCORRECT: {incorrect_count}/{total_count} ({incorrect_count/total_count*100:.2f}%)')
    print(f'UNSUPPORTED: {squid_unsupported_count}/{total_count} ({squid_unsupported_count/total_count*100:.2f}%)')

    print(f'AVG TIME: {sum(times)/len(times):.2f} s')

def tsq_to_squid_spec(tsq):
    rows = []
    for row in tsq.values:
        quoted_row = []
        for col in row:
            quoted_row.append(f'"{col}"')
        rows.append(','.join(quoted_row))
    return '\n'.join(rows)

class SquidException(Exception):
    pass

def is_valid_squid_task(schema, pq):
    if len(pq.select) >= 3:
        raise SquidException()
    for agg_col in pq.select:
        if agg_col.agg != NO_AGG:
            raise SquidException()
        col = schema.get_col(agg_col.col_id)
        if col.type != 'text':
            raise SquidException()
    for pred in pq.where.predicates:
        if pred.op in (NEQ, NOT_IN, LIKE):
            raise SquidException()
    if len(pq.order_by) > 0:
        raise SquidException()

def run_experiment(task_id, task_count, task, db, schema, tsq_rows):
    print('{}/{} || Database: {} || NLQ: {}'.format(task_id, task_count,
        task['db_id'], task['question_toks']))

    try:
        task['query'], task['pq'] = is_valid_task(schema, db, task['sql'])
        is_valid_squid_task(schema, task['pq'])
    except SquidException:
        print('SQuID does not support this type of task.')
        return None, False, True
    except Exception:
        # traceback.print_exc()
        print('Skipping task because it is out of scope.')
        return None, True, False

    # auto skip if correct (no predicates)
    if len(task['pq'].where.predicates) == 0:
        return [], False, False

    tsq = db.generate_tsq(task_id, schema, task['query'], task['pq'], 'default',
        tsq_rows)
    print(tsq)

    squid_spec = tsq_to_squid_spec(tsq)

    output = subprocess.check_output(['java', '-cp', CLASSPATH, 'main.ConsoleMain',
        squid_spec,
        '--dbName', task['db_id'], '--dbUser', DB_USER, '--dbPassword', DB_PW,
        '--pgDumpPath', PG_DUMP_PATH, '--logLvl', LOG_LEVEL,
        '--rho', RHO, '--eta', ETA, '--gamma', GAMMA, '--tau_a', TAU_A,
        '--tau_s', TAU_S, '--disambiguateActive', '--useSkewness'], cwd=SQUID_DIR)

    result = []
    for line in output.decode('utf-8').split('\n'):
        if line:
            result.append(json.loads(line))

    pprint(result)

    filters = []
    for cq in result:
        filters.extend(cq['filters'])

    return filters, False, False

if __name__ == '__main__':
    main()
