import argparse
import configparser
import json
import os

from modules.mixtape import Mixtape
from modules.nlq_client import NLQClient
from modules.server import MixtapeServer

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('system', choices=['syntaxsql'])
    parser.add_argument('dataset', choices=['spider', 'wikisql'])
    parser.add_argument('mode', choices=['dev', 'test'])

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
    if args.dataset == 'spider':
        data = json.load(open(config['spider'][f'{args.mode}_path']))
    elif args.dataset == 'wikisql':
        # TODO
        pass

    # Set out_path
    basename = '_'.join([args.system, args.dataset, args.mode, f'n{args.n}',
        f'b{args.b}', f'm{int(args.mixtape)}', f'c{int(args.cache)}'])
    out_path = os.path.join('../results', f'{basename}.sqls')

    mixtape = Mixtape(enabled=args.mixtape, use_cache=args.cache)
    server = MixtapeServer(config['mixtape']['port'],
        config['mixtape']['authkey'].encode('utf-8'), mixtape, out_path, args.n,
        args.b)
    nlqc = NLQClient(config['nlq']['port'],
        config['nlq']['authkey'].encode('utf-8'))
    server.run_tasks(nlqc, data)

if __name__ == '__main__':
    main()
