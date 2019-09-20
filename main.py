import argparse
import configparser

from duoquest.nlq_client import NLQClient
from duoquest.server import DuoquestServer
from duoquest.verifier import DuoquestVerifier
from duoquest.vars import *

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--timeout', default=30)
    parser.add_argument('--debug', action='store_true', help='Debugging output')
    args = parser.parse_args()

    config = configparser.ConfigParser()
    config.read('config.ini')

    print('Initializing Duoquest...')
    verifier = DuoquestVerifier(debug=args.debug,
        no_fk_select=True,
        no_fk_where=True,
        no_pk_where=True,
        no_fk_group_by=True,
        group_by_in_select=True,
        disable_set_ops=True)
    server = DuoquestServer(int(config['duoquest']['port']),
        config['duoquest']['authkey'].encode('utf-8'), verifier,
        task_db=config['db']['path'],
        minimal_join_paths=True)
    nlqc = NLQClient(int(config['nlq']['port']),
        config['nlq']['authkey'].encode('utf-8'))

    print('Cleaning up any old tasks...')
    server.reset_any_running()

    print('Processing queue...')
    while True:
        server.run_next_in_queue(nlqc, timeout=int(args.timeout))

if __name__ == '__main__':
    main()
