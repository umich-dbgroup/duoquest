import argparse
import configparser
import json

# from duoquest.database import Database
from duoquest.files import results_path
from duoquest.eval import eval_duoquest
from duoquest.proto.duoquest_pb2 import ProtoExperimentSet
from duoquest.vars import *

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('dataset', choices=DATASETS)
    parser.add_argument('mode', choices=MODES)
    parser.add_argument('tsq_level', choices=TSQ_LEVELS)
    parser.add_argument('--config_path', default='docker_cfg.ini')
    parser.add_argument('--tsq_rows', type=int, default=1)
    parser.add_argument('--timeout', type=int, default=DEFAULT_TIMEOUT)
    parser.add_argument('--n', default=None, type=int,
        help='n to constrain CDF')

    parser.add_argument('--disable_clauses', action='store_true')
    parser.add_argument('--disable_semantics', action='store_true')
    parser.add_argument('--disable_column', action='store_true')
    parser.add_argument('--disable_literals', action='store_true')

    args = parser.parse_args()

    config = configparser.ConfigParser()
    config.read(args.config_path)

    out_base = results_path(config, args.dataset, args.mode, args.tsq_level,
        args.tsq_rows, args.timeout, args.disable_clauses,
        args.disable_semantics, args.disable_column, args.disable_literals)

    exp_set = ProtoExperimentSet()
    with open(f'{out_base}.exp', 'rb') as f:
        exp_set.ParseFromString(f.read())

    eval_duoquest(exp_set, n=args.n)
