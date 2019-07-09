import argparse
import configparser

from duoquest.files import results_path
from duoquest.external.eval import build_foreign_key_map_from_json, evaluate

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('system', choices=['syntaxsql'])
    parser.add_argument('dataset', choices=['spider', 'wikisql'])
    parser.add_argument('mode', choices=['dev', 'test'])
    parser.add_argument('tsq_level', choices=['default', 'no_range',
        'no_values', 'no_duoquest'])
    parser.add_argument('--tsq_rows', type=int, default=1)

    # NLQ parameters
    parser.add_argument('--n', default=10, type=int,
        help='Max number of final queries to output')
    parser.add_argument('--b', default=0, type=int,
        help='Beam search parameter')

    # TODO
    parser.add_argument('--cache', action='store_true', help='Enable cache')

    parser.add_argument('--etype', choices=['all', 'exec', 'match'],
        default='match')
    parser.add_argument('--no_print', action='store_true')
    args = parser.parse_args()

    config = configparser.ConfigParser()
    config.read('../config.ini')

    if args.dataset == 'spider':
        db_dir = config['spider'][f'{args.mode}_db_path']
        table = config['spider'][f'{args.mode}_tables_path']
    elif args.dataset == 'wikisql':
        # TODO
        pass

    pred, gold = results_path(config, args.system, args.dataset, args.mode,
        args.n, args.b, args.tsq_level, args.tsq_rows, args.cache)

    tables_data = json.load(open(table))
    kmaps = build_foreign_key_map_from_json(tables_data)
    tables = {}
    for t in tables_data:
        tables[t['db_id']] = t

    evaluate(gold, pred, db_dir, args.etype, kmaps, tables, args.dataset,
        no_print=args.no_print)
