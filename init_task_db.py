import argparse
import configparser
import json
import os
import sqlite3

from walrus import Walrus

from duoquest.autocomplete import init_autocomplete
from duoquest.schema import Schema

def load_db_from_file(conn, walrus, db_name, db_path):
    db_path = os.path.abspath(db_path)
    schema = Schema.from_db_path(db_name, db_path)
    schema_proto_str = schema.to_proto().SerializeToString()

    init_autocomplete(schema, db_path, walrus, debug=True)

    cur = conn.cursor()
    cur.execute('''INSERT INTO databases (name, schema_proto, path)
                   VALUES (?, ?, ?)''', (db_name, schema_proto_str, db_path))
    conn.commit()
    return True

def load_spider_databases(conn, walrus, schemas_path, db_root):
    schemas = json.load(open(schemas_path))

    for schema_info in schemas:
        db_name = schema_info['db_id']
        schema = Schema(schema_info)

        schema_proto_str = schema.to_proto().SerializeToString()
        db_path = os.path.join(db_root, f'{db_name}/{db_name}.sqlite')

        cur = conn.cursor()
        cur.execute('''INSERT INTO databases (name, schema_proto, path)
                       VALUES (?, ?, ?)''',
                       (db_name, schema_proto_str, db_path))

        print(f'Loading autocomplete for {db_name}...', end='')
        init_autocomplete(schema, db_path, walrus)
        print('Done')

        db_conn.close()

    conn.commit()

def delete(db_path):
    if os.path.exists(db_path):
        response = \
            input(f'Delete <{db_path}>? (y/N)\n')
        if response.strip().lower() == 'y':
            os.remove(db_path)
            print(f'Deleted {db_path}.')
        else:
            print('Not deleting database.')
    else:
        print(f'<{db_path}> does not exist. Nothing to delete.')

def init(conn):
    cur = conn.cursor()
    print('Creating tables...', end='')
    cur.execute('''CREATE TABLE tasks
                (tid text, db text, nlq text, tsq_proto blob, status text,
                 time integer, error_msg text)''')
    cur.execute('''CREATE TABLE databases
                (name text, path text, schema_proto blob)''')
    cur.execute('''CREATE TABLE results
                (rid INTEGER PRIMARY KEY, tid text, query text)''')
    conn.commit()
    print('Done')

def clear_db(conn):
    cur = conn.cursor()
    cur.execute('DELETE FROM databases;')
    conn.commit()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('command', choices=['init', 'delete', 'load_db',
        'load_db_from_file'])
    parser.add_argument('--name')
    parser.add_argument('--file')
    args = parser.parse_args()

    config = configparser.ConfigParser()
    config.read('config.ini')
    db_path = config['db']['path']

    if args.command == 'delete':
        delete(db_path)
    elif args.command == 'init':
        conn = sqlite3.connect(db_path)
        init(conn)
        conn.close()
    elif args.command == 'load_db':
        conn = sqlite3.connect(db_path)
        clear_db(conn)
        walrus = Walrus(host=config['walrus']['host'],
            port=config['walrus']['port'], db=0)
        load_spider_databases(conn, walrus, config['spider']['dev_tables_path'],
            config['spider']['dev_db_path'])
        conn.close()
    elif args.command == 'load_db_from_file':
        if not args.name:
            print('--name option required!')
            exit()
        if not args.file:
            print('--file option required!')
            exit()
        conn = sqlite3.connect(db_path)
        walrus = Walrus(host=config['walrus']['host'],
            port=config['walrus']['port'], db=0)
        load_db_from_file(conn, walrus, args.name, args.file)
        conn.close()

if __name__ == '__main__':
    main()
