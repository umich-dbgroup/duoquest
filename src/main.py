import argparse
import configparser
import json

from modules.client import TaskClient

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('system', choices=['syntaxsql'])
    parser.add_argument('dataset', choices=['spider', 'wikisql'])
    parser.add_argument('mode', choices=['dev', 'test'])

    # Server args
    parser.add_argument('--port', default=6000)
    parser.add_argument('--authkey', default=b'mixtape')

    # TODO: pass this through the connection too
    parser.add_argument('--n', default=1, type=int,
        help='Max number of final queries to output')
    parser.add_argument('--b', default=1, type=int,
        help='Beam search parameter')

    # Enabling/disabling features
    parser.add_argument('--mixtape', action='store_true', help='Enable Mixtape')

    # TODO
    parser.add_argument('--cache', action='store_true', help='Enable cache')
    parser.add_argument('--batch', action='store_true', help='Enable batching')

    args = parser.parse_args()

    config = configparser.ConfigParser()
    config.read('config.ini')

    # Load dataset
    data = None
    if args.dataset == 'spider':
        data = config['spider']['{}_path'.format(args.mode)]
    elif args.dataset == 'wikisql':
        # TODO
        pass

    # Set out_path
    # TODO: add other options (n, b, mixtape, cache, batch) into name
    basename = '_'.join([args.system, args.dataset, args.mode])
    out_path = os.path.join('../results', '{}.sqls'.format(basename))

    # Run each task
    if args.mixtape:
        # TODO if activated
        pass
    else:
        client = TaskClient(args.port, args.authkey)
        client.connect()
        f = open(out_path, 'w+')
        for i, task in enumerate(data):
            print('{}/{} || Database: {} || NLQ: {}'.format(i, len(data),
                task['db_id'], task['question_toks']))
            cqs = client.run(task['db_id'], task['question_toks'])
            if cqs:
                f.write(u'\t'.join(cqs))
            else:
                f.write('SELECT A FROM B')  # failure
            f.write('\n')
        f.close()
        client.close()

if __name__ == '__main__':
    main()
