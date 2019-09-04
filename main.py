import argparse
import configparser

from duoquest.nlq_client import NLQClient
from duoquest.server import DuoquestServer
from duoquest.verifier import DuoquestVerifier
from duoquest.vars import *

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--tsq_level', choices=TSQ_LEVELS, default='default')
    parser.add_argument('--debug', action='store_true', help='Debugging output')
    args = parser.parse_args()

    config = configparser.ConfigParser()
    config.read('config.ini')

    print('Initializing Duoquest...')
    verifier = DuoquestVerifier(debug=args.debug)
    server = DuoquestServer(int(config['duoquest']['port']),
        config['duoquest']['authkey'].encode('utf-8'), verifier,
        task_db=config['db']['path'])
    nlqc = NLQClient(int(config['nlq']['port']),
        config['nlq']['authkey'].encode('utf-8'))

    print('Processing queue...')
    while True:
        server.run_next_in_queue(nlqc, args.tsq_level)

if __name__ == '__main__':
    main()
