import configparser
import json
import os
import sqlite3

from duoquest.schema import Schema

def load_spider_databases(conn, schemas_path, db_root):
    schemas = json.load(open(schemas_path))

    for schema_info in schemas:
        db_id = schema_info['db_id']
        schema = Schema(schema_info)

        schema_proto_str = schema.to_proto().SerializeToString()
        db_path = os.path.join(db_root, f'{db_id}/{db_id}.sqlite')

        cur = conn.cursor()
        cur.execute('''INSERT INTO databases (name, schema_proto, path)
                       VALUES (?, ?, ?)''', (db_id, schema_proto_str, db_path))

    conn.commit()

def main():
    config = configparser.ConfigParser()
    config.read('config.ini')
    db_path = config['db']['path']

    if os.path.exists(db_path):
        response = \
            input(f'<{db_path}> already exists. Should I delete it? (y/N)\n')
        if response.strip().lower() == 'y':
            os.remove(db_path)
            print(f'Deleted {db_path}.')
        else:
            print('Exiting without initializing new database.')
            exit()

    print(f'Creating task database: <{db_path}>...', end='')
    conn = sqlite3.connect(db_path)
    print('Done')

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

    print('Loading Spider dev databases...', end='')
    load_spider_databases(conn, config['spider']['dev_tables_path'],
        config['spider']['dev_db_path'])
    print('Done')

    conn.close()

if __name__ == '__main__':
    main()
