import configparser
import json
import sqlite3
import time
import traceback
import uuid

from duoquest.tsq import TableSketchQuery

from flask import Flask, redirect, render_template, request, url_for
app = Flask(__name__)

config = configparser.ConfigParser()
config.read('config.ini')

# ------------
# USER ROUTES
# ------------
@app.route('/')
def home():
    return render_template('index.html', path=request.path)

@app.route('/start', methods=['GET', 'POST'])
def start():
    if request.method == 'POST':
        print(request.form)
        db_name = request.form.get('db_name')
        nlq = request.form.get('nlq')
        tsq = TableSketchQuery(int(request.form.get('num_cols')),
            order='order' in request.form,
            limit=int(request.form.get('limit')) or None)
        tsq.types = json.loads(request.form.get('types'))
        tsq.values = json.loads(request.form.get('values'))

        tid, status = add_task(db_name, nlq, tsq)

        if status:
            return redirect(url_for('task', tid=tid))
        else:
            databases = load_databases()
            return render_template('start.html', databases=databases,
                path=request.path, error='Starting task failed.')
    else:
        databases = load_databases()
        return render_template('start.html', databases=databases,
            path=request.path)

@app.route('/tasks')
def tasks():
    tasks = load_tasks()
    return render_template('tasks.html', tasks=tasks, path=request.path)

@app.route('/tasks/<tid>')
def task(tid):
    task = load_task(tid)
    if not task:
        return redirect(url_for('tasks'))
    return render_template('task.html', task=task, path=request.path)

@app.route('/tasks/<tid>/results')
def task_results(tid):
    return json.dumps(load_results(tid, request.args.get('offset', default=0)))

def dict_factory(cursor, row):
    d = {}
    for idx, col in enumerate(cursor.description):
        d[col[0]] = row[idx]
    return d

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
    cur.execute('SELECT name FROM databases ORDER BY name')
    databases = cur.fetchall()
    conn.close()
    return databases

def load_task(tid):
    conn = sqlite3.connect(config['db']['path'])
    conn.row_factory = dict_factory
    cur = conn.cursor()
    cur.execute('''SELECT tid, db, nlq, tsq_proto, status, error_msg FROM tasks
                   WHERE tid = ?''', (tid,))
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

def add_task(db_name, nlq, tsq):
    conn = sqlite3.connect(config['db']['path'])
    cur = conn.cursor()
    tid = str(uuid.uuid4())
    try:
        tsq_proto = tsq.to_proto().SerializeToString()
        cur.execute('''INSERT INTO tasks (tid, db, nlq, tsq_proto, status, time)
                       VALUES (?, ?, ?, ?, ?, ?)''',
                       (tid, db_name, nlq, tsq_proto, 'waiting',
                        int(time.time())))
    except Exception as e:
        traceback.print_exc()
        return None, False

    conn.commit()
    conn.close()

    return tid, True
