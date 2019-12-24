import sqlite3
from queue import Queue

from .proto.duoquest_pb2 import ProtoColumn, ProtoFKPK, ProtoSchema, \
    ProtoTable, COL_TEXT, COL_NUMBER, COL_TIME, COL_BOOLEAN

def proto_col_type_to_text(proto_col_type):
    if proto_col_type == COL_TEXT:
        return 'text'
    elif proto_col_type == COL_NUMBER:
        return 'number'
    elif proto_col_type == COL_TIME:
        return 'time'
    elif proto_col_type == COL_BOOLEAN:
        return 'boolean'
    else:
        raise Exception(f'Unrecognized type: {proto_col_type}')

def sqlite3_type_to_text(sqlite3_type):
    if sqlite3_type in ('text', 'blob') or sqlite3_type.startswith('varchar'):
        return 'text'
    elif sqlite3_type in ('integer', 'int', 'real'):
        return 'number'
    elif sqlite3_type in ('bool', 'boolean'):
        return 'boolean'
    else:
        raise Exception(f'Unrecognized type: {sqlite3_type}')

def text_to_proto_col_type(type):
    if type == 'text':
        return COL_TEXT
    elif type == 'number':
        return COL_NUMBER
    elif type == 'time':
        return COL_TIME
    elif type == 'others':
        return COL_TEXT
    elif type == 'boolean':
        return COL_BOOLEAN
    else:
        raise Exception(f'Unrecognized type: {type}')

class FromClause(object):
    def __init__(self, aliases, clause, distinct=False):
        self.aliases = aliases
        self.clause = clause
        self.distinct = distinct

class JoinPath(object):
    def __init__(self):
        # If SELECT should be distinct
        self.distinct = False

        self.edges = list()

        # table -> [ join edges ]
        self.edge_map = {}

    def add_single_table(self, table):
        if table not in self.edge_map:
            self.edge_map[table] = []

    def gen_alias(self, alias_idx, set_op=None):
        if set_op:
            return '{}t{}'.format(set_op[0], alias_idx)
        else:
            return 't{}'.format(alias_idx)

    def get_from_clause(self, set_op=None):
        aliases = {}
        join_exprs = ['FROM']

        # start with first alphabetical table
        tables = self.edge_map.keys()
        tbl = min(tables, key=lambda x: x.syn_name)
        alias = self.gen_alias(len(aliases) + 1, set_op=set_op)
        aliases[tbl.syn_name] = alias
        join_exprs.append('{} AS {}'.format(tbl.syn_name, alias))

        stack = [tbl]

        while stack:
            tbl = stack.pop()
            for edge in self.edge_map[tbl]:
                other_tbl = edge.other(tbl)
                if other_tbl.syn_name in aliases:
                    continue

                alias = self.gen_alias(len(aliases) + 1, set_op=set_op)
                aliases[other_tbl.syn_name] = alias
                join_exprs.append(
                    'JOIN {} AS {} ON {}.{} = {}.{}'.format(
                        other_tbl.syn_name, alias,
                        aliases[tbl.syn_name], edge.key(tbl).syn_name,
                        aliases[other_tbl.syn_name], edge.key(other_tbl).syn_name
                    )
                )
                stack.append(other_tbl)

        return aliases, ' '.join(join_exprs)

    def __len__(self):
        return len(self.edges)

    def copy(self):
        new_jp = JoinPath()
        for table, edge_list in self.edge_map.items():
            new_jp.edge_map[table] = list(edge_list)
        new_jp.edges = list(self.edges)
        return new_jp

    def add_edge(self, edge):
        # base case
        fk_table = edge.fk_col.table
        pk_table = edge.pk_col.table

        if len(self.edge_map) == 0:
            self.edge_map[fk_table] = [edge]
            self.edge_map[pk_table] = [edge]
            self.edges.append(edge)
        else:
            # TODO: prevent f -> p <- f join paths
            if fk_table in self.edge_map and pk_table in self.edge_map:
                raise Exception('Cannot generate cycle in JoinPath.')
            elif fk_table in self.edge_map:
                self.edge_map[fk_table].append(edge)
                self.edge_map[pk_table] = [edge]
                self.edges.append(edge)
            elif pk_table in self.edge_map:
                self.edge_map[pk_table].append(edge)
                self.edge_map[fk_table] = [edge]
                self.edges.append(edge)
            else:
                raise Exception('Edge does not link with existing JoinPath.')

    def merge(self, other):
        edges_left = list(other.edges)
        while edges_left:
            edge = edges_left.pop(0)
            if edge not in self.edges:
                try:
                    self.add_edge(edge)
                except Exception:
                    edges_left.append(edge)

class JoinEdge(object):
    def __init__(self, fk_col, pk_col):
        self.fk_col = fk_col
        self.pk_col = pk_col

    def key(self, tbl):
        if self.fk_col.table == tbl:
            return self.fk_col
        elif self.pk_col.table == tbl:
            return self.pk_col
        else:
            raise Exception('Table <{}> not in this JoinEdge.'.format(tbl.syn_name))

    def other(self, tbl):
        if self.fk_col.table == tbl:
            return self.pk_col.table
        elif self.pk_col.table == tbl:
            return self.fk_col.table
        else:
            raise Exception('Table <{}> not in this JoinEdge.'.format(tbl.syn_name))

    def __str__(self):
        return '{} -> {}'.format(str(self.fk_col), str(self.pk_col))

    def __hash__(self):
        return hash((self.fk_col, self.pk_col))

class Table(object):
    def __init__(self, tbl_id, sem_name, syn_name):
        self.id = tbl_id
        self.sem_name = sem_name
        self.syn_name = syn_name
        self.columns = []

        self.fk_edges = []
        self.pk_edges = []

    def num_cols(self):
        return len(self.columns)

    def add_col(self, col):
        self.columns.append(col)

    def add_fk_edge(self, fk_edge):
        self.fk_edges.append(fk_edge)

    def add_pk_edge(self, pk_edge):
        self.pk_edges.append(pk_edge)

    def __hash__(self):
        return hash((self.id, self.sem_name))

    def __str__(self):
        return self.sem_name

class Column(object):
    def __init__(self, col_id, table, col_type, sem_name, syn_name, pk=False,
        fk=False, fk_ref=None):
        self.id = col_id
        self.table = table
        self.type = col_type
        self.sem_name = sem_name
        self.syn_name = syn_name
        self.pk = pk
        self.fk = fk
        self.fk_ref = fk_ref   # id of PK referred to if this is FK

    def set_fk(self, fk):
        self.fk = fk

    def set_fk_ref(self, fk_ref):
        self.fk = True
        self.fk_ref = fk_ref

    def __str__(self):
        if self.syn_name == '*':
            return '*'
        else:
            return '{}.{}'.format(self.table.sem_name, self.sem_name)

    def __hash__(self):
        return hash((self.id, self.table, self.sem_name))

class JoinPathException(Exception):
    pass

class Schema(object):
    def __init__(self, schema_info=None):
        if schema_info:
            self.from_schema_info(schema_info)

    def from_schema_info(self, schema_info):
        self.db_id = schema_info['db_id']
        self.tables = []
        self.columns = []

        tbl_syn_names = schema_info['table_names_original']
        tbl_sem_names = schema_info['table_names']

        for i, sem_name in enumerate(tbl_sem_names):
            tbl = Table(i, sem_name, tbl_syn_names[i])
            self.tables.append(tbl)

        col_syn_names = schema_info['column_names_original']
        col_sem_names = schema_info['column_names']

        for i, col_info in enumerate(col_sem_names):
            tbl_id, sem_name = col_info
            syn_name = col_syn_names[i][1]
            col_type = schema_info['column_types'][i]
            pk = i in schema_info['primary_keys']

            if syn_name == '*':
                col = Column(i, None, col_type, 'all', syn_name, pk=pk)
            else:
                tbl = self.get_table(tbl_id)
                col = Column(i, tbl, col_type, sem_name, syn_name, pk=pk)
                tbl.add_col(col)
            self.columns.append(col)

        for fk, pk in schema_info['foreign_keys']:
            fk_col = self.get_col(fk)
            fk_col.set_fk_ref(pk)
            pk_col = self.get_col(pk)

            edge = JoinEdge(fk_col, pk_col)
            fk_col.table.add_fk_edge(edge)
            pk_col.table.add_pk_edge(edge)

    def to_proto(self):
        schema_proto = ProtoSchema()
        schema_proto.name = self.db_id

        for table_id, table in enumerate(self.tables):
            table_proto = schema_proto.tables.add()
            table_proto.id = table_id
            table_proto.syn_name = table.syn_name
            table_proto.sem_name = table.sem_name

            for col in table.columns:
                col_proto = table_proto.columns.add()
                col_proto.id = col.id
                col_proto.is_pk = col.pk
                col_proto.syn_name = col.syn_name
                col_proto.sem_name = col.sem_name
                col_proto.type = text_to_proto_col_type(col.type)

                if col.fk_ref:
                    fkpk = schema_proto.fkpks.add()
                    fkpk.fk_col_id = col.id
                    fkpk.pk_col_id = col.fk_ref

        return schema_proto

    @staticmethod
    def from_sqlite(db_name, db_path):
        schema = Schema()
        schema.db_id = db_name
        schema.tables = []
        schema.columns = []

        # '*' column
        schema.columns.append(Column(0, None, 'all', 'all', '*', pk=False))

        conn = sqlite3.connect(db_path)
        cur = conn.cursor()
        cur.execute('''SELECT name FROM sqlite_master WHERE type = ?
                       ORDER BY name''', ('table',))
        for row in cur.fetchall():
            sem_name = row[0].replace('_', ' ').lower()
            table = Table(len(schema.tables), sem_name, row[0])
            schema.tables.append(table)

            col_cur = conn.cursor()
            col_cur.execute(f"PRAGMA TABLE_INFO('{row[0]}')")
            for col_row in col_cur.fetchall():
                syn_name = col_row[1]
                sem_name = syn_name.replace('_', ' ').lower()
                col_type = sqlite3_type_to_text(col_row[2].lower())
                is_pk = bool(col_row[5])
                column = Column(len(schema.columns), table, col_type, sem_name,
                    syn_name, pk=is_pk)
                table.add_col(column)
                schema.columns.append(column)

        for table in schema.tables:
            cur = conn.cursor()
            cur.execute(f'PRAGMA foreign_key_list({table.syn_name})')
            for row in cur.fetchall():
                fk_tbl_name = row[2]
                pk_col_name = row[3]
                fk_col_name = row[4]

                pk_col = schema.find_col_by_syn_name(table.syn_name, pk_col_name)
                fk_col = schema.find_col_by_syn_name(fk_tbl_name, fk_col_name)

                pk_col.fk_ref = fk_col.id

        conn.close()
        return schema

    def find_col_by_syn_name(self, tbl_syn_name, col_syn_name):
        for col in self.columns:
            if not col.table:
                continue

            if col.syn_name.lower() != col_syn_name.lower():
                continue

            if col.table.syn_name.lower() != tbl_syn_name.lower():
                continue

            return col

        return None

    @staticmethod
    def from_proto(schema_proto_str):
        schema_proto = ProtoSchema()
        schema_proto.ParseFromString(schema_proto_str)

        schema = Schema()
        schema.db_id = schema_proto.name
        schema.tables = []
        schema.columns = []

        # '*' column
        schema.columns.append(Column(0, None, 'all', 'all', '*', pk=False))

        for tbl in schema_proto.tables:
            table = Table(tbl.id, tbl.sem_name, tbl.syn_name)
            schema.tables.append(table)

            for col in tbl.columns:
                column = Column(col.id, table, proto_col_type_to_text(col.type),
                    col.sem_name, col.syn_name, pk=col.is_pk)
                table.add_col(column)
                schema.columns.append(column)

        for fkpk in schema_proto.fkpks:
            fk_col = schema.get_col(fkpk.fk_col_id)
            pk_col = schema.get_col(fkpk.pk_col_id)
            fk_col.set_fk_ref(fkpk.pk_col_id)

            edge = JoinEdge(fk_col, pk_col)
            fk_col.table.add_fk_edge(edge)
            pk_col.table.add_pk_edge(edge)

        return schema

    def pk_ids(self):
        ids = []
        for col in self.columns:
            if col.pk:
                ids.append(col.id)
        return ids

    def fk_ids(self):
        ids = []
        for col in self.columns:
            if col.fk:
                ids.append(col.id)
        return ids

    def num_cols(self):
        return len(self.columns)

    def get_table(self, tbl_id):
        return self.tables[tbl_id]

    def get_col(self, col_id):
        return self.columns[col_id]

    def get_shortest_paths(self, tables):
        # frozenset(table1, table2) -> JoinPath
        shortest = {}
        for tbl in tables:
            tbls_left = set(tables)
            tbls_left.remove(tbl)

            to_remove = set()
            for other_tbl in tbls_left:
                if frozenset([tbl, other_tbl]) in shortest:
                    to_remove.add(other_tbl)
            tbls_left -= to_remove

            # perform breadth-first search
            # TODO: change to more efficient shortest path alg if needed
            queue = Queue()
            queue.put((tbl, JoinPath()))
            visited = set()
            visited.add(tbl)

            while not queue.empty():
                if not tbls_left:
                    break

                cur_tbl, jp = queue.get_nowait()
                all_edges = cur_tbl.fk_edges + cur_tbl.pk_edges
                for edge in all_edges:
                    other_tbl = edge.other(cur_tbl)

                    if other_tbl in visited:
                        continue

                    new_jp = jp.copy()
                    new_jp.add_edge(edge)

                    if other_tbl in tbls_left:
                        key = frozenset([tbl, other_tbl])
                        shortest[key] = new_jp
                        tbls_left.remove(other_tbl)

                    queue.put((other_tbl, new_jp))
                    visited.add(other_tbl)

        return shortest

    def steiner(self, tables):
        if len(tables) == 1:
            jp = JoinPath()
            jp.add_single_table(next(iter(tables)))
            return jp

        try:
            # STEP 1: Get shortest paths between each table in col_idxs
            # shortest: frozenset(table1, table2) -> JoinPath
            # TODO: extend to get multiple shortest paths per pair if needed
            shortest = self.get_shortest_paths(tables)

            # STEPS 2-3: Get MST of shortest, replace shortest paths with join edges
            # TODO: extend to get multiple MSTs if needed
            tbls_in = set([next(iter(tables))])

            mst = JoinPath()

            while len(tbls_in) < len(tables):
                min_path_len = 9999
                min_path = None
                min_path_tbl = None
                for tbl in tbls_in:
                    for other_tbl in tables:
                        if other_tbl in tbls_in:
                            continue
                        key = frozenset([tbl, other_tbl])
                        if key not in shortest:
                            raise JoinPathException(
                                'Join path fail ({}) <{}>, <{}>'.format(
                                self.db_id, tbl.syn_name, other_tbl.syn_name
                            ))

                        if len(shortest[key]) < min_path_len:
                            min_path_len = len(shortest[key])
                            min_path = shortest[key]
                            min_path_tbl = other_tbl

                mst.merge(min_path)

                tbls_in.add(min_path_tbl)
        except Exception as e:
            raise JoinPathException()

        # TODO: omitting the following, if most cases are handled anyway
        # STEP 4: Find minimal spanning tree of `mst`
        # STEP 5: Delete edges so that all leaves are Steiner points

        return mst

    def get_join_paths(self, tables, minimal_join_paths=False):
        if len(tables) == 0:
            # when there's 0 tables (due to * being the only column),
            #   generate join path for each table in the schema
            return self.zero_table_join_paths()
        else:
            jps = []

            # first, get the default shortest join path
            if len(tables) == 1:
                jp = JoinPath()
                jp.add_single_table(table)
                jps.append(jp)
            else:
                jp = self.steiner(tables)
                jps.append(jp)

            # get alternative extensions with FK 2 layers deep
            if not minimal_join_paths:
                for table in tables:
                    if len(table.pk_edges) > 0:
                        for edge in table.pk_edges:
                            other_tbl = edge.other(table)
                            new_tables = list(tables)
                            new_tables.append(other_tbl)
                            jp = self.steiner(new_tables)
                            jp.distinct = True
                            jps.append(jp)

                            if len(other_tbl.pk_edges) > 0:
                                for edge in other_tbl.pk_edges:
                                    other2_tbl = edge.other(other_tbl)
                                    if other2_tbl not in tables:
                                        newer_tables = list(new_tables)
                                        newer_tables.append(other2_tbl)
                                        jp = self.steiner(newer_tables)
                                        jp.distinct = True
                                        jps.append(jp)
            return jps


    def zero_table_join_paths(self):
        jps = []
        for tbl in self.tables:
            jp = JoinPath()
            jp.add_single_table(tbl)
            jps.append(jp)
        return jps

    # def single_table_join_paths(self, table):
    #     join_paths = []
    #
    #     # Case 1: only use single table
    #     # jp = JoinPath()
    #     # jp.add_single_table(table)
    #     # join_paths.append(jp)
    #
    #     # Case 2: join with other table and count distinct ones
    #     if len(table.pk_edges) > 0:
    #         for edge in table.pk_edges:
    #             other_tbl = edge.other(table)
    #
    #             jp = self.steiner([table, other_tbl])
    #             jp.distinct = True
    #             join_paths.append(jp)
    #
    #             if len(other_tbl.pk_edges) > 0:
    #                 for edge in other_tbl.pk_edges:
    #                     other2_tbl = edge.other(other_tbl)
    #
    #                     if other2_tbl != table:
    #                         jp = self.steiner([table, other_tbl, other2_tbl])
    #                         jp.distinct = True
    #                         join_paths.append(jp)
    #
    #     return join_paths

    def get_aliased_col(self, aliases, col_idx):
        col = self.get_col(col_idx)
        if col.syn_name == '*':
            return '*'

        # change col if it is an fk and primary key is in table set already
        if col.fk:
            fk_ref_table = self.get_col(col.fk_ref).table
            if fk_ref_table.syn_name in aliases and \
                aliases[fk_ref_table.syn_name]:
                col = self.get_col(col.fk_ref)

        if col.table.syn_name in aliases and aliases[col.table.syn_name]:
            return '{}."{}"'.format(aliases[col.table.syn_name],
                col.syn_name)
        else:
            return '"{}"'.format(col.syn_name)
