import sqlite3

def is_number(val):
    try:
        float(val)
        return True
    except Exception as e:
        return False

def init_autocomplete(schema, db_path, walrus):
    ac = walrus.autocomplete(namespace=schema.db_id)
    ac.flush()

    conn = sqlite3.connect(db_path)
    conn.text_factory = bytes

    phrases = set()
    for col in schema.columns:
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

    for phrase in phrases:
        ac.store(phrase)
