import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('system', choices=['syntaxsql'])
    parser.add_argument('dataset', choices=['spider', 'wikisql'])
    parser.add_argument('mode', choices=['dev', 'test'])
    parser.add_argument('--mixtape', action='store_true', help='Enable Mixtape')
    parser.add_argument('--b', default=5, type=int,
        help='Beam search parameter')
    parser.add_argument('--n', default=5, type=int,
        help='Max number of final queries to output')
    parser.add_argument('--cache', action='store_true', help='Enable cache')
    parser.add_argument('--batch', action='store_true', help='Enable batching')
    args = parser.parse_args()

    # TODO: ensure system server is running
    # TODO: load dataset

if __name__ == '__main__':
    main()
