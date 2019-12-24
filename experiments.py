import argparse
import configparser
import json

from duoquest.database import Database
from duoquest.external.eval import build_foreign_key_map_from_json
from duoquest.files import results_path
from duoquest.verifier import DuoquestVerifier
from duoquest.nlq_client import NLQClient
from duoquest.schema import Schema
from duoquest.server import DuoquestServer
from duoquest.vars import *

def load_schemas(schemas_path):
    schemas = {}
    schema_file = json.load(open(schemas_path))

    kmaps = build_foreign_key_map_from_json(schema_file)

    for schema_info in schema_file:
        schemas[schema_info['db_id']] = Schema(schema_info)
    return schemas, kmaps

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('dataset', choices=DATASETS)
    parser.add_argument('mode', choices=MODES)
    parser.add_argument('tsq_level', choices=TSQ_LEVELS)
    parser.add_argument('--config_path', default='docker_cfg.ini')
    parser.add_argument('--tsq_rows', type=int, default=1)
    parser.add_argument('--timeout', default=DEFAULT_TIMEOUT, type=int,
        help='Timeout if search does not terminate')

    parser.add_argument('--tid', default=None, type=int, help='debug task id')
    parser.add_argument('--start_tid', default=None, type=int,
        help='start task id')

    # Disable pieces of the system
    parser.add_argument('--disable_clauses', action='store_true')
    parser.add_argument('--disable_semantics', action='store_true')
    parser.add_argument('--disable_column', action='store_true')
    parser.add_argument('--disable_literals', action='store_true')

    # Debugging options
    parser.add_argument('--compare', choices=TSQ_LEVELS,
        help='Compare results against this level')
    parser.add_argument('--debug', action='store_true',
        help='Debugging output')

    args = parser.parse_args()

    config = configparser.ConfigParser()
    config.read(args.config_path)

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

    out_base = results_path(config, args.dataset, args.mode, args.tsq_level,
        args.tsq_rows, args.timeout, args.disable_clauses,
        args.disable_semantics, args.disable_column, args.disable_literals)

    verifier = DuoquestVerifier(debug=args.debug,
        no_fk_select=True,
        no_fk_where=True,
        no_fk_having=True,
        no_fk_group_by=True,
        agg_projected=True,
        disable_set_ops=True,
        disable_subquery=True,
        literals_given=True,
        disable_clauses=args.disable_clauses,
        disable_semantics=args.disable_semantics,
        disable_column=args.disable_column,
        disable_literals=args.disable_literals)
    server = DuoquestServer(int(config['duoquest']['port']),
        config['duoquest']['authkey'].encode('utf-8'), verifier, out_base)

    schemas, kmaps = load_schemas(schemas_path)
    db = Database(db_path, args.dataset)

    nlqc = NLQClient(config['nlq']['host'], int(config['nlq']['port']),
        config['nlq']['authkey'].encode('utf-8'), args.dataset, args.mode)
    server.run_experiments(schemas, db, nlqc, data, args.tsq_level,
        args.tsq_rows, tid=args.tid, compare=args.compare,
        start_tid=args.start_tid, timeout=args.timeout)

if __name__ == '__main__':
    main()
