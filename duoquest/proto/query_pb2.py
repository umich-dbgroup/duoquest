# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: query.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf.internal import enum_type_wrapper
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()




DESCRIPTOR = _descriptor.FileDescriptor(
  name='query.proto',
  package='',
  syntax='proto3',
  serialized_options=None,
  serialized_pb=_b('\n\x0bquery.proto\".\n\x0eProtoQueryList\x12\x1c\n\x07queries\x18\x01 \x03(\x0b\x32\x0b.ProtoQuery\"(\n\x0bProtoResult\x12\x19\n\x07results\x18\x01 \x03(\x0e\x32\x08.Tribool\"\xd3\x04\n\nProtoQuery\x12\x16\n\x06set_op\x18\x01 \x01(\x0e\x32\x06.SetOp\x12\x1b\n\thas_where\x18\x02 \x01(\x0e\x32\x08.Tribool\x12\x1e\n\x0chas_group_by\x18\x03 \x01(\x0e\x32\x08.Tribool\x12\x1c\n\nhas_having\x18\x04 \x01(\x0e\x32\x08.Tribool\x12\x1e\n\x0chas_order_by\x18\x05 \x01(\x0e\x32\x08.Tribool\x12\x1b\n\thas_limit\x18\x06 \x01(\x0e\x32\x08.Tribool\x12#\n\x0b\x66rom_clause\x18\x07 \x01(\x0b\x32\x0e.ProtoJoinPath\x12!\n\x06select\x18\x08 \x03(\x0b\x32\x11.AggregatedColumn\x12\x1f\n\x05where\x18\t \x01(\x0b\x32\x10.SelectionClause\x12\x10\n\x08group_by\x18\n \x03(\x05\x12 \n\x06having\x18\x0b \x01(\x0b\x32\x10.SelectionClause\x12 \n\x08order_by\x18\x0c \x03(\x0b\x32\x0e.OrderedColumn\x12\r\n\x05limit\x18\r \x01(\x05\x12\x19\n\x04left\x18\x0e \x01(\x0b\x32\x0b.ProtoQuery\x12\x1a\n\x05right\x18\x0f \x01(\x0b\x32\x0b.ProtoQuery\x12\x10\n\x08\x64istinct\x18\x10 \x01(\x08\x12\x13\n\x0b\x64one_select\x18\x11 \x01(\x08\x12\x12\n\ndone_where\x18\x12 \x01(\x08\x12\x15\n\rdone_group_by\x18\x13 \x01(\x08\x12\x13\n\x0b\x64one_having\x18\x14 \x01(\x08\x12\x15\n\rdone_order_by\x18\x15 \x01(\x08\x12\x12\n\ndone_limit\x18\x16 \x01(\x08\"\xa9\x01\n\rProtoJoinPath\x12%\n\tedge_list\x18\x01 \x01(\x0b\x32\x12.ProtoJoinEdgeList\x12-\n\x08\x65\x64ge_map\x18\x02 \x03(\x0b\x32\x1b.ProtoJoinPath.EdgeMapEntry\x1a\x42\n\x0c\x45\x64geMapEntry\x12\x0b\n\x03key\x18\x01 \x01(\x05\x12!\n\x05value\x18\x02 \x01(\x0b\x32\x12.ProtoJoinEdgeList:\x02\x38\x01\"2\n\x11ProtoJoinEdgeList\x12\x1d\n\x05\x65\x64ges\x18\x01 \x03(\x0b\x32\x0e.ProtoJoinEdge\"5\n\rProtoJoinEdge\x12\x11\n\tfk_col_id\x18\x01 \x01(\x05\x12\x11\n\tpk_col_id\x18\x02 \x01(\x05\"V\n\x10\x41ggregatedColumn\x12\x0e\n\x06\x63ol_id\x18\x01 \x01(\x05\x12\x19\n\x07has_agg\x18\x02 \x01(\x0e\x32\x08.Tribool\x12\x17\n\x03\x61gg\x18\x03 \x01(\x0e\x32\n.Aggregate\"Q\n\rOrderedColumn\x12\"\n\x07\x61gg_col\x18\x01 \x01(\x0b\x32\x11.AggregatedColumn\x12\x1c\n\x03\x64ir\x18\x02 \x01(\x0e\x32\x0f.OrderDirection\"Q\n\x0fSelectionClause\x12\x1e\n\npredicates\x18\x01 \x03(\x0b\x32\n.Predicate\x12\x1e\n\nlogical_op\x18\x02 \x01(\x0e\x32\n.LogicalOp\"\xae\x01\n\tPredicate\x12\x0e\n\x06\x63ol_id\x18\x01 \x01(\x05\x12\x0f\n\x02op\x18\x02 \x01(\x0e\x32\x03.Op\x12\x1e\n\x0chas_subquery\x18\x03 \x01(\x0e\x32\x08.Tribool\x12\r\n\x05value\x18\x04 \x03(\t\x12\x1d\n\x08subquery\x18\x05 \x01(\x0b\x32\x0b.ProtoQuery\x12\x19\n\x07has_agg\x18\x06 \x01(\x0e\x32\x08.Tribool\x12\x17\n\x03\x61gg\x18\x07 \x01(\x0e\x32\n.Aggregate*+\n\x07Tribool\x12\x0b\n\x07UNKNOWN\x10\x00\x12\t\n\x05\x46\x41LSE\x10\x01\x12\x08\n\x04TRUE\x10\x02*<\n\x05SetOp\x12\r\n\tNO_SET_OP\x10\x00\x12\r\n\tINTERSECT\x10\x01\x12\n\n\x06\x45XCEPT\x10\x02\x12\t\n\x05UNION\x10\x03*F\n\tAggregate\x12\n\n\x06NO_AGG\x10\x00\x12\x07\n\x03MAX\x10\x01\x12\x07\n\x03MIN\x10\x02\x12\t\n\x05\x43OUNT\x10\x03\x12\x07\n\x03SUM\x10\x04\x12\x07\n\x03\x41VG\x10\x05*\x1c\n\tLogicalOp\x12\x07\n\x03\x41ND\x10\x00\x12\x06\n\x02OR\x10\x01*f\n\x02Op\x12\n\n\x06\x45QUALS\x10\x00\x12\x06\n\x02GT\x10\x01\x12\x06\n\x02LT\x10\x02\x12\x07\n\x03GEQ\x10\x03\x12\x07\n\x03LEQ\x10\x04\x12\x07\n\x03NEQ\x10\x05\x12\x08\n\x04LIKE\x10\x06\x12\x06\n\x02IN\x10\x07\x12\n\n\x06NOT_IN\x10\x08\x12\x0b\n\x07\x42\x45TWEEN\x10\t*#\n\x0eOrderDirection\x12\x07\n\x03\x41SC\x10\x00\x12\x08\n\x04\x44\x45SC\x10\x01\x62\x06proto3')
)

_TRIBOOL = _descriptor.EnumDescriptor(
  name='Tribool',
  full_name='Tribool',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='UNKNOWN', index=0, number=0,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='FALSE', index=1, number=1,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='TRUE', index=2, number=2,
      serialized_options=None,
      type=None),
  ],
  containing_type=None,
  serialized_options=None,
  serialized_start=1413,
  serialized_end=1456,
)
_sym_db.RegisterEnumDescriptor(_TRIBOOL)

Tribool = enum_type_wrapper.EnumTypeWrapper(_TRIBOOL)
_SETOP = _descriptor.EnumDescriptor(
  name='SetOp',
  full_name='SetOp',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='NO_SET_OP', index=0, number=0,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='INTERSECT', index=1, number=1,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='EXCEPT', index=2, number=2,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='UNION', index=3, number=3,
      serialized_options=None,
      type=None),
  ],
  containing_type=None,
  serialized_options=None,
  serialized_start=1458,
  serialized_end=1518,
)
_sym_db.RegisterEnumDescriptor(_SETOP)

SetOp = enum_type_wrapper.EnumTypeWrapper(_SETOP)
_AGGREGATE = _descriptor.EnumDescriptor(
  name='Aggregate',
  full_name='Aggregate',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='NO_AGG', index=0, number=0,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='MAX', index=1, number=1,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='MIN', index=2, number=2,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='COUNT', index=3, number=3,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='SUM', index=4, number=4,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='AVG', index=5, number=5,
      serialized_options=None,
      type=None),
  ],
  containing_type=None,
  serialized_options=None,
  serialized_start=1520,
  serialized_end=1590,
)
_sym_db.RegisterEnumDescriptor(_AGGREGATE)

Aggregate = enum_type_wrapper.EnumTypeWrapper(_AGGREGATE)
_LOGICALOP = _descriptor.EnumDescriptor(
  name='LogicalOp',
  full_name='LogicalOp',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='AND', index=0, number=0,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='OR', index=1, number=1,
      serialized_options=None,
      type=None),
  ],
  containing_type=None,
  serialized_options=None,
  serialized_start=1592,
  serialized_end=1620,
)
_sym_db.RegisterEnumDescriptor(_LOGICALOP)

LogicalOp = enum_type_wrapper.EnumTypeWrapper(_LOGICALOP)
_OP = _descriptor.EnumDescriptor(
  name='Op',
  full_name='Op',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='EQUALS', index=0, number=0,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='GT', index=1, number=1,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='LT', index=2, number=2,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='GEQ', index=3, number=3,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='LEQ', index=4, number=4,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='NEQ', index=5, number=5,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='LIKE', index=6, number=6,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='IN', index=7, number=7,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='NOT_IN', index=8, number=8,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='BETWEEN', index=9, number=9,
      serialized_options=None,
      type=None),
  ],
  containing_type=None,
  serialized_options=None,
  serialized_start=1622,
  serialized_end=1724,
)
_sym_db.RegisterEnumDescriptor(_OP)

Op = enum_type_wrapper.EnumTypeWrapper(_OP)
_ORDERDIRECTION = _descriptor.EnumDescriptor(
  name='OrderDirection',
  full_name='OrderDirection',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='ASC', index=0, number=0,
      serialized_options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='DESC', index=1, number=1,
      serialized_options=None,
      type=None),
  ],
  containing_type=None,
  serialized_options=None,
  serialized_start=1726,
  serialized_end=1761,
)
_sym_db.RegisterEnumDescriptor(_ORDERDIRECTION)

OrderDirection = enum_type_wrapper.EnumTypeWrapper(_ORDERDIRECTION)
UNKNOWN = 0
FALSE = 1
TRUE = 2
NO_SET_OP = 0
INTERSECT = 1
EXCEPT = 2
UNION = 3
NO_AGG = 0
MAX = 1
MIN = 2
COUNT = 3
SUM = 4
AVG = 5
AND = 0
OR = 1
EQUALS = 0
GT = 1
LT = 2
GEQ = 3
LEQ = 4
NEQ = 5
LIKE = 6
IN = 7
NOT_IN = 8
BETWEEN = 9
ASC = 0
DESC = 1



_PROTOQUERYLIST = _descriptor.Descriptor(
  name='ProtoQueryList',
  full_name='ProtoQueryList',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='queries', full_name='ProtoQueryList.queries', index=0,
      number=1, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  serialized_options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=15,
  serialized_end=61,
)


_PROTORESULT = _descriptor.Descriptor(
  name='ProtoResult',
  full_name='ProtoResult',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='results', full_name='ProtoResult.results', index=0,
      number=1, type=14, cpp_type=8, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  serialized_options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=63,
  serialized_end=103,
)


_PROTOQUERY = _descriptor.Descriptor(
  name='ProtoQuery',
  full_name='ProtoQuery',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='set_op', full_name='ProtoQuery.set_op', index=0,
      number=1, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='has_where', full_name='ProtoQuery.has_where', index=1,
      number=2, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='has_group_by', full_name='ProtoQuery.has_group_by', index=2,
      number=3, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='has_having', full_name='ProtoQuery.has_having', index=3,
      number=4, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='has_order_by', full_name='ProtoQuery.has_order_by', index=4,
      number=5, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='has_limit', full_name='ProtoQuery.has_limit', index=5,
      number=6, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='from_clause', full_name='ProtoQuery.from_clause', index=6,
      number=7, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='select', full_name='ProtoQuery.select', index=7,
      number=8, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='where', full_name='ProtoQuery.where', index=8,
      number=9, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='group_by', full_name='ProtoQuery.group_by', index=9,
      number=10, type=5, cpp_type=1, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='having', full_name='ProtoQuery.having', index=10,
      number=11, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='order_by', full_name='ProtoQuery.order_by', index=11,
      number=12, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='limit', full_name='ProtoQuery.limit', index=12,
      number=13, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='left', full_name='ProtoQuery.left', index=13,
      number=14, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='right', full_name='ProtoQuery.right', index=14,
      number=15, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='distinct', full_name='ProtoQuery.distinct', index=15,
      number=16, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='done_select', full_name='ProtoQuery.done_select', index=16,
      number=17, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='done_where', full_name='ProtoQuery.done_where', index=17,
      number=18, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='done_group_by', full_name='ProtoQuery.done_group_by', index=18,
      number=19, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='done_having', full_name='ProtoQuery.done_having', index=19,
      number=20, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='done_order_by', full_name='ProtoQuery.done_order_by', index=20,
      number=21, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='done_limit', full_name='ProtoQuery.done_limit', index=21,
      number=22, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  serialized_options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=106,
  serialized_end=701,
)


_PROTOJOINPATH_EDGEMAPENTRY = _descriptor.Descriptor(
  name='EdgeMapEntry',
  full_name='ProtoJoinPath.EdgeMapEntry',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='key', full_name='ProtoJoinPath.EdgeMapEntry.key', index=0,
      number=1, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='value', full_name='ProtoJoinPath.EdgeMapEntry.value', index=1,
      number=2, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  serialized_options=_b('8\001'),
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=807,
  serialized_end=873,
)

_PROTOJOINPATH = _descriptor.Descriptor(
  name='ProtoJoinPath',
  full_name='ProtoJoinPath',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='edge_list', full_name='ProtoJoinPath.edge_list', index=0,
      number=1, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='edge_map', full_name='ProtoJoinPath.edge_map', index=1,
      number=2, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[_PROTOJOINPATH_EDGEMAPENTRY, ],
  enum_types=[
  ],
  serialized_options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=704,
  serialized_end=873,
)


_PROTOJOINEDGELIST = _descriptor.Descriptor(
  name='ProtoJoinEdgeList',
  full_name='ProtoJoinEdgeList',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='edges', full_name='ProtoJoinEdgeList.edges', index=0,
      number=1, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  serialized_options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=875,
  serialized_end=925,
)


_PROTOJOINEDGE = _descriptor.Descriptor(
  name='ProtoJoinEdge',
  full_name='ProtoJoinEdge',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='fk_col_id', full_name='ProtoJoinEdge.fk_col_id', index=0,
      number=1, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='pk_col_id', full_name='ProtoJoinEdge.pk_col_id', index=1,
      number=2, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  serialized_options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=927,
  serialized_end=980,
)


_AGGREGATEDCOLUMN = _descriptor.Descriptor(
  name='AggregatedColumn',
  full_name='AggregatedColumn',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='col_id', full_name='AggregatedColumn.col_id', index=0,
      number=1, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='has_agg', full_name='AggregatedColumn.has_agg', index=1,
      number=2, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='agg', full_name='AggregatedColumn.agg', index=2,
      number=3, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  serialized_options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=982,
  serialized_end=1068,
)


_ORDEREDCOLUMN = _descriptor.Descriptor(
  name='OrderedColumn',
  full_name='OrderedColumn',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='agg_col', full_name='OrderedColumn.agg_col', index=0,
      number=1, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='dir', full_name='OrderedColumn.dir', index=1,
      number=2, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  serialized_options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=1070,
  serialized_end=1151,
)


_SELECTIONCLAUSE = _descriptor.Descriptor(
  name='SelectionClause',
  full_name='SelectionClause',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='predicates', full_name='SelectionClause.predicates', index=0,
      number=1, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='logical_op', full_name='SelectionClause.logical_op', index=1,
      number=2, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  serialized_options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=1153,
  serialized_end=1234,
)


_PREDICATE = _descriptor.Descriptor(
  name='Predicate',
  full_name='Predicate',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='col_id', full_name='Predicate.col_id', index=0,
      number=1, type=5, cpp_type=1, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='op', full_name='Predicate.op', index=1,
      number=2, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='has_subquery', full_name='Predicate.has_subquery', index=2,
      number=3, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='value', full_name='Predicate.value', index=3,
      number=4, type=9, cpp_type=9, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='subquery', full_name='Predicate.subquery', index=4,
      number=5, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='has_agg', full_name='Predicate.has_agg', index=5,
      number=6, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='agg', full_name='Predicate.agg', index=6,
      number=7, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  serialized_options=None,
  is_extendable=False,
  syntax='proto3',
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=1237,
  serialized_end=1411,
)

_PROTOQUERYLIST.fields_by_name['queries'].message_type = _PROTOQUERY
_PROTORESULT.fields_by_name['results'].enum_type = _TRIBOOL
_PROTOQUERY.fields_by_name['set_op'].enum_type = _SETOP
_PROTOQUERY.fields_by_name['has_where'].enum_type = _TRIBOOL
_PROTOQUERY.fields_by_name['has_group_by'].enum_type = _TRIBOOL
_PROTOQUERY.fields_by_name['has_having'].enum_type = _TRIBOOL
_PROTOQUERY.fields_by_name['has_order_by'].enum_type = _TRIBOOL
_PROTOQUERY.fields_by_name['has_limit'].enum_type = _TRIBOOL
_PROTOQUERY.fields_by_name['from_clause'].message_type = _PROTOJOINPATH
_PROTOQUERY.fields_by_name['select'].message_type = _AGGREGATEDCOLUMN
_PROTOQUERY.fields_by_name['where'].message_type = _SELECTIONCLAUSE
_PROTOQUERY.fields_by_name['having'].message_type = _SELECTIONCLAUSE
_PROTOQUERY.fields_by_name['order_by'].message_type = _ORDEREDCOLUMN
_PROTOQUERY.fields_by_name['left'].message_type = _PROTOQUERY
_PROTOQUERY.fields_by_name['right'].message_type = _PROTOQUERY
_PROTOJOINPATH_EDGEMAPENTRY.fields_by_name['value'].message_type = _PROTOJOINEDGELIST
_PROTOJOINPATH_EDGEMAPENTRY.containing_type = _PROTOJOINPATH
_PROTOJOINPATH.fields_by_name['edge_list'].message_type = _PROTOJOINEDGELIST
_PROTOJOINPATH.fields_by_name['edge_map'].message_type = _PROTOJOINPATH_EDGEMAPENTRY
_PROTOJOINEDGELIST.fields_by_name['edges'].message_type = _PROTOJOINEDGE
_AGGREGATEDCOLUMN.fields_by_name['has_agg'].enum_type = _TRIBOOL
_AGGREGATEDCOLUMN.fields_by_name['agg'].enum_type = _AGGREGATE
_ORDEREDCOLUMN.fields_by_name['agg_col'].message_type = _AGGREGATEDCOLUMN
_ORDEREDCOLUMN.fields_by_name['dir'].enum_type = _ORDERDIRECTION
_SELECTIONCLAUSE.fields_by_name['predicates'].message_type = _PREDICATE
_SELECTIONCLAUSE.fields_by_name['logical_op'].enum_type = _LOGICALOP
_PREDICATE.fields_by_name['op'].enum_type = _OP
_PREDICATE.fields_by_name['has_subquery'].enum_type = _TRIBOOL
_PREDICATE.fields_by_name['subquery'].message_type = _PROTOQUERY
_PREDICATE.fields_by_name['has_agg'].enum_type = _TRIBOOL
_PREDICATE.fields_by_name['agg'].enum_type = _AGGREGATE
DESCRIPTOR.message_types_by_name['ProtoQueryList'] = _PROTOQUERYLIST
DESCRIPTOR.message_types_by_name['ProtoResult'] = _PROTORESULT
DESCRIPTOR.message_types_by_name['ProtoQuery'] = _PROTOQUERY
DESCRIPTOR.message_types_by_name['ProtoJoinPath'] = _PROTOJOINPATH
DESCRIPTOR.message_types_by_name['ProtoJoinEdgeList'] = _PROTOJOINEDGELIST
DESCRIPTOR.message_types_by_name['ProtoJoinEdge'] = _PROTOJOINEDGE
DESCRIPTOR.message_types_by_name['AggregatedColumn'] = _AGGREGATEDCOLUMN
DESCRIPTOR.message_types_by_name['OrderedColumn'] = _ORDEREDCOLUMN
DESCRIPTOR.message_types_by_name['SelectionClause'] = _SELECTIONCLAUSE
DESCRIPTOR.message_types_by_name['Predicate'] = _PREDICATE
DESCRIPTOR.enum_types_by_name['Tribool'] = _TRIBOOL
DESCRIPTOR.enum_types_by_name['SetOp'] = _SETOP
DESCRIPTOR.enum_types_by_name['Aggregate'] = _AGGREGATE
DESCRIPTOR.enum_types_by_name['LogicalOp'] = _LOGICALOP
DESCRIPTOR.enum_types_by_name['Op'] = _OP
DESCRIPTOR.enum_types_by_name['OrderDirection'] = _ORDERDIRECTION
_sym_db.RegisterFileDescriptor(DESCRIPTOR)

ProtoQueryList = _reflection.GeneratedProtocolMessageType('ProtoQueryList', (_message.Message,), dict(
  DESCRIPTOR = _PROTOQUERYLIST,
  __module__ = 'query_pb2'
  # @@protoc_insertion_point(class_scope:ProtoQueryList)
  ))
_sym_db.RegisterMessage(ProtoQueryList)

ProtoResult = _reflection.GeneratedProtocolMessageType('ProtoResult', (_message.Message,), dict(
  DESCRIPTOR = _PROTORESULT,
  __module__ = 'query_pb2'
  # @@protoc_insertion_point(class_scope:ProtoResult)
  ))
_sym_db.RegisterMessage(ProtoResult)

ProtoQuery = _reflection.GeneratedProtocolMessageType('ProtoQuery', (_message.Message,), dict(
  DESCRIPTOR = _PROTOQUERY,
  __module__ = 'query_pb2'
  # @@protoc_insertion_point(class_scope:ProtoQuery)
  ))
_sym_db.RegisterMessage(ProtoQuery)

ProtoJoinPath = _reflection.GeneratedProtocolMessageType('ProtoJoinPath', (_message.Message,), dict(

  EdgeMapEntry = _reflection.GeneratedProtocolMessageType('EdgeMapEntry', (_message.Message,), dict(
    DESCRIPTOR = _PROTOJOINPATH_EDGEMAPENTRY,
    __module__ = 'query_pb2'
    # @@protoc_insertion_point(class_scope:ProtoJoinPath.EdgeMapEntry)
    ))
  ,
  DESCRIPTOR = _PROTOJOINPATH,
  __module__ = 'query_pb2'
  # @@protoc_insertion_point(class_scope:ProtoJoinPath)
  ))
_sym_db.RegisterMessage(ProtoJoinPath)
_sym_db.RegisterMessage(ProtoJoinPath.EdgeMapEntry)

ProtoJoinEdgeList = _reflection.GeneratedProtocolMessageType('ProtoJoinEdgeList', (_message.Message,), dict(
  DESCRIPTOR = _PROTOJOINEDGELIST,
  __module__ = 'query_pb2'
  # @@protoc_insertion_point(class_scope:ProtoJoinEdgeList)
  ))
_sym_db.RegisterMessage(ProtoJoinEdgeList)

ProtoJoinEdge = _reflection.GeneratedProtocolMessageType('ProtoJoinEdge', (_message.Message,), dict(
  DESCRIPTOR = _PROTOJOINEDGE,
  __module__ = 'query_pb2'
  # @@protoc_insertion_point(class_scope:ProtoJoinEdge)
  ))
_sym_db.RegisterMessage(ProtoJoinEdge)

AggregatedColumn = _reflection.GeneratedProtocolMessageType('AggregatedColumn', (_message.Message,), dict(
  DESCRIPTOR = _AGGREGATEDCOLUMN,
  __module__ = 'query_pb2'
  # @@protoc_insertion_point(class_scope:AggregatedColumn)
  ))
_sym_db.RegisterMessage(AggregatedColumn)

OrderedColumn = _reflection.GeneratedProtocolMessageType('OrderedColumn', (_message.Message,), dict(
  DESCRIPTOR = _ORDEREDCOLUMN,
  __module__ = 'query_pb2'
  # @@protoc_insertion_point(class_scope:OrderedColumn)
  ))
_sym_db.RegisterMessage(OrderedColumn)

SelectionClause = _reflection.GeneratedProtocolMessageType('SelectionClause', (_message.Message,), dict(
  DESCRIPTOR = _SELECTIONCLAUSE,
  __module__ = 'query_pb2'
  # @@protoc_insertion_point(class_scope:SelectionClause)
  ))
_sym_db.RegisterMessage(SelectionClause)

Predicate = _reflection.GeneratedProtocolMessageType('Predicate', (_message.Message,), dict(
  DESCRIPTOR = _PREDICATE,
  __module__ = 'query_pb2'
  # @@protoc_insertion_point(class_scope:Predicate)
  ))
_sym_db.RegisterMessage(Predicate)


_PROTOJOINPATH_EDGEMAPENTRY._options = None
# @@protoc_insertion_point(module_scope)
