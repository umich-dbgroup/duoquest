import argparse
import configparser

from duoquest.nlq_client import NLQClient
from duoquest.server import DuoquestServer
from duoquest.verifier import DuoquestVerifier
from duoquest.vars import *

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--timeout', default=60)
    parser.add_argument('--debug', action='store_true', help='Debugging output')
    parser.add_argument('--config_path', default='docker_cfg.ini')
    parser.add_argument('--project_ineq', action='store_true')
    parser.add_argument('--project_agg', action='store_true')
    args = parser.parse_args()

    config = configparser.ConfigParser()
    config.read(args.config_path)

    print('Initializing Duoquest...')
    verifier = DuoquestVerifier(debug=args.debug,
        no_fk_select=True,
        no_fk_where=True,
        no_fk_having=True,
        no_fk_group_by=True,
        no_pk_where=True,
        agg_projected=args.project_agg,
        inequality_projected=args.project_ineq,
        group_by_in_select=True,
        max_group_by=1,
        disable_subquery=True,
        disable_set_ops=True,
        literals_given=True)
    server = DuoquestServer(int(config['duoquest']['port']),
        config['duoquest']['authkey'].encode('utf-8'), verifier,
        db_cfg=config['db'],
        minimal_join_paths=True)
    nlqc = NLQClient(config['nlq']['host'], int(config['nlq']['port']),
        config['nlq']['authkey'].encode('utf-8'))

    print('Cleaning up any old tasks...')
    server.reset_any_running()

    print('Processing queue...')
    while True:
        server.run_next_in_queue(nlqc, timeout=int(args.timeout))

if __name__ == '__main__':
    main()
