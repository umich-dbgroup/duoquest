import argparse
import configparser
import json
import os

from modules.database import Database
from modules.mixtape import Mixtape
from modules.nlq_client import NLQClient
from modules.schema import Schema
from modules.server import MixtapeServer

def load_schemas(schemas_path):
    schemas = {}
    schema_file = json.load(open(schemas_path))
    for schema_info in schema_file:
        schemas[schema_info['db_id']] = Schema(schema_info)
    return schemas

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('system', choices=['syntaxsql'])
    parser.add_argument('dataset', choices=['spider', 'wikisql'])
    parser.add_argument('mode', choices=['dev', 'test'])
    parser.add_argument('tsq_level', choices=['default', 'no_range',
        'no_exact', 'no_type'])
    parser.add_argument('--tsq_rows', type=int, default=1)

    # NLQ parameters
    parser.add_argument('--n', default=1, type=int,
        help='Max number of final queries to output')
    parser.add_argument('--b', default=1, type=int,
        help='Beam search parameter')

    parser.add_argument('--mixtape', action='store_true', help='Enable Mixtape')

    # TODO
    parser.add_argument('--cache', action='store_true', help='Enable cache')
    # parser.add_argument('--batch', action='store_true', help='Enable batching')

    args = parser.parse_args()

    config = configparser.ConfigParser()
    config.read('config.ini')

    # Load dataset
    data = None
    db_path = None
    schemas_path = None
    if args.dataset == 'spider':
        data = json.load(open(config['spider'][f'{args.mode}_path']))
        db_path = config['spider'][f'{args.mode}_db_path']
        schemas_path = config['spider'][f'{args.mode}_tables_path']
    elif args.dataset == 'wikisql':
        # TODO
        pass

    # Set out_path
    basename = '_'.join([args.system, args.dataset, args.mode, f'n{args.n}',
        f'b{args.b}', args.tsq_level, f'r{args.tsq_rows}',
        f'm{int(args.mixtape)}', f'c{int(args.cache)}'])
    out_path = os.path.join('../results', f'{basename}.sqls')

    mixtape = Mixtape(enabled=args.mixtape, use_cache=args.cache)
    server = MixtapeServer(int(config['mixtape']['port']),
        config['mixtape']['authkey'].encode('utf-8'), mixtape, out_path, args.n,
        args.b)

    schemas = load_schemas(schemas_path)
    db = Database(db_path, args.dataset)

    nlqc = NLQClient(int(config['nlq']['port']),
        config['nlq']['authkey'].encode('utf-8'))
    server.run_tasks(schemas, db, nlqc, data, args.tsq_level, args.tsq_rows)

if __name__ == '__main__':
    main()
