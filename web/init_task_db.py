import argparse
import configparser
import json
import os
import psycopg2
import sqlite3
import traceback

from redis import Redis

from duoquest.autocomplete import init_autocomplete
from duoquest.schema import Schema

def load_sqlite_db(conn, redis, db_name, db_path):
    cur = conn.cursor()
    cur.execute('SELECT 1 FROM databases WHERE name = %s', (db_name,))
    if cur.fetchone():
        raise Exception(f'Database {db_name} already exists!')

    db_path = os.path.abspath(db_path)
    schema = Schema.from_sqlite(db_name, db_path)
    schema_proto_str = schema.to_proto().SerializeToString()

    init_autocomplete(schema, db_path, redis, debug=True)

    cur = conn.cursor()
    cur.execute('''INSERT INTO databases (type, name, schema_proto, path)
                   VALUES (%s, %s, %s, %s)''',
                   ('sqlite', db_name, schema_proto_str, db_path))
    conn.commit()
    return True

def load_spider_databases(conn, redis, schemas_path, db_root):
    schemas = json.load(open(schemas_path))

    for schema_info in schemas:
        db_name = schema_info['db_id']
        schema = Schema(schema_info)

        schema_proto_str = schema.to_proto().SerializeToString()
        db_path = os.path.join(db_root, f'{db_name}/{db_name}.sqlite')

        db_conn = sqlite3.connect(db_path)
        cur = conn.cursor()
        cur.execute('''INSERT INTO databases (type, name, schema_proto, path)
                       VALUES (%s, %s, %s, %s)''',
                       ('sqlite', db_name, schema_proto_str, db_path))

        print(f'Loading autocomplete for {db_name}...', end='')
        init_autocomplete(schema, db_path, redis)
        print('Done')

        db_conn.close()

    conn.commit()

def delete(conn, name):
    cur = conn.cursor()
    cur.execute(f'DROP DATABASE IF EXISTS {name}')
    print('Deleted database if exists.')

def clear_db(conn):
    cur = conn.cursor()
    cur.execute('DELETE FROM databases;')
    conn.commit()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('command', choices=['init', 'delete', 'load_spider',
        'load_sqlite_db'])
    parser.add_argument('--config_path', default='docker_cfg.ini')
    parser.add_argument('--name')
    parser.add_argument('--file')
    args = parser.parse_args()

    config = configparser.ConfigParser()
    config.read(args.config_path)

    conn = psycopg2.connect(database=config['db']['name'],
            host=config['db']['host'],
            port=config['db']['port'],
            user=config['db']['user'],
            password=config['db']['password'])
    if args.command == 'delete':
        delete(conn, config['db']['name'])
    elif args.command == 'init':
        init(conn)
    elif args.command == 'load_spider':
        clear_db(conn)
        redis = Redis(host=config['redis']['host'],
            port=config['redis']['port'], db=0)
        load_spider_databases(conn, redis, config['spider']['dev_tables_path'],
            config['spider']['dev_db_path'])
    elif args.command == 'load_sqlite_db':
        if not args.name:
            print('--name option required!')
            exit()
        if not args.file:
            print('--file option required!')
            exit()
        redis = Redis(host=config['redis']['host'],
            port=config['redis']['port'], db=0)
        try:
            load_sqlite_db(conn, redis, args.name, args.file)
        except Exception as e:
            traceback.print_exc()
            exit()

    conn.close()

if __name__ == '__main__':
    main()
