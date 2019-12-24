CREATE TABLE tasks
    (tid text, db text, nlq text, nlq_with_literals text,
    tsq_proto bytea, literals_proto bytea, status text, time int,
    error_msg text);
CREATE TABLE databases
    (type text, port int, host text, username text, password text,
    name text, path text, schema_proto bytea);
CREATE TABLE results
    (rid SERIAL PRIMARY KEY, tid text, query text);
