import configparser
import json
import os
import psycopg2
import psycopg2.extras
import random
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
config.read('docker_cfg.ini')

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
        flash(err, 'danger')
    return redirect(url_for('database_edit', name=db_name))

@app.route('/tasks')
def tasks():
    tasks = load_tasks()
    return render_template('tasks.html', tasks=tasks, path=request.path)

@app.route('/tasks/new', methods=['GET', 'POST'])
def tasks_new():
    if request.method == 'POST':
        tsq_level = request.form.get('tsq_level')

        db_name = request.form.get('db_name')
        nlq = request.form.get('nlq')
        nlq_with_literals = request.form.get('nlq_with_literals')
        literals = json.loads(request.form.get('literals'))

        literals_proto = ProtoLiteralList()
        for literal in literals:
            literal_proto = literals_proto.text_lits.add()
            for col_id in literal['col_id'].split(','):
                literal_proto.col_id.append(int(col_id))
            literal_proto.value = literal['value']

        nlq_tokens = nlq.split(' ')
        for tok in nlq_tokens:
            if is_number(tok):
                literals_proto.num_lits.append(tok)

        literals_proto = literals_proto.SerializeToString()

        if tsq_level != 'nlq_only':
            tsq = TableSketchQuery(int(request.form.get('num_cols')),
                order='order' in request.form,
                limit=int(request.form.get('limit')) or None)
            tsq.types = json.loads(request.form.get('types'))
            tsq.values = json.loads(request.form.get('values'))
            tid, status = add_task(db_name, nlq, literals_proto,
                nlq_with_literals, tsq=tsq)
        else:
            tid, status = add_task(db_name, nlq, literals_proto,
                nlq_with_literals)
        if status:
            return redirect(url_for('task', tid=tid))
        else:
            flash('Starting task failed.', 'danger')
            return redirect(url_for('tasks_new'))
    else:
        databases = load_databases()
        return render_template('tasks_new.html', databases=databases,
            tsq_level=request.args.get('tsq_level', default='default'),
            path=request.path, factbank=load_factbank())

@app.route('/tasks/<tid>')
def task(tid):
    try:
        task = load_task(tid)
        if not task:
            return redirect(url_for('tasks'))
    except Exception as e:
        flash(str(e), 'danger')
        return redirect(url_for('tasks'))

    databases = load_databases()

    if 'tsq' in task:
        tsq_level = 'default'
    else:
        tsq_level = 'nlq_only'
    return render_template('task.html', task=task, tsq_level=tsq_level,
        databases=databases, path=request.path, factbank=load_factbank())

@app.route('/tasks/<tid>/stop')
def task_stop(tid):
    stop_task(tid)
    return json.dumps({ 'success': True })

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

@app.route('/results/<rid>/view')
def result_view(rid):
    return json.dumps(result_query_view(rid))

@app.route('/results/<rid>/preview')
def result_preview(rid):
    return json.dumps(result_query_view(rid, limit=30))

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
    conn = connect_task_db()
    cur = conn.cursor()
    cur.execute('SELECT schema_proto, path FROM databases WHERE name = %s',
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

def connect_task_db():
    return psycopg2.connect(database=config['db']['name'],
            user=config['db']['user'],
            password=config['db']['password'],
            host=config['db']['host'],
            port=config['db']['port'])

def load_tasks():
    conn = connect_task_db()
    conn = psycopg2.connect(database=config['db']['name'],
            user=config['db']['user'],
            password=config['db']['password'],
            host=config['db']['host'],
            port=config['db']['port'])
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cur.execute('''SELECT tid, db, nlq, status, error_msg, tsq_proto FROM tasks
                   ORDER BY time ASC''')
    tasks = cur.fetchall()
    conn.close()
    return tasks

def load_databases():
    conn = connect_task_db()
    cur = conn.cursor(cursor_factory=psycopg2.extras.DictCursor)
    cur.execute('SELECT name, path FROM databases ORDER BY name')
    databases = cur.fetchall()
    conn.close()
    return databases

def load_task(tid):
    conn = connect_task_db()
    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    cur.execute('''SELECT tid, db, nlq, tsq_proto, nlq_with_literals, status,
                   error_msg FROM tasks WHERE tid = %s''', (tid,))
    task = cur.fetchone()

    if not task:
        return None

    if task['tsq_proto']:
        task['tsq'] = TableSketchQuery.from_proto(task['tsq_proto'])
    conn.close()
    return task

def load_results(tid, offset):
    conn = connect_task_db()
    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    cur.execute('SELECT status FROM tasks t WHERE t.tid = %s', (tid,))
    status = cur.fetchone()['status']

    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    cur.execute('''SELECT rid, query FROM results r
                   WHERE tid = %s AND rid > %s ORDER BY rid ASC LIMIT 20''',
                   (tid, offset))
    results = cur.fetchall()

    output = { 'results': results, 'status': status }
    conn.close()
    return output

def result_query_view(rid, limit=None):
    conn = connect_task_db()
    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    cur.execute('''SELECT d.path, r.query FROM results r
                     JOIN tasks t ON r.tid = t.tid
                     JOIN databases d ON t.db = d.name
                   WHERE rid = %s''', (rid,))
    query_info = cur.fetchone()
    conn.close()

    db_conn = sqlite3.connect(query_info['path'])
    cur = db_conn.cursor()

    query = query_info['query']
    if limit and 'LIMIT' not in query:
        query += f' LIMIT {limit}'

    cur.execute(query)
    results = cur.fetchall()

    output = { 'results': results,
        'header': list(map(lambda x: x[0], cur.description)) }
    db_conn.close()
    return output

def add_task(db_name, nlq, literals_proto, nlq_with_literals, tsq=None):
    conn = connect_task_db()
    cur = conn.cursor()

    tid = str(uuid.uuid4())
    try:
        if tsq:
            tsq_proto = tsq.to_proto().SerializeToString()
            cur.execute('''INSERT INTO tasks (tid, db, nlq, tsq_proto,
                           literals_proto, nlq_with_literals, status, time)
                           VALUES (%s, %s, %s, %s, %s, %s, %s, %s)''',
                           (tid, db_name, nlq, tsq_proto, literals_proto,
                            nlq_with_literals, 'waiting', int(time.time())))
        else:
            cur.execute('''INSERT INTO tasks (tid, db, nlq,
                           literals_proto, nlq_with_literals, status, time)
                           VALUES (%s, %s, %s, %s, %s, %s, %s)''',
                           (tid, db_name, nlq, literals_proto,
                            nlq_with_literals, 'waiting', int(time.time())))
    except Exception as e:
        traceback.print_exc()
        return None, False

    conn.commit()
    conn.close()

    return tid, True

def delete_task(tid):
    conn = connect_task_db()
    cur = conn.cursor()
    cur.execute('DELETE FROM results WHERE tid = %s', (tid,))
    cur.execute('DELETE FROM tasks WHERE tid = %s', (tid,))

    conn.commit()
    conn.close()

def stop_task(tid):
    conn = psycopg2.connect(database=config['db']['name'],
            user=config['db']['user'],
            password=config['db']['password'],
            host=config['db']['host'],
            port=config['db']['port'])

    cur = conn.cursor()
    cur.execute('UPDATE tasks SET status = %s WHERE tid = %s',
        ('done', tid))

    conn.commit()
    conn.close()

def rerun_task(tid):
    conn = psycopg2.connect(database=config['db']['name'],
            user=config['db']['user'],
            password=config['db']['password'],
            host=config['db']['host'],
            port=config['db']['port'])
    cur = conn.cursor()
    cur.execute('DELETE FROM results WHERE tid = %s', (tid,))
    cur.execute('UPDATE tasks SET status = %s, error_msg = %s WHERE tid = %s',
        ('waiting', None, tid))

    conn.commit()
    conn.close()

def load_database(name):
    conn = psycopg2.connect(database=config['db']['name'],
            user=config['db']['user'],
            password=config['db']['password'],
            host=config['db']['host'],
            port=config['db']['port'])
    cur = conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor)
    cur.execute('''SELECT name, schema_proto, path FROM databases
                   WHERE name = %s''', (name,))
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
        conn = connect_task_db()
        cur = conn.cursor()
        cur.execute('''SELECT schema_proto FROM databases
                       WHERE name = %s''', (name,))
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
        cur.execute('UPDATE databases SET schema_proto = %s WHERE name = %s',
                    (schema_proto, name))
        conn.commit()
    except Exception as e:
        return False, str(e)
    return True, None

def delete_database(db_name):
    try:
        conn = connect_task_db()
        cur = conn.cursor()
        cur.execute('SELECT tid FROM tasks WHERE db = %s', (db_name,))
        for tid in cur.fetchall():
            cur.execute('DELETE FROM results WHERE tid = %s', (tid,))
            cur.execute('DELETE FROM tasks WHERE tid = %s', (tid,))

        cur.execute('SELECT path FROM databases WHERE name = %s', (db_name,))
        row = cur.fetchone()

        if row and os.path.exists(row[0]):
            os.remove(row[0])

        cur.execute('DELETE FROM databases WHERE name = %s', (db_name,))

        redis.delete(db_name)

        conn.commit()
        conn.close()
    except Exception as e:
        return False, str(e)
    return True, None

def database_exists(db_name):
    conn = connect_task_db()
    cur = conn.cursor()
    cur.execute('SELECT name FROM databases WHERE name = %s LIMIT 1', (db_name,))

    if cur.fetchone():
        return True
    else:
        return False

def add_new_database(db_name, db_path):
    schema = Schema.from_db_path(db_name, db_path)
    schema_proto_str = schema.to_proto().SerializeToString()

    init_autocomplete(schema, db_path, redis)

    conn = connect_task_db()
    cur = conn.cursor()
    cur.execute('''INSERT INTO databases (name, schema_proto, path)
                   VALUES (%s, %s, %s)''', (db_name, schema_proto_str, db_path))
    conn.commit()
    return True

def load_factbank():
    factbank = json.load(open('factbank.json'))
    for task, facts in factbank.items():
        random.shuffle(facts)
    return factbank

def is_number(val):
    try:
        float(val)
        return True
    except Exception as e:
        return False
