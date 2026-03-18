// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskDetail {

 String get id; String get projectId; String get projectName; String get name; String? get description; String get status; String get priority; String? get assigneeId; String? get assigneeName; String? get dueDate; double? get estimatedHours; double get totalHoursLogged; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of TaskDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskDetailCopyWith<TaskDetail> get copyWith => _$TaskDetailCopyWithImpl<TaskDetail>(this as TaskDetail, _$identity);

  /// Serializes this TaskDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.assigneeId, assigneeId) || other.assigneeId == assigneeId)&&(identical(other.assigneeName, assigneeName) || other.assigneeName == assigneeName)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.estimatedHours, estimatedHours) || other.estimatedHours == estimatedHours)&&(identical(other.totalHoursLogged, totalHoursLogged) || other.totalHoursLogged == totalHoursLogged)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,projectName,name,description,status,priority,assigneeId,assigneeName,dueDate,estimatedHours,totalHoursLogged,createdAt,updatedAt);

@override
String toString() {
  return 'TaskDetail(id: $id, projectId: $projectId, projectName: $projectName, name: $name, description: $description, status: $status, priority: $priority, assigneeId: $assigneeId, assigneeName: $assigneeName, dueDate: $dueDate, estimatedHours: $estimatedHours, totalHoursLogged: $totalHoursLogged, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TaskDetailCopyWith<$Res>  {
  factory $TaskDetailCopyWith(TaskDetail value, $Res Function(TaskDetail) _then) = _$TaskDetailCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, String projectName, String name, String? description, String status, String priority, String? assigneeId, String? assigneeName, String? dueDate, double? estimatedHours, double totalHoursLogged, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$TaskDetailCopyWithImpl<$Res>
    implements $TaskDetailCopyWith<$Res> {
  _$TaskDetailCopyWithImpl(this._self, this._then);

  final TaskDetail _self;
  final $Res Function(TaskDetail) _then;

/// Create a copy of TaskDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? projectName = null,Object? name = null,Object? description = freezed,Object? status = null,Object? priority = null,Object? assigneeId = freezed,Object? assigneeName = freezed,Object? dueDate = freezed,Object? estimatedHours = freezed,Object? totalHoursLogged = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,assigneeId: freezed == assigneeId ? _self.assigneeId : assigneeId // ignore: cast_nullable_to_non_nullable
as String?,assigneeName: freezed == assigneeName ? _self.assigneeName : assigneeName // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String?,estimatedHours: freezed == estimatedHours ? _self.estimatedHours : estimatedHours // ignore: cast_nullable_to_non_nullable
as double?,totalHoursLogged: null == totalHoursLogged ? _self.totalHoursLogged : totalHoursLogged // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskDetail].
extension TaskDetailPatterns on TaskDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskDetail value)  $default,){
final _that = this;
switch (_that) {
case _TaskDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskDetail value)?  $default,){
final _that = this;
switch (_that) {
case _TaskDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  String projectName,  String name,  String? description,  String status,  String priority,  String? assigneeId,  String? assigneeName,  String? dueDate,  double? estimatedHours,  double totalHoursLogged,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskDetail() when $default != null:
return $default(_that.id,_that.projectId,_that.projectName,_that.name,_that.description,_that.status,_that.priority,_that.assigneeId,_that.assigneeName,_that.dueDate,_that.estimatedHours,_that.totalHoursLogged,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  String projectName,  String name,  String? description,  String status,  String priority,  String? assigneeId,  String? assigneeName,  String? dueDate,  double? estimatedHours,  double totalHoursLogged,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TaskDetail():
return $default(_that.id,_that.projectId,_that.projectName,_that.name,_that.description,_that.status,_that.priority,_that.assigneeId,_that.assigneeName,_that.dueDate,_that.estimatedHours,_that.totalHoursLogged,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  String projectName,  String name,  String? description,  String status,  String priority,  String? assigneeId,  String? assigneeName,  String? dueDate,  double? estimatedHours,  double totalHoursLogged,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TaskDetail() when $default != null:
return $default(_that.id,_that.projectId,_that.projectName,_that.name,_that.description,_that.status,_that.priority,_that.assigneeId,_that.assigneeName,_that.dueDate,_that.estimatedHours,_that.totalHoursLogged,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskDetail implements TaskDetail {
  const _TaskDetail({required this.id, required this.projectId, required this.projectName, required this.name, this.description, required this.status, required this.priority, this.assigneeId, this.assigneeName, this.dueDate, this.estimatedHours, required this.totalHoursLogged, required this.createdAt, required this.updatedAt});
  factory _TaskDetail.fromJson(Map<String, dynamic> json) => _$TaskDetailFromJson(json);

@override final  String id;
@override final  String projectId;
@override final  String projectName;
@override final  String name;
@override final  String? description;
@override final  String status;
@override final  String priority;
@override final  String? assigneeId;
@override final  String? assigneeName;
@override final  String? dueDate;
@override final  double? estimatedHours;
@override final  double totalHoursLogged;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of TaskDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskDetailCopyWith<_TaskDetail> get copyWith => __$TaskDetailCopyWithImpl<_TaskDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.assigneeId, assigneeId) || other.assigneeId == assigneeId)&&(identical(other.assigneeName, assigneeName) || other.assigneeName == assigneeName)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.estimatedHours, estimatedHours) || other.estimatedHours == estimatedHours)&&(identical(other.totalHoursLogged, totalHoursLogged) || other.totalHoursLogged == totalHoursLogged)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,projectName,name,description,status,priority,assigneeId,assigneeName,dueDate,estimatedHours,totalHoursLogged,createdAt,updatedAt);

@override
String toString() {
  return 'TaskDetail(id: $id, projectId: $projectId, projectName: $projectName, name: $name, description: $description, status: $status, priority: $priority, assigneeId: $assigneeId, assigneeName: $assigneeName, dueDate: $dueDate, estimatedHours: $estimatedHours, totalHoursLogged: $totalHoursLogged, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TaskDetailCopyWith<$Res> implements $TaskDetailCopyWith<$Res> {
  factory _$TaskDetailCopyWith(_TaskDetail value, $Res Function(_TaskDetail) _then) = __$TaskDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, String projectName, String name, String? description, String status, String priority, String? assigneeId, String? assigneeName, String? dueDate, double? estimatedHours, double totalHoursLogged, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$TaskDetailCopyWithImpl<$Res>
    implements _$TaskDetailCopyWith<$Res> {
  __$TaskDetailCopyWithImpl(this._self, this._then);

  final _TaskDetail _self;
  final $Res Function(_TaskDetail) _then;

/// Create a copy of TaskDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? projectName = null,Object? name = null,Object? description = freezed,Object? status = null,Object? priority = null,Object? assigneeId = freezed,Object? assigneeName = freezed,Object? dueDate = freezed,Object? estimatedHours = freezed,Object? totalHoursLogged = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_TaskDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,assigneeId: freezed == assigneeId ? _self.assigneeId : assigneeId // ignore: cast_nullable_to_non_nullable
as String?,assigneeName: freezed == assigneeName ? _self.assigneeName : assigneeName // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String?,estimatedHours: freezed == estimatedHours ? _self.estimatedHours : estimatedHours // ignore: cast_nullable_to_non_nullable
as double?,totalHoursLogged: null == totalHoursLogged ? _self.totalHoursLogged : totalHoursLogged // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
