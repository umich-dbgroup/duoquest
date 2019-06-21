# -*- coding: utf-8 -*-
# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: proto/task.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()




DESCRIPTOR = _descriptor.FileDescriptor(
  name='proto/task.proto',
  package='',
  syntax='proto3',
  serialized_options=None,
  serialized_pb=_b('\n\x10proto/task.proto\")\n\tProtoTask\x12\x0f\n\x07\x64\x62_name\x18\x01 \x01(\t\x12\x0b\n\x03nlq\x18\x02 \x01(\t\"\x1d\n\x0fProtoCandidates\x12\n\n\x02\x63q\x18\x01 \x03(\tb\x06proto3')
)




_PROTOTASK = _descriptor.Descriptor(
  name='ProtoTask',
  full_name='ProtoTask',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='db_name', full_name='ProtoTask.db_name', index=0,
      number=1, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      serialized_options=None, file=DESCRIPTOR),
    _descriptor.FieldDescriptor(
      name='nlq', full_name='ProtoTask.nlq', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
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
  serialized_start=20,
  serialized_end=61,
)


_PROTOCANDIDATES = _descriptor.Descriptor(
  name='ProtoCandidates',
  full_name='ProtoCandidates',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='cq', full_name='ProtoCandidates.cq', index=0,
      number=1, type=9, cpp_type=9, label=3,
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
  serialized_end=92,
)

DESCRIPTOR.message_types_by_name['ProtoTask'] = _PROTOTASK
DESCRIPTOR.message_types_by_name['ProtoCandidates'] = _PROTOCANDIDATES
_sym_db.RegisterFileDescriptor(DESCRIPTOR)

ProtoTask = _reflection.GeneratedProtocolMessageType('ProtoTask', (_message.Message,), dict(
  DESCRIPTOR = _PROTOTASK,
  __module__ = 'proto.task_pb2'
  # @@protoc_insertion_point(class_scope:ProtoTask)
  ))
_sym_db.RegisterMessage(ProtoTask)

ProtoCandidates = _reflection.GeneratedProtocolMessageType('ProtoCandidates', (_message.Message,), dict(
  DESCRIPTOR = _PROTOCANDIDATES,
  __module__ = 'proto.task_pb2'
  # @@protoc_insertion_point(class_scope:ProtoCandidates)
  ))
_sym_db.RegisterMessage(ProtoCandidates)


# @@protoc_insertion_point(module_scope)
