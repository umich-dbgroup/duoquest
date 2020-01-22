import argparse
import configparser
import json
import os
from pprint import pprint
import subprocess
import time

from duoquest.database import Database
from duoquest.files import squid_results_path
from duoquest.proto.duoquest_pb2 import NO_AGG
from duoquest.schema import Schema
from duoquest.server import get_literals
from duoquest.tasks import is_valid_task
from duoquest.vars import *

#########################
# CONFIGURATION VARIABLES
#########################
SQUID_DIR = '/Users/cjbaik/dev/squid-public/'
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

def run_squid_experiments(tasks, db, schemas, tsq_rows, tid=None,
    start_tid=None):
    ranks = []
    times = []

    for i, task in enumerate(tasks):
        task_id = i+1
        if tid and task_id != tid:
            continue
        if start_tid and task_id < start_tid:
            continue

        schema = schemas[task['db_id']]
        start = time.time()
        cqs, squid_unsupported = run_experiment(task_id, len(tasks), task, db,
            schema, tsq_rows)
        task_time = time.time() - start

        # TODO: count differently if unsupported by squid
        if squid_unsupported:
            pass

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
    for agg_col in pq.select:
        if agg_col.agg != NO_AGG:
            raise SquidException()
        col = schema.get_col(agg_col.col_id)
        if col.type != 'text':
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
        return None, True
    except Exception:
        print('Skipping task because it is out of scope.')
        return None, False

    literals = get_literals(task['pq'], schema)

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

    cqs = []
    for line in output.decode('utf-8').split('\n'):
        if line:
            cqs.append(json.loads(line))

    pprint(cqs)
    # TODO: return something meaningful
    return [], False

if __name__ == '__main__':
    main()
