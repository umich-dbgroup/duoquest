import sqlite3

from tqdm import tqdm

def is_number(val):
    try:
        float(val)
        return True
    except Exception as e:
        return False

def init_autocomplete(schema, db_path, walrus, debug=False):
    ac = walrus.autocomplete(namespace=schema.db_id)
    if debug:
        print('Flushing autocomplete...', end='')
    ac.flush()
    if debug:
        print('Done')

    conn = sqlite3.connect(db_path)
    conn.text_factory = bytes

    phrases = set()
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
                    phrases.add(phrase[0].decode())
                except Exception as e:
                    continue

    print('Storing phrases in autocomplete...')
    iterator = phrases
    if debug:
        iterator = tqdm(iterator)

    for phrase in iterator:
        ac.store(phrase)
