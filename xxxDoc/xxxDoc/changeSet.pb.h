// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: changeSet.proto

#ifndef PROTOBUF_changeSet_2eproto__INCLUDED
#define PROTOBUF_changeSet_2eproto__INCLUDED

#include <string>

#include <google/protobuf/stubs/common.h>

#if GOOGLE_PROTOBUF_VERSION < 2005000
#error This file was generated by a newer version of protoc which is
#error incompatible with your Protocol Buffer headers.  Please update
#error your headers.
#endif
#if 2005000 < GOOGLE_PROTOBUF_MIN_PROTOC_VERSION
#error This file was generated by an older version of protoc which is
#error incompatible with your Protocol Buffer headers.  Please
#error regenerate this file with a newer version of protoc.
#endif

#include <google/protobuf/generated_message_util.h>
#include <google/protobuf/message.h>
#include <google/protobuf/repeated_field.h>
#include <google/protobuf/extension_set.h>
#include <google/protobuf/generated_enum_reflection.h>
#include <google/protobuf/unknown_field_set.h>
// @@protoc_insertion_point(includes)

namespace xxxDoc {

// Internal implementation detail -- do not call these.
void  protobuf_AddDesc_changeSet_2eproto();
void protobuf_AssignDesc_changeSet_2eproto();
void protobuf_ShutdownFile_changeSet_2eproto();

class NSRange;
class Operation;
class ChangeSet;

enum Operation_State {
  Operation_State_LOCALSTATE = 0,
  Operation_State_SENDSTATE = 1,
  Operation_State_GLOBALSTATE = 2,
  Operation_State_UNDOSTATE = 3,
  Operation_State_REDOSTATE = 4
};
bool Operation_State_IsValid(int value);
const Operation_State Operation_State_State_MIN = Operation_State_LOCALSTATE;
const Operation_State Operation_State_State_MAX = Operation_State_REDOSTATE;
const int Operation_State_State_ARRAYSIZE = Operation_State_State_MAX + 1;

const ::google::protobuf::EnumDescriptor* Operation_State_descriptor();
inline const ::std::string& Operation_State_Name(Operation_State value) {
  return ::google::protobuf::internal::NameOfEnum(
    Operation_State_descriptor(), value);
}
inline bool Operation_State_Parse(
    const ::std::string& name, Operation_State* value) {
  return ::google::protobuf::internal::ParseNamedEnum<Operation_State>(
    Operation_State_descriptor(), name, value);
}
// ===================================================================

class NSRange : public ::google::protobuf::Message {
 public:
  NSRange();
  virtual ~NSRange();

  NSRange(const NSRange& from);

  inline NSRange& operator=(const NSRange& from) {
    CopyFrom(from);
    return *this;
  }

  inline const ::google::protobuf::UnknownFieldSet& unknown_fields() const {
    return _unknown_fields_;
  }

  inline ::google::protobuf::UnknownFieldSet* mutable_unknown_fields() {
    return &_unknown_fields_;
  }

  static const ::google::protobuf::Descriptor* descriptor();
  static const NSRange& default_instance();

  void Swap(NSRange* other);

  // implements Message ----------------------------------------------

  NSRange* New() const;
  void CopyFrom(const ::google::protobuf::Message& from);
  void MergeFrom(const ::google::protobuf::Message& from);
  void CopyFrom(const NSRange& from);
  void MergeFrom(const NSRange& from);
  void Clear();
  bool IsInitialized() const;

  int ByteSize() const;
  bool MergePartialFromCodedStream(
      ::google::protobuf::io::CodedInputStream* input);
  void SerializeWithCachedSizes(
      ::google::protobuf::io::CodedOutputStream* output) const;
  ::google::protobuf::uint8* SerializeWithCachedSizesToArray(::google::protobuf::uint8* output) const;
  int GetCachedSize() const { return _cached_size_; }
  private:
  void SharedCtor();
  void SharedDtor();
  void SetCachedSize(int size) const;
  public:

  ::google::protobuf::Metadata GetMetadata() const;

  // nested types ----------------------------------------------------

  // accessors -------------------------------------------------------

  // optional int64 location = 1;
  inline bool has_location() const;
  inline void clear_location();
  static const int kLocationFieldNumber = 1;
  inline ::google::protobuf::int64 location() const;
  inline void set_location(::google::protobuf::int64 value);

  // optional int64 length = 2;
  inline bool has_length() const;
  inline void clear_length();
  static const int kLengthFieldNumber = 2;
  inline ::google::protobuf::int64 length() const;
  inline void set_length(::google::protobuf::int64 value);

  // @@protoc_insertion_point(class_scope:xxxDoc.NSRange)
 private:
  inline void set_has_location();
  inline void clear_has_location();
  inline void set_has_length();
  inline void clear_has_length();

  ::google::protobuf::UnknownFieldSet _unknown_fields_;

  ::google::protobuf::int64 location_;
  ::google::protobuf::int64 length_;

  mutable int _cached_size_;
  ::google::protobuf::uint32 _has_bits_[(2 + 31) / 32];

  friend void  protobuf_AddDesc_changeSet_2eproto();
  friend void protobuf_AssignDesc_changeSet_2eproto();
  friend void protobuf_ShutdownFile_changeSet_2eproto();

  void InitAsDefaultInstance();
  static NSRange* default_instance_;
};
// -------------------------------------------------------------------

class Operation : public ::google::protobuf::Message {
 public:
  Operation();
  virtual ~Operation();

  Operation(const Operation& from);

  inline Operation& operator=(const Operation& from) {
    CopyFrom(from);
    return *this;
  }

  inline const ::google::protobuf::UnknownFieldSet& unknown_fields() const {
    return _unknown_fields_;
  }

  inline ::google::protobuf::UnknownFieldSet* mutable_unknown_fields() {
    return &_unknown_fields_;
  }

  static const ::google::protobuf::Descriptor* descriptor();
  static const Operation& default_instance();

  void Swap(Operation* other);

  // implements Message ----------------------------------------------

  Operation* New() const;
  void CopyFrom(const ::google::protobuf::Message& from);
  void MergeFrom(const ::google::protobuf::Message& from);
  void CopyFrom(const Operation& from);
  void MergeFrom(const Operation& from);
  void Clear();
  bool IsInitialized() const;

  int ByteSize() const;
  bool MergePartialFromCodedStream(
      ::google::protobuf::io::CodedInputStream* input);
  void SerializeWithCachedSizes(
      ::google::protobuf::io::CodedOutputStream* output) const;
  ::google::protobuf::uint8* SerializeWithCachedSizesToArray(::google::protobuf::uint8* output) const;
  int GetCachedSize() const { return _cached_size_; }
  private:
  void SharedCtor();
  void SharedDtor();
  void SetCachedSize(int size) const;
  public:

  ::google::protobuf::Metadata GetMetadata() const;

  // nested types ----------------------------------------------------

  typedef Operation_State State;
  static const State LOCALSTATE = Operation_State_LOCALSTATE;
  static const State SENDSTATE = Operation_State_SENDSTATE;
  static const State GLOBALSTATE = Operation_State_GLOBALSTATE;
  static const State UNDOSTATE = Operation_State_UNDOSTATE;
  static const State REDOSTATE = Operation_State_REDOSTATE;
  static inline bool State_IsValid(int value) {
    return Operation_State_IsValid(value);
  }
  static const State State_MIN =
    Operation_State_State_MIN;
  static const State State_MAX =
    Operation_State_State_MAX;
  static const int State_ARRAYSIZE =
    Operation_State_State_ARRAYSIZE;
  static inline const ::google::protobuf::EnumDescriptor*
  State_descriptor() {
    return Operation_State_descriptor();
  }
  static inline const ::std::string& State_Name(State value) {
    return Operation_State_Name(value);
  }
  static inline bool State_Parse(const ::std::string& name,
      State* value) {
    return Operation_State_Parse(name, value);
  }

  // accessors -------------------------------------------------------

  // optional .xxxDoc.NSRange range = 1;
  inline bool has_range() const;
  inline void clear_range();
  static const int kRangeFieldNumber = 1;
  inline const ::xxxDoc::NSRange& range() const;
  inline ::xxxDoc::NSRange* mutable_range();
  inline ::xxxDoc::NSRange* release_range();
  inline void set_allocated_range(::xxxDoc::NSRange* range);

  // optional string original_String = 2;
  inline bool has_original_string() const;
  inline void clear_original_string();
  static const int kOriginalStringFieldNumber = 2;
  inline const ::std::string& original_string() const;
  inline void set_original_string(const ::std::string& value);
  inline void set_original_string(const char* value);
  inline void set_original_string(const char* value, size_t size);
  inline ::std::string* mutable_original_string();
  inline ::std::string* release_original_string();
  inline void set_allocated_original_string(::std::string* original_string);

  // optional string replace_String = 3;
  inline bool has_replace_string() const;
  inline void clear_replace_string();
  static const int kReplaceStringFieldNumber = 3;
  inline const ::std::string& replace_string() const;
  inline void set_replace_string(const ::std::string& value);
  inline void set_replace_string(const char* value);
  inline void set_replace_string(const char* value, size_t size);
  inline ::std::string* mutable_replace_string();
  inline ::std::string* release_replace_string();
  inline void set_allocated_replace_string(::std::string* replace_string);

  // optional .xxxDoc.Operation.State state = 4;
  inline bool has_state() const;
  inline void clear_state();
  static const int kStateFieldNumber = 4;
  inline ::xxxDoc::Operation_State state() const;
  inline void set_state(::xxxDoc::Operation_State value);

  // optional int64 operation_ID = 5;
  inline bool has_operation_id() const;
  inline void clear_operation_id();
  static const int kOperationIDFieldNumber = 5;
  inline ::google::protobuf::int64 operation_id() const;
  inline void set_operation_id(::google::protobuf::int64 value);

  // optional int64 participant_ID = 6;
  inline bool has_participant_id() const;
  inline void clear_participant_id();
  static const int kParticipantIDFieldNumber = 6;
  inline ::google::protobuf::int64 participant_id() const;
  inline void set_participant_id(::google::protobuf::int64 value);

  // optional int64 globalID = 7;
  inline bool has_globalid() const;
  inline void clear_globalid();
  static const int kGlobalIDFieldNumber = 7;
  inline ::google::protobuf::int64 globalid() const;
  inline void set_globalid(::google::protobuf::int64 value);

  // optional int64 referID = 8;
  inline bool has_referid() const;
  inline void clear_referid();
  static const int kReferIDFieldNumber = 8;
  inline ::google::protobuf::int64 referid() const;
  inline void set_referid(::google::protobuf::int64 value);

  // @@protoc_insertion_point(class_scope:xxxDoc.Operation)
 private:
  inline void set_has_range();
  inline void clear_has_range();
  inline void set_has_original_string();
  inline void clear_has_original_string();
  inline void set_has_replace_string();
  inline void clear_has_replace_string();
  inline void set_has_state();
  inline void clear_has_state();
  inline void set_has_operation_id();
  inline void clear_has_operation_id();
  inline void set_has_participant_id();
  inline void clear_has_participant_id();
  inline void set_has_globalid();
  inline void clear_has_globalid();
  inline void set_has_referid();
  inline void clear_has_referid();

  ::google::protobuf::UnknownFieldSet _unknown_fields_;

  ::xxxDoc::NSRange* range_;
  ::std::string* original_string_;
  ::std::string* replace_string_;
  ::google::protobuf::int64 operation_id_;
  ::google::protobuf::int64 participant_id_;
  ::google::protobuf::int64 globalid_;
  ::google::protobuf::int64 referid_;
  int state_;

  mutable int _cached_size_;
  ::google::protobuf::uint32 _has_bits_[(8 + 31) / 32];

  friend void  protobuf_AddDesc_changeSet_2eproto();
  friend void protobuf_AssignDesc_changeSet_2eproto();
  friend void protobuf_ShutdownFile_changeSet_2eproto();

  void InitAsDefaultInstance();
  static Operation* default_instance_;
};
// -------------------------------------------------------------------

class ChangeSet : public ::google::protobuf::Message {
 public:
  ChangeSet();
  virtual ~ChangeSet();

  ChangeSet(const ChangeSet& from);

  inline ChangeSet& operator=(const ChangeSet& from) {
    CopyFrom(from);
    return *this;
  }

  inline const ::google::protobuf::UnknownFieldSet& unknown_fields() const {
    return _unknown_fields_;
  }

  inline ::google::protobuf::UnknownFieldSet* mutable_unknown_fields() {
    return &_unknown_fields_;
  }

  static const ::google::protobuf::Descriptor* descriptor();
  static const ChangeSet& default_instance();

  void Swap(ChangeSet* other);

  // implements Message ----------------------------------------------

  ChangeSet* New() const;
  void CopyFrom(const ::google::protobuf::Message& from);
  void MergeFrom(const ::google::protobuf::Message& from);
  void CopyFrom(const ChangeSet& from);
  void MergeFrom(const ChangeSet& from);
  void Clear();
  bool IsInitialized() const;

  int ByteSize() const;
  bool MergePartialFromCodedStream(
      ::google::protobuf::io::CodedInputStream* input);
  void SerializeWithCachedSizes(
      ::google::protobuf::io::CodedOutputStream* output) const;
  ::google::protobuf::uint8* SerializeWithCachedSizesToArray(::google::protobuf::uint8* output) const;
  int GetCachedSize() const { return _cached_size_; }
  private:
  void SharedCtor();
  void SharedDtor();
  void SetCachedSize(int size) const;
  public:

  ::google::protobuf::Metadata GetMetadata() const;

  // nested types ----------------------------------------------------

  // accessors -------------------------------------------------------

  // optional int64 startGlobal_ID = 1;
  inline bool has_startglobal_id() const;
  inline void clear_startglobal_id();
  static const int kStartGlobalIDFieldNumber = 1;
  inline ::google::protobuf::int64 startglobal_id() const;
  inline void set_startglobal_id(::google::protobuf::int64 value);

  // optional int64 cursor_Location = 2;
  inline bool has_cursor_location() const;
  inline void clear_cursor_location();
  static const int kCursorLocationFieldNumber = 2;
  inline ::google::protobuf::int64 cursor_location() const;
  inline void set_cursor_location(::google::protobuf::int64 value);

  // repeated .xxxDoc.Operation operations = 3;
  inline int operations_size() const;
  inline void clear_operations();
  static const int kOperationsFieldNumber = 3;
  inline const ::xxxDoc::Operation& operations(int index) const;
  inline ::xxxDoc::Operation* mutable_operations(int index);
  inline ::xxxDoc::Operation* add_operations();
  inline const ::google::protobuf::RepeatedPtrField< ::xxxDoc::Operation >&
      operations() const;
  inline ::google::protobuf::RepeatedPtrField< ::xxxDoc::Operation >*
      mutable_operations();

  // @@protoc_insertion_point(class_scope:xxxDoc.ChangeSet)
 private:
  inline void set_has_startglobal_id();
  inline void clear_has_startglobal_id();
  inline void set_has_cursor_location();
  inline void clear_has_cursor_location();

  ::google::protobuf::UnknownFieldSet _unknown_fields_;

  ::google::protobuf::int64 startglobal_id_;
  ::google::protobuf::int64 cursor_location_;
  ::google::protobuf::RepeatedPtrField< ::xxxDoc::Operation > operations_;

  mutable int _cached_size_;
  ::google::protobuf::uint32 _has_bits_[(3 + 31) / 32];

  friend void  protobuf_AddDesc_changeSet_2eproto();
  friend void protobuf_AssignDesc_changeSet_2eproto();
  friend void protobuf_ShutdownFile_changeSet_2eproto();

  void InitAsDefaultInstance();
  static ChangeSet* default_instance_;
};
// ===================================================================


// ===================================================================

// NSRange

// optional int64 location = 1;
inline bool NSRange::has_location() const {
  return (_has_bits_[0] & 0x00000001u) != 0;
}
inline void NSRange::set_has_location() {
  _has_bits_[0] |= 0x00000001u;
}
inline void NSRange::clear_has_location() {
  _has_bits_[0] &= ~0x00000001u;
}
inline void NSRange::clear_location() {
  location_ = GOOGLE_LONGLONG(0);
  clear_has_location();
}
inline ::google::protobuf::int64 NSRange::location() const {
  return location_;
}
inline void NSRange::set_location(::google::protobuf::int64 value) {
  set_has_location();
  location_ = value;
}

// optional int64 length = 2;
inline bool NSRange::has_length() const {
  return (_has_bits_[0] & 0x00000002u) != 0;
}
inline void NSRange::set_has_length() {
  _has_bits_[0] |= 0x00000002u;
}
inline void NSRange::clear_has_length() {
  _has_bits_[0] &= ~0x00000002u;
}
inline void NSRange::clear_length() {
  length_ = GOOGLE_LONGLONG(0);
  clear_has_length();
}
inline ::google::protobuf::int64 NSRange::length() const {
  return length_;
}
inline void NSRange::set_length(::google::protobuf::int64 value) {
  set_has_length();
  length_ = value;
}

// -------------------------------------------------------------------

// Operation

// optional .xxxDoc.NSRange range = 1;
inline bool Operation::has_range() const {
  return (_has_bits_[0] & 0x00000001u) != 0;
}
inline void Operation::set_has_range() {
  _has_bits_[0] |= 0x00000001u;
}
inline void Operation::clear_has_range() {
  _has_bits_[0] &= ~0x00000001u;
}
inline void Operation::clear_range() {
  if (range_ != NULL) range_->::xxxDoc::NSRange::Clear();
  clear_has_range();
}
inline const ::xxxDoc::NSRange& Operation::range() const {
  return range_ != NULL ? *range_ : *default_instance_->range_;
}
inline ::xxxDoc::NSRange* Operation::mutable_range() {
  set_has_range();
  if (range_ == NULL) range_ = new ::xxxDoc::NSRange;
  return range_;
}
inline ::xxxDoc::NSRange* Operation::release_range() {
  clear_has_range();
  ::xxxDoc::NSRange* temp = range_;
  range_ = NULL;
  return temp;
}
inline void Operation::set_allocated_range(::xxxDoc::NSRange* range) {
  delete range_;
  range_ = range;
  if (range) {
    set_has_range();
  } else {
    clear_has_range();
  }
}

// optional string original_String = 2;
inline bool Operation::has_original_string() const {
  return (_has_bits_[0] & 0x00000002u) != 0;
}
inline void Operation::set_has_original_string() {
  _has_bits_[0] |= 0x00000002u;
}
inline void Operation::clear_has_original_string() {
  _has_bits_[0] &= ~0x00000002u;
}
inline void Operation::clear_original_string() {
  if (original_string_ != &::google::protobuf::internal::kEmptyString) {
    original_string_->clear();
  }
  clear_has_original_string();
}
inline const ::std::string& Operation::original_string() const {
  return *original_string_;
}
inline void Operation::set_original_string(const ::std::string& value) {
  set_has_original_string();
  if (original_string_ == &::google::protobuf::internal::kEmptyString) {
    original_string_ = new ::std::string;
  }
  original_string_->assign(value);
}
inline void Operation::set_original_string(const char* value) {
  set_has_original_string();
  if (original_string_ == &::google::protobuf::internal::kEmptyString) {
    original_string_ = new ::std::string;
  }
  original_string_->assign(value);
}
inline void Operation::set_original_string(const char* value, size_t size) {
  set_has_original_string();
  if (original_string_ == &::google::protobuf::internal::kEmptyString) {
    original_string_ = new ::std::string;
  }
  original_string_->assign(reinterpret_cast<const char*>(value), size);
}
inline ::std::string* Operation::mutable_original_string() {
  set_has_original_string();
  if (original_string_ == &::google::protobuf::internal::kEmptyString) {
    original_string_ = new ::std::string;
  }
  return original_string_;
}
inline ::std::string* Operation::release_original_string() {
  clear_has_original_string();
  if (original_string_ == &::google::protobuf::internal::kEmptyString) {
    return NULL;
  } else {
    ::std::string* temp = original_string_;
    original_string_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
    return temp;
  }
}
inline void Operation::set_allocated_original_string(::std::string* original_string) {
  if (original_string_ != &::google::protobuf::internal::kEmptyString) {
    delete original_string_;
  }
  if (original_string) {
    set_has_original_string();
    original_string_ = original_string;
  } else {
    clear_has_original_string();
    original_string_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
  }
}

// optional string replace_String = 3;
inline bool Operation::has_replace_string() const {
  return (_has_bits_[0] & 0x00000004u) != 0;
}
inline void Operation::set_has_replace_string() {
  _has_bits_[0] |= 0x00000004u;
}
inline void Operation::clear_has_replace_string() {
  _has_bits_[0] &= ~0x00000004u;
}
inline void Operation::clear_replace_string() {
  if (replace_string_ != &::google::protobuf::internal::kEmptyString) {
    replace_string_->clear();
  }
  clear_has_replace_string();
}
inline const ::std::string& Operation::replace_string() const {
  return *replace_string_;
}
inline void Operation::set_replace_string(const ::std::string& value) {
  set_has_replace_string();
  if (replace_string_ == &::google::protobuf::internal::kEmptyString) {
    replace_string_ = new ::std::string;
  }
  replace_string_->assign(value);
}
inline void Operation::set_replace_string(const char* value) {
  set_has_replace_string();
  if (replace_string_ == &::google::protobuf::internal::kEmptyString) {
    replace_string_ = new ::std::string;
  }
  replace_string_->assign(value);
}
inline void Operation::set_replace_string(const char* value, size_t size) {
  set_has_replace_string();
  if (replace_string_ == &::google::protobuf::internal::kEmptyString) {
    replace_string_ = new ::std::string;
  }
  replace_string_->assign(reinterpret_cast<const char*>(value), size);
}
inline ::std::string* Operation::mutable_replace_string() {
  set_has_replace_string();
  if (replace_string_ == &::google::protobuf::internal::kEmptyString) {
    replace_string_ = new ::std::string;
  }
  return replace_string_;
}
inline ::std::string* Operation::release_replace_string() {
  clear_has_replace_string();
  if (replace_string_ == &::google::protobuf::internal::kEmptyString) {
    return NULL;
  } else {
    ::std::string* temp = replace_string_;
    replace_string_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
    return temp;
  }
}
inline void Operation::set_allocated_replace_string(::std::string* replace_string) {
  if (replace_string_ != &::google::protobuf::internal::kEmptyString) {
    delete replace_string_;
  }
  if (replace_string) {
    set_has_replace_string();
    replace_string_ = replace_string;
  } else {
    clear_has_replace_string();
    replace_string_ = const_cast< ::std::string*>(&::google::protobuf::internal::kEmptyString);
  }
}

// optional .xxxDoc.Operation.State state = 4;
inline bool Operation::has_state() const {
  return (_has_bits_[0] & 0x00000008u) != 0;
}
inline void Operation::set_has_state() {
  _has_bits_[0] |= 0x00000008u;
}
inline void Operation::clear_has_state() {
  _has_bits_[0] &= ~0x00000008u;
}
inline void Operation::clear_state() {
  state_ = 0;
  clear_has_state();
}
inline ::xxxDoc::Operation_State Operation::state() const {
  return static_cast< ::xxxDoc::Operation_State >(state_);
}
inline void Operation::set_state(::xxxDoc::Operation_State value) {
  assert(::xxxDoc::Operation_State_IsValid(value));
  set_has_state();
  state_ = value;
}

// optional int64 operation_ID = 5;
inline bool Operation::has_operation_id() const {
  return (_has_bits_[0] & 0x00000010u) != 0;
}
inline void Operation::set_has_operation_id() {
  _has_bits_[0] |= 0x00000010u;
}
inline void Operation::clear_has_operation_id() {
  _has_bits_[0] &= ~0x00000010u;
}
inline void Operation::clear_operation_id() {
  operation_id_ = GOOGLE_LONGLONG(0);
  clear_has_operation_id();
}
inline ::google::protobuf::int64 Operation::operation_id() const {
  return operation_id_;
}
inline void Operation::set_operation_id(::google::protobuf::int64 value) {
  set_has_operation_id();
  operation_id_ = value;
}

// optional int64 participant_ID = 6;
inline bool Operation::has_participant_id() const {
  return (_has_bits_[0] & 0x00000020u) != 0;
}
inline void Operation::set_has_participant_id() {
  _has_bits_[0] |= 0x00000020u;
}
inline void Operation::clear_has_participant_id() {
  _has_bits_[0] &= ~0x00000020u;
}
inline void Operation::clear_participant_id() {
  participant_id_ = GOOGLE_LONGLONG(0);
  clear_has_participant_id();
}
inline ::google::protobuf::int64 Operation::participant_id() const {
  return participant_id_;
}
inline void Operation::set_participant_id(::google::protobuf::int64 value) {
  set_has_participant_id();
  participant_id_ = value;
}

// optional int64 globalID = 7;
inline bool Operation::has_globalid() const {
  return (_has_bits_[0] & 0x00000040u) != 0;
}
inline void Operation::set_has_globalid() {
  _has_bits_[0] |= 0x00000040u;
}
inline void Operation::clear_has_globalid() {
  _has_bits_[0] &= ~0x00000040u;
}
inline void Operation::clear_globalid() {
  globalid_ = GOOGLE_LONGLONG(0);
  clear_has_globalid();
}
inline ::google::protobuf::int64 Operation::globalid() const {
  return globalid_;
}
inline void Operation::set_globalid(::google::protobuf::int64 value) {
  set_has_globalid();
  globalid_ = value;
}

// optional int64 referID = 8;
inline bool Operation::has_referid() const {
  return (_has_bits_[0] & 0x00000080u) != 0;
}
inline void Operation::set_has_referid() {
  _has_bits_[0] |= 0x00000080u;
}
inline void Operation::clear_has_referid() {
  _has_bits_[0] &= ~0x00000080u;
}
inline void Operation::clear_referid() {
  referid_ = GOOGLE_LONGLONG(0);
  clear_has_referid();
}
inline ::google::protobuf::int64 Operation::referid() const {
  return referid_;
}
inline void Operation::set_referid(::google::protobuf::int64 value) {
  set_has_referid();
  referid_ = value;
}

// -------------------------------------------------------------------

// ChangeSet

// optional int64 startGlobal_ID = 1;
inline bool ChangeSet::has_startglobal_id() const {
  return (_has_bits_[0] & 0x00000001u) != 0;
}
inline void ChangeSet::set_has_startglobal_id() {
  _has_bits_[0] |= 0x00000001u;
}
inline void ChangeSet::clear_has_startglobal_id() {
  _has_bits_[0] &= ~0x00000001u;
}
inline void ChangeSet::clear_startglobal_id() {
  startglobal_id_ = GOOGLE_LONGLONG(0);
  clear_has_startglobal_id();
}
inline ::google::protobuf::int64 ChangeSet::startglobal_id() const {
  return startglobal_id_;
}
inline void ChangeSet::set_startglobal_id(::google::protobuf::int64 value) {
  set_has_startglobal_id();
  startglobal_id_ = value;
}

// optional int64 cursor_Location = 2;
inline bool ChangeSet::has_cursor_location() const {
  return (_has_bits_[0] & 0x00000002u) != 0;
}
inline void ChangeSet::set_has_cursor_location() {
  _has_bits_[0] |= 0x00000002u;
}
inline void ChangeSet::clear_has_cursor_location() {
  _has_bits_[0] &= ~0x00000002u;
}
inline void ChangeSet::clear_cursor_location() {
  cursor_location_ = GOOGLE_LONGLONG(0);
  clear_has_cursor_location();
}
inline ::google::protobuf::int64 ChangeSet::cursor_location() const {
  return cursor_location_;
}
inline void ChangeSet::set_cursor_location(::google::protobuf::int64 value) {
  set_has_cursor_location();
  cursor_location_ = value;
}

// repeated .xxxDoc.Operation operations = 3;
inline int ChangeSet::operations_size() const {
  return operations_.size();
}
inline void ChangeSet::clear_operations() {
  operations_.Clear();
}
inline const ::xxxDoc::Operation& ChangeSet::operations(int index) const {
  return operations_.Get(index);
}
inline ::xxxDoc::Operation* ChangeSet::mutable_operations(int index) {
  return operations_.Mutable(index);
}
inline ::xxxDoc::Operation* ChangeSet::add_operations() {
  return operations_.Add();
}
inline const ::google::protobuf::RepeatedPtrField< ::xxxDoc::Operation >&
ChangeSet::operations() const {
  return operations_;
}
inline ::google::protobuf::RepeatedPtrField< ::xxxDoc::Operation >*
ChangeSet::mutable_operations() {
  return &operations_;
}


// @@protoc_insertion_point(namespace_scope)

}  // namespace xxxDoc

#ifndef SWIG
namespace google {
namespace protobuf {

template <>
inline const EnumDescriptor* GetEnumDescriptor< ::xxxDoc::Operation_State>() {
  return ::xxxDoc::Operation_State_descriptor();
}

}  // namespace google
}  // namespace protobuf
#endif  // SWIG

// @@protoc_insertion_point(global_scope)

#endif  // PROTOBUF_changeSet_2eproto__INCLUDED
