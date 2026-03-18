// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_task_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateTaskRequest {

 String get name; String? get description; String get status; String get priority; String? get assigneeId; String? get dueDate; double? get estimatedHours;
/// Create a copy of UpdateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTaskRequestCopyWith<UpdateTaskRequest> get copyWith => _$UpdateTaskRequestCopyWithImpl<UpdateTaskRequest>(this as UpdateTaskRequest, _$identity);

  /// Serializes this UpdateTaskRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTaskRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.assigneeId, assigneeId) || other.assigneeId == assigneeId)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.estimatedHours, estimatedHours) || other.estimatedHours == estimatedHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,status,priority,assigneeId,dueDate,estimatedHours);

@override
String toString() {
  return 'UpdateTaskRequest(name: $name, description: $description, status: $status, priority: $priority, assigneeId: $assigneeId, dueDate: $dueDate, estimatedHours: $estimatedHours)';
}


}

/// @nodoc
abstract mixin class $UpdateTaskRequestCopyWith<$Res>  {
  factory $UpdateTaskRequestCopyWith(UpdateTaskRequest value, $Res Function(UpdateTaskRequest) _then) = _$UpdateTaskRequestCopyWithImpl;
@useResult
$Res call({
 String name, String? description, String status, String priority, String? assigneeId, String? dueDate, double? estimatedHours
});




}
/// @nodoc
class _$UpdateTaskRequestCopyWithImpl<$Res>
    implements $UpdateTaskRequestCopyWith<$Res> {
  _$UpdateTaskRequestCopyWithImpl(this._self, this._then);

  final UpdateTaskRequest _self;
  final $Res Function(UpdateTaskRequest) _then;

/// Create a copy of UpdateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? status = null,Object? priority = null,Object? assigneeId = freezed,Object? dueDate = freezed,Object? estimatedHours = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,assigneeId: freezed == assigneeId ? _self.assigneeId : assigneeId // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String?,estimatedHours: freezed == estimatedHours ? _self.estimatedHours : estimatedHours // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTaskRequest].
extension UpdateTaskRequestPatterns on UpdateTaskRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTaskRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTaskRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTaskRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTaskRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTaskRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  String status,  String priority,  String? assigneeId,  String? dueDate,  double? estimatedHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTaskRequest() when $default != null:
return $default(_that.name,_that.description,_that.status,_that.priority,_that.assigneeId,_that.dueDate,_that.estimatedHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  String status,  String priority,  String? assigneeId,  String? dueDate,  double? estimatedHours)  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskRequest():
return $default(_that.name,_that.description,_that.status,_that.priority,_that.assigneeId,_that.dueDate,_that.estimatedHours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  String status,  String priority,  String? assigneeId,  String? dueDate,  double? estimatedHours)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTaskRequest() when $default != null:
return $default(_that.name,_that.description,_that.status,_that.priority,_that.assigneeId,_that.dueDate,_that.estimatedHours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTaskRequest implements UpdateTaskRequest {
  const _UpdateTaskRequest({required this.name, this.description, required this.status, required this.priority, this.assigneeId, this.dueDate, this.estimatedHours});
  factory _UpdateTaskRequest.fromJson(Map<String, dynamic> json) => _$UpdateTaskRequestFromJson(json);

@override final  String name;
@override final  String? description;
@override final  String status;
@override final  String priority;
@override final  String? assigneeId;
@override final  String? dueDate;
@override final  double? estimatedHours;

/// Create a copy of UpdateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTaskRequestCopyWith<_UpdateTaskRequest> get copyWith => __$UpdateTaskRequestCopyWithImpl<_UpdateTaskRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTaskRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTaskRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.assigneeId, assigneeId) || other.assigneeId == assigneeId)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.estimatedHours, estimatedHours) || other.estimatedHours == estimatedHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,status,priority,assigneeId,dueDate,estimatedHours);

@override
String toString() {
  return 'UpdateTaskRequest(name: $name, description: $description, status: $status, priority: $priority, assigneeId: $assigneeId, dueDate: $dueDate, estimatedHours: $estimatedHours)';
}


}

/// @nodoc
abstract mixin class _$UpdateTaskRequestCopyWith<$Res> implements $UpdateTaskRequestCopyWith<$Res> {
  factory _$UpdateTaskRequestCopyWith(_UpdateTaskRequest value, $Res Function(_UpdateTaskRequest) _then) = __$UpdateTaskRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, String status, String priority, String? assigneeId, String? dueDate, double? estimatedHours
});




}
/// @nodoc
class __$UpdateTaskRequestCopyWithImpl<$Res>
    implements _$UpdateTaskRequestCopyWith<$Res> {
  __$UpdateTaskRequestCopyWithImpl(this._self, this._then);

  final _UpdateTaskRequest _self;
  final $Res Function(_UpdateTaskRequest) _then;

/// Create a copy of UpdateTaskRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? status = null,Object? priority = null,Object? assigneeId = freezed,Object? dueDate = freezed,Object? estimatedHours = freezed,}) {
  return _then(_UpdateTaskRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as String,assigneeId: freezed == assigneeId ? _self.assigneeId : assigneeId // ignore: cast_nullable_to_non_nullable
as String?,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as String?,estimatedHours: freezed == estimatedHours ? _self.estimatedHours : estimatedHours // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
