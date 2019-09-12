import sqlite3

from tqdm import tqdm

def is_number(val):
    try:
        float(val)
        return True
    except Exception as e:
        return False

def init_autocomplete(schema, db_path, redis, debug=False):
    if debug:
        print('Flushing autocomplete...', end='')
    redis.delete(schema.db_id)
    if debug:
        print('Done')

    conn = sqlite3.connect(db_path)
    conn.text_factory = bytes

    phrases = set()
    if debug:
        print('Retrieving phrases from columns...')

    iterator = schema.columns
    if debug:
        iterator = tqdm(iterator)

    for col in iterator:
        if col.type != 'text' or col.syn_name == '*':
            continue

        cur = conn.cursor()
        cur.execute(f'SELECT DISTINCT "{col.syn_name}" FROM "{col.table.syn_name}"')
        for phrase in cur.fetchall():
            if phrase[0] and not is_number(phrase[0]):
                try:
                    phrases.add(f'{phrase[0].decode()}\t{col.id}')
                except Exception as e:
                    continue

    if debug:
        print('Storing phrases in autocomplete...')
    phrases = list(phrases)
    batch_size = 20000
    iterator = range(0, len(phrases), batch_size)
    if debug:
        iterator = tqdm(iterator)
    for start in iterator:
        end = start + batch_size
        redis.zadd(schema.db_id, dict.fromkeys(phrases[start:end], 0), nx=True)
