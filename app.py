import configparser
import json
import os
import sqlite3
import time
import traceback
import uuid

from redis import Redis

from duoquest.autocomplete import init_autocomplete
from duoquest.proto.duoquest_pb2 import ProtoLiteralList
from duoquest.schema import Schema
from duoquest.tsq import TableSketchQuery

from flask import Flask, flash, redirect, render_template, request, url_for
from werkzeug.utils import secure_filename

app = Flask(__name__)
app.secret_key = 'supersupersecretkey'
dir_path = os.path.dirname(os.path.realpath(__file__))
app.config['UPLOAD_FOLDER'] = os.path.join(dir_path, 'uploads')

config = configparser.ConfigParser()
config.read('config.ini')

redis = Redis(host=config['redis']['host'], port=config['redis']['port'], db=0)

# ------------
# USER ROUTES
# ------------
@app.route('/')
def home():
    return render_template('index.html', path=request.path)

@app.route('/databases')
def databases():
    databases = load_databases()
    return render_template('databases.html', databases=databases,
        path=request.path)

@app.route('/databases/<name>/edit')
def database_edit(name):
    database = load_database(name)

    ac_tokens = map(lambda x: x.decode(), redis.zrange(name, 0, 99))

    return render_template('database_edit.html', db=database,
        ac_tokens=ac_tokens, path=request.path)

@app.route('/databases/<name>/edit', methods=['POST'])
def database_edit_fkpk(name):
    fkpks = json.loads(request.form.get('fkpks'))
    success, err = edit_database_fkpks(name, fkpks)
    if success:
        flash(f'Foreign keys updated for <{name}> successfully', 'success')
    else:
        flash(err, 'danger')
    return redirect(url_for('database_edit', name=name))

@app.route('/databases/<name>/delete')
def database_delete(name):
    success, err = delete_database(name)
    if success:
        flash(f'Deleted <{name}> successfully', 'success')
    else:
        flash(err, 'danger')
    return redirect(url_for('databases'))

@app.route('/databases/new', methods=['POST'])
def databases_new():
    if 'db_file' not in request.files:
        flash('No db_file in form.', 'danger')
        return redirect(url_for('databases'))
    file = request.files['db_file']

    if not file or file.filename == '':
        flash('No selected file.', 'danger')
        return redirect(url_for('databases'))

    orig_db_name = request.form.get('db_name')
    db_name = orig_db_name
    i = 1
    while database_exists(db_name):
        db_name = f'{orig_db_name}_{i}'
        i += 1

    filename = secure_filename(f'{db_name}.sqlite')
    filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    i = 1
    while os.path.exists(filepath):
        filename = secure_filename(f'{db_name}_{i}.sqlite')
        filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
        i += 1

    file.save(filepath)

    add_new_database(db_name, filepath)
    flash(f'Added new database <{db_name}>. Make sure to EDIT it to set FK-PK relationships!', 'success')

    return redirect(url_for('databases'))

@app.route('/databases/<db_name>/autocomplete')
def database_autocomplete(db_name):
    return json.dumps(autocomplete(db_name, request.args.get('term')))

@app.route('/databases/<db_name>/reset_autocomplete')
def database_reset_autocomplete(db_name):
    success, err = reset_autocomplete(db_name)
    if success:
        flash('Successfully reset autocomplete.', 'success')
    else:
        flash(err, 'error')
    return redirect(url_for('database_edit', name=db_name))

@app.route('/tasks')
def tasks():
    tasks = load_tasks()
    return render_template('tasks.html', tasks=tasks, path=request.path)

@app.route('/tasks/new', methods=['GET', 'POST'])
def tasks_new():
    if request.method == 'POST':
        db_name = request.form.get('db_name')
        nlq = request.form.get('nlq')
        nlq_with_literals = request.form.get('nlq_with_literals')
        literals = json.loads(request.form.get('literals'))
        literals_proto = ProtoLiteralList()
        for literal in literals:
            literal_proto = literals_proto.lits.add()
            literal_proto.col_id = int(literal['col_id'])
            literal_proto.value = literal['value']
        literals_proto = literals_proto.SerializeToString()
        tsq = TableSketchQuery(int(request.form.get('num_cols')),
            order='order' in request.form,
            limit=int(request.form.get('limit')) or None)
        tsq.types = json.loads(request.form.get('types'))
        tsq.values = json.loads(request.form.get('values'))
        tid, status = add_task(db_name, nlq, tsq, literals_proto,
            nlq_with_literals)

        if status:
            return redirect(url_for('task', tid=tid))
        else:
            flash('Starting task failed.', 'danger')
            return redirect(url_for('tasks_new'))
    else:
        databases = load_databases()
        return render_template('tasks_new.html', databases=databases,
            path=request.path)

@app.route('/tasks/<tid>')
def task(tid):
    task = load_task(tid)
    if not task:
        return redirect(url_for('tasks'))
    databases = load_databases()
    return render_template('task.html', task=task, databases=databases,
        path=request.path)

@app.route('/tasks/<tid>/rerun')
def task_rerun(tid):
    rerun_task(tid)
    return json.dumps({ 'success': True })

@app.route('/tasks/<tid>/delete')
def task_delete(tid):
    delete_task(tid)
    return json.dumps({ 'success': True })

@app.route('/tasks/<tid>/results')
def task_results(tid):
    return json.dumps(load_results(tid, request.args.get('offset', default=0)))

@app.route('/results/<rid>/preview')
def result_run(rid):
    return json.dumps(result_query_preview(rid))

def dict_factory(cursor, row):
    d = {}
    for idx, col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d

def autocomplete(db_name, term):
    return list(
        map(lambda x: { 'value': x[1], 'data-col-id': x[2] },
        map(lambda x: x.decode().split('\t'),
        redis.zrangebylex(db_name, f'[{term.lower()}',
            f'[{term.lower()}\xff', start=0, num=10))))

def reset_autocomplete(db_name):
    conn = sqlite3.connect(config['db']['path'])
    cur = conn.cursor()
    cur.execute('SELECT schema_proto, path FROM databases WHERE name = ?',
        (db_name,))
    row = cur.fetchone()
    if not row:
        conn.close()
        return False, f'Database {db_name} not found'

    schema = Schema.from_proto(row[0])
    db_path = row[1]

    init_autocomplete(schema, db_path, redis)

    conn.close()
    return True, None

def load_tasks():
    conn = sqlite3.connect(config['db']['path'])
    conn.row_factory = sqlite3.Row
    cur = conn.cursor()
    cur.execute('''SELECT tid, db, nlq, status, error_msg FROM tasks
                   ORDER BY time ASC''')
    tasks = cur.fetchall()
    conn.close()
    return tasks

def load_databases():
    conn = sqlite3.connect(config['db']['path'])
    conn.row_factory = sqlite3.Row
    cur = conn.cursor()
    cur.execute('SELECT name, path FROM databases ORDER BY name')
    databases = cur.fetchall()
    conn.close()
    return databases

def load_task(tid):
    conn = sqlite3.connect(config['db']['path'])
    conn.row_factory = dict_factory
    cur = conn.cursor()
    cur.execute('''SELECT tid, db, nlq, tsq_proto, nlq_with_literals, status,
                   error_msg FROM tasks WHERE tid = ?''', (tid,))
    task = cur.fetchone()

    if not task:
        return None

    task['tsq'] = TableSketchQuery.from_proto(task['tsq_proto'])
    conn.close()
    return task

def load_results(tid, offset):
    conn = sqlite3.connect(config['db']['path'])
    conn.row_factory = dict_factory
    cur = conn.cursor()
    cur.execute('SELECT status FROM tasks t WHERE t.tid = ?', (tid,))
    status = cur.fetchone()['status']

    cur = conn.cursor()
    cur.execute('''SELECT rid, query FROM results r
                   WHERE tid = ? AND rid > ? ORDER BY rid ASC''',
                   (tid, offset))
    results = cur.fetchall()

    output = { 'results': results, 'status': status }
    conn.close()
    return output

def result_query_preview(rid):
    conn = sqlite3.connect(config['db']['path'])
    conn.row_factory = dict_factory
    cur = conn.cursor()
    cur.execute('''SELECT d.path, r.query FROM results r
                     JOIN tasks t ON r.tid = t.tid
                     JOIN databases d ON t.db = d.name
                   WHERE rid = ?''', (rid,))
    query_info = cur.fetchone()
    conn.close()

    db_conn = sqlite3.connect(query_info['path'])
    cur = db_conn.cursor()

    query = query_info['query']
    if 'LIMIT' not in query:
        query += ' LIMIT 5'

    cur.execute(query)
    results = cur.fetchall()

    output = { 'results': results,
        'header': list(map(lambda x: x[0], cur.description)) }
    db_conn.close()
    return output

def add_task(db_name, nlq, tsq, literals_proto, nlq_with_literals):
    conn = sqlite3.connect(config['db']['path'])
    cur = conn.cursor()
    tid = str(uuid.uuid4())
    try:
        tsq_proto = tsq.to_proto().SerializeToString()
        cur.execute('''INSERT INTO tasks (tid, db, nlq, tsq_proto,
                       literals_proto, nlq_with_literals, status, time)
                       VALUES (?, ?, ?, ?, ?, ?, ?, ?)''',
                       (tid, db_name, nlq, tsq_proto, literals_proto,
                        nlq_with_literals, 'waiting', int(time.time())))
    except Exception as e:
        traceback.print_exc()
        return None, False

    conn.commit()
    conn.close()

    return tid, True

def delete_task(tid):
    conn = sqlite3.connect(config['db']['path'])
    cur = conn.cursor()
    cur.execute('DELETE FROM results WHERE tid = ?', (tid,))
    cur.execute('DELETE FROM tasks WHERE tid = ?', (tid,))

    conn.commit()
    conn.close()

def rerun_task(tid):
    conn = sqlite3.connect(config['db']['path'])
    cur = conn.cursor()
    cur.execute('DELETE FROM results WHERE tid = ?', (tid,))
    cur.execute('UPDATE tasks SET status = ?, error_msg = ? WHERE tid = ?',
        ('waiting', None, tid))

    conn.commit()
    conn.close()

def load_database(name):
    conn = sqlite3.connect(config['db']['path'])
    conn.row_factory = dict_factory
    cur = conn.cursor()
    cur.execute('''SELECT name, schema_proto, path FROM databases
                   WHERE name = ?''', (name,))
    db = cur.fetchone()

    if not db:
        return None

    db['schema'] = Schema.from_proto(db['schema_proto'])
    db['fkpks'] = []
    for col in db['schema'].columns:
        if col.fk_ref:
            db['fkpks'].append({
                'fk': col.id,
                'pk': col.fk_ref
            })
    conn.close()
    return db

def edit_database_fkpks(name, fkpks):
    try:
        conn = sqlite3.connect(config['db']['path'])
        cur = conn.cursor()
        cur.execute('''SELECT schema_proto FROM databases
                       WHERE name = ?''', (name,))
        row = cur.fetchone()
        if not row:
            raise Exception(f'Database {name} does not exist')

        schema = Schema.from_proto(row[0])
        print(fkpks)
        for fkpk in fkpks:
            fk, pk = fkpk
            schema.columns[fk].fk_ref = pk

        schema_proto = schema.to_proto().SerializeToString()
        cur = conn.cursor()
        cur.execute('UPDATE databases SET schema_proto = ? WHERE name = ?',
                    (schema_proto, name))
        conn.commit()
    except Exception as e:
        return False, str(e)
    return True, None

def delete_database(db_name):
    try:
        conn = sqlite3.connect(config['db']['path'])
        cur = conn.cursor()
        cur.execute('SELECT tid FROM tasks WHERE db = ?', (db_name,))
        for tid in cur.fetchall():
            cur.execute('DELETE FROM results WHERE tid = ?', (tid,))
            cur.execute('DELETE FROM tasks WHERE tid = ?', (tid,))

        cur.execute('SELECT path FROM databases WHERE name = ?', (db_name,))
        row = cur.fetchone()
        if row and os.path.exists(row[0]):
            os.remove(row[0])

        cur.execute('DELETE FROM databases WHERE name = ?', (db_name,))

        redis.delete(db_name)

        conn.commit()
        conn.close()
    except Exception as e:
        return False, str(e)
    return True, None

def database_exists(db_name):
    conn = sqlite3.connect(config['db']['path'])
    cur = conn.cursor()
    cur.execute('SELECT name FROM databases WHERE name = ? LIMIT 1', (db_name,))

    if cur.fetchone():
        return True
    else:
        return False

def add_new_database(db_name, db_path):
    schema = Schema.from_db_path(db_name, db_path)
    schema_proto_str = schema.to_proto().SerializeToString()

    init_autocomplete(schema, db_path, redis)

    conn = sqlite3.connect(config['db']['path'])
    cur = conn.cursor()
    cur.execute('''INSERT INTO databases (name, schema_proto, path)
                   VALUES (?, ?, ?)''', (db_name, schema_proto_str, db_path))
    conn.commit()
    return True
