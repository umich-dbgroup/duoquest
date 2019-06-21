import argparse
import configparser
import json

from modules.client import TaskClient

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('system', choices=['syntaxsql'])
    parser.add_argument('dataset', choices=['spider', 'wikisql'])
    parser.add_argument('mode', choices=['dev', 'test'])
    parser.add_argument('--out_path', default='mixtape.sqls')

    # Server args
    parser.add_argument('--port', default=6000)
    parser.add_argument('--authkey', default=b'mixtape')

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
        if args.mode == 'dev':
            data = json.load(open(config['spider']['dev_path']))
        elif args.mode == 'test':
            data = json.load(open(config['spider']['test_path']))
    elif args.dataset == 'wikisql':
        # TODO
        pass

    # Run each task
    if args.mixtape:
        # TODO if activated
        pass
    else:
        client = TaskClient(args.port, args.authkey)
        client.connect()
        f = open(args.out_path, 'w+')
        for i, task in enumerate(data):
            cqs = client.run(task['db_id'], task['question'])
            print('{}/{} || Database: {} || NLQ: {}'.format(i, len(data),
                task['db_id'], task['question']))
            if cqs:
                f.write(u'\t'.join(cqs))
            else:
                f.write('SELECT A FROM B')  # failure
            f.write('\n')
        f.close()
        client.close()

if __name__ == '__main__':
    main()
