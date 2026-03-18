// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimeEntry {

 String get id; String get userId; String get userName; String get projectId; String get projectName;@DateOnlyConverter() DateTime get date; double get hours; String? get description; bool get isBillable; bool get isInvoiced; String? get taskId; String? get taskName;
/// Create a copy of TimeEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeEntryCopyWith<TimeEntry> get copyWith => _$TimeEntryCopyWithImpl<TimeEntry>(this as TimeEntry, _$identity);

  /// Serializes this TimeEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.date, date) || other.date == date)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.description, description) || other.description == description)&&(identical(other.isBillable, isBillable) || other.isBillable == isBillable)&&(identical(other.isInvoiced, isInvoiced) || other.isInvoiced == isInvoiced)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.taskName, taskName) || other.taskName == taskName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,projectId,projectName,date,hours,description,isBillable,isInvoiced,taskId,taskName);

@override
String toString() {
  return 'TimeEntry(id: $id, userId: $userId, userName: $userName, projectId: $projectId, projectName: $projectName, date: $date, hours: $hours, description: $description, isBillable: $isBillable, isInvoiced: $isInvoiced, taskId: $taskId, taskName: $taskName)';
}


}

/// @nodoc
abstract mixin class $TimeEntryCopyWith<$Res>  {
  factory $TimeEntryCopyWith(TimeEntry value, $Res Function(TimeEntry) _then) = _$TimeEntryCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String userName, String projectId, String projectName,@DateOnlyConverter() DateTime date, double hours, String? description, bool isBillable, bool isInvoiced, String? taskId, String? taskName
});




}
/// @nodoc
class _$TimeEntryCopyWithImpl<$Res>
    implements $TimeEntryCopyWith<$Res> {
  _$TimeEntryCopyWithImpl(this._self, this._then);

  final TimeEntry _self;
  final $Res Function(TimeEntry) _then;

/// Create a copy of TimeEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? userName = null,Object? projectId = null,Object? projectName = null,Object? date = null,Object? hours = null,Object? description = freezed,Object? isBillable = null,Object? isInvoiced = null,Object? taskId = freezed,Object? taskName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isBillable: null == isBillable ? _self.isBillable : isBillable // ignore: cast_nullable_to_non_nullable
as bool,isInvoiced: null == isInvoiced ? _self.isInvoiced : isInvoiced // ignore: cast_nullable_to_non_nullable
as bool,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,taskName: freezed == taskName ? _self.taskName : taskName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeEntry].
extension TimeEntryPatterns on TimeEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeEntry value)  $default,){
final _that = this;
switch (_that) {
case _TimeEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeEntry value)?  $default,){
final _that = this;
switch (_that) {
case _TimeEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String userName,  String projectId,  String projectName, @DateOnlyConverter()  DateTime date,  double hours,  String? description,  bool isBillable,  bool isInvoiced,  String? taskId,  String? taskName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeEntry() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.projectId,_that.projectName,_that.date,_that.hours,_that.description,_that.isBillable,_that.isInvoiced,_that.taskId,_that.taskName);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String userName,  String projectId,  String projectName, @DateOnlyConverter()  DateTime date,  double hours,  String? description,  bool isBillable,  bool isInvoiced,  String? taskId,  String? taskName)  $default,) {final _that = this;
switch (_that) {
case _TimeEntry():
return $default(_that.id,_that.userId,_that.userName,_that.projectId,_that.projectName,_that.date,_that.hours,_that.description,_that.isBillable,_that.isInvoiced,_that.taskId,_that.taskName);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String userName,  String projectId,  String projectName, @DateOnlyConverter()  DateTime date,  double hours,  String? description,  bool isBillable,  bool isInvoiced,  String? taskId,  String? taskName)?  $default,) {final _that = this;
switch (_that) {
case _TimeEntry() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.projectId,_that.projectName,_that.date,_that.hours,_that.description,_that.isBillable,_that.isInvoiced,_that.taskId,_that.taskName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeEntry implements TimeEntry {
  const _TimeEntry({required this.id, required this.userId, required this.userName, required this.projectId, required this.projectName, @DateOnlyConverter() required this.date, required this.hours, this.description, required this.isBillable, required this.isInvoiced, this.taskId, this.taskName});
  factory _TimeEntry.fromJson(Map<String, dynamic> json) => _$TimeEntryFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String userName;
@override final  String projectId;
@override final  String projectName;
@override@DateOnlyConverter() final  DateTime date;
@override final  double hours;
@override final  String? description;
@override final  bool isBillable;
@override final  bool isInvoiced;
@override final  String? taskId;
@override final  String? taskName;

/// Create a copy of TimeEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeEntryCopyWith<_TimeEntry> get copyWith => __$TimeEntryCopyWithImpl<_TimeEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.date, date) || other.date == date)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.description, description) || other.description == description)&&(identical(other.isBillable, isBillable) || other.isBillable == isBillable)&&(identical(other.isInvoiced, isInvoiced) || other.isInvoiced == isInvoiced)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.taskName, taskName) || other.taskName == taskName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,projectId,projectName,date,hours,description,isBillable,isInvoiced,taskId,taskName);

@override
String toString() {
  return 'TimeEntry(id: $id, userId: $userId, userName: $userName, projectId: $projectId, projectName: $projectName, date: $date, hours: $hours, description: $description, isBillable: $isBillable, isInvoiced: $isInvoiced, taskId: $taskId, taskName: $taskName)';
}


}

/// @nodoc
abstract mixin class _$TimeEntryCopyWith<$Res> implements $TimeEntryCopyWith<$Res> {
  factory _$TimeEntryCopyWith(_TimeEntry value, $Res Function(_TimeEntry) _then) = __$TimeEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String userName, String projectId, String projectName,@DateOnlyConverter() DateTime date, double hours, String? description, bool isBillable, bool isInvoiced, String? taskId, String? taskName
});




}
/// @nodoc
class __$TimeEntryCopyWithImpl<$Res>
    implements _$TimeEntryCopyWith<$Res> {
  __$TimeEntryCopyWithImpl(this._self, this._then);

  final _TimeEntry _self;
  final $Res Function(_TimeEntry) _then;

/// Create a copy of TimeEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? userName = null,Object? projectId = null,Object? projectName = null,Object? date = null,Object? hours = null,Object? description = freezed,Object? isBillable = null,Object? isInvoiced = null,Object? taskId = freezed,Object? taskName = freezed,}) {
  return _then(_TimeEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isBillable: null == isBillable ? _self.isBillable : isBillable // ignore: cast_nullable_to_non_nullable
as bool,isInvoiced: null == isInvoiced ? _self.isInvoiced : isInvoiced // ignore: cast_nullable_to_non_nullable
as bool,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,taskName: freezed == taskName ? _self.taskName : taskName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
