import configparser
import sqlite3
import time
import uuid

from duoquest.tsq import TableSketchQuery

def input_db_name(conn):
    while True:
        db_name = input('Database name (default: concert_singer) > ')
        if not db_name:
            db_name = 'concert_singer'
        cur = conn.cursor()

        cur.execute('SELECT 1 FROM databases WHERE name = ?', (db_name,))
        if cur.fetchone():
            break
        else:
            print(f'<{db_name}> is not a valid database.')
    return db_name

def input_nlq():
    nlq = input('NLQ (default: How many singers are there?)> ')
    if not nlq:
        nlq = 'How many singers are there?'
    return nlq

def input_num_cols():
    while True:
        num_cols = input('Number of columns > ')
        try:
            num_cols = int(num_cols)
            break
        except Exception as e:
            print('Number of columns should be integer!')
    return num_cols

def input_order():
    ordered = False
    while True:
        order_input = input('Should results be ordered? (y/n) > ')
        if order_input == 'y':
            ordered = True
            break
        elif order_input == 'n':
            break
        else:
            print('y/n only!')
    return ordered

def input_limit():
    limit = None
    while True:
        limit_input = input('Limit results to n tuples? (int or blank) > ')
        if not limit_input:
            break
        try:
            limit = int(limit_input)
            break
        except Exception as e:
            print('int or blank only!')
    return limit

def input_tsq_types(num_cols):
    while True:
        types_input = input('Types (`text` or `number`, comma separated)> ')
        types = list(map(lambda x: x.strip(), types_input.split(',')))

        if any(map(lambda x: x not in ('text', 'number'), types)):
            print('Types must be `text` or `number`')
            continue

        if len(types) != num_cols:
            print('Number of types must match number of columns.')
            continue
        break

    return types

def input_tsq_row_count():
    tsq_row_count = 0
    while True:
        tsq_row_count_input = input('Number of TSQ rows (int) > ')
        try:
            tsq_row_count = int(tsq_row_count_input)
            break
        except Exception as e:
            print('int only!')
    return tsq_row_count

def input_tsq_row(row_num, tsq_types):
    while True:
        row_input = input(f'Row {row_num} (semicolon-separated values) > ')
        tsq_row = list(map(lambda x: x.strip(), row_input.split(';')))

        validated = True
        for i, cell in enumerate(tsq_row):
            if tsq_types[i] == 'number':
                try:
                    float(cell)
                except Exception as e:
                    print('At least one cell value is invalid.')
                    validated = False
                    break
        if validated:
            break

    return tsq_row

def main():
    config = configparser.ConfigParser()
    config.read('config.ini')
    db_path = config['db']['path']

    conn = sqlite3.connect(db_path)

    db_name = input_db_name(conn)
    nlq = input_nlq()
    num_cols = input_num_cols()

    tsq = TableSketchQuery(num_cols)

    tsq.types = input_tsq_types(num_cols)

    tsq_row_count = input_tsq_row_count()
    for i in range(tsq_row_count):
        tsq.values.append(input_tsq_row(i+1, tsq.types))

    tsq.order = input_order()
    tsq.limit = input_limit()

    print(tsq.to_proto())

    cur = conn.cursor()
    cur.execute('''INSERT INTO tasks (tid, db, nlq, tsq_proto, status, time)
                   VALUES (?, ?, ?, ?, ?, ?)''',
                   (str(uuid.uuid4()), db_name, nlq,
                    tsq.to_proto().SerializeToString(), 'waiting',
                    int(time.time())))
    conn.commit()
    conn.close()

if __name__ == '__main__':
    main()
