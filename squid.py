import json
import os
from pprint import pprint
import subprocess

SQUID_DIR = '/Users/cjbaik/dev/squid-public/'
CLASSPATH = '/Users/cjbaik/dev/squid-public/out/production/squid-public/'
LIB_PATH = '/Users/cjbaik/dev/squid-public/lib'

for filename in os.listdir(LIB_PATH):
    if filename.endswith('.jar'):
        CLASSPATH += ':' + os.path.join(LIB_PATH, filename)

db_name = 'smallimdb'
db_user = 'afariha'
db_pw = '123456'
pg_dump_path = '/usr/local/opt/postgresql@9.6/bin/pg_dump'
log_level = 'SEVERE'
rho = '0.1'
eta = '100'
gamma = '1'
tau_a = '0'
tau_s = '0'

pbe_spec = '"forrest gump"\n"cast away"'

output = subprocess.check_output(['java', '-cp', CLASSPATH, 'main.ConsoleMain',
    pbe_spec,
    '--dbName', db_name, '--dbUser', db_user, '--dbPassword', db_pw,
    '--pgDumpPath', pg_dump_path, '--logLvl', log_level,
    '--rho', rho, '--eta', eta, '--gamma', gamma, '--tau_a', tau_a,
    '--tau_s', tau_s, '--disambiguateActive', '--useSkewness'], cwd=SQUID_DIR)

cqs = []
for line in output.decode('utf-8').split('\n'):
    if line:
        cqs.append(json.loads(line))

pprint(cqs)
