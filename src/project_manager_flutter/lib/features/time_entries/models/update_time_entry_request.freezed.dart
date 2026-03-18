// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_time_entry_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateTimeEntryRequest {

@DateOnlyConverter() DateTime get date; double get hours; String? get description; double? get billableRate; bool get isBillable; String? get taskId;
/// Create a copy of UpdateTimeEntryRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTimeEntryRequestCopyWith<UpdateTimeEntryRequest> get copyWith => _$UpdateTimeEntryRequestCopyWithImpl<UpdateTimeEntryRequest>(this as UpdateTimeEntryRequest, _$identity);

  /// Serializes this UpdateTimeEntryRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTimeEntryRequest&&(identical(other.date, date) || other.date == date)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.description, description) || other.description == description)&&(identical(other.billableRate, billableRate) || other.billableRate == billableRate)&&(identical(other.isBillable, isBillable) || other.isBillable == isBillable)&&(identical(other.taskId, taskId) || other.taskId == taskId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,hours,description,billableRate,isBillable,taskId);

@override
String toString() {
  return 'UpdateTimeEntryRequest(date: $date, hours: $hours, description: $description, billableRate: $billableRate, isBillable: $isBillable, taskId: $taskId)';
}


}

/// @nodoc
abstract mixin class $UpdateTimeEntryRequestCopyWith<$Res>  {
  factory $UpdateTimeEntryRequestCopyWith(UpdateTimeEntryRequest value, $Res Function(UpdateTimeEntryRequest) _then) = _$UpdateTimeEntryRequestCopyWithImpl;
@useResult
$Res call({
@DateOnlyConverter() DateTime date, double hours, String? description, double? billableRate, bool isBillable, String? taskId
});




}
/// @nodoc
class _$UpdateTimeEntryRequestCopyWithImpl<$Res>
    implements $UpdateTimeEntryRequestCopyWith<$Res> {
  _$UpdateTimeEntryRequestCopyWithImpl(this._self, this._then);

  final UpdateTimeEntryRequest _self;
  final $Res Function(UpdateTimeEntryRequest) _then;

/// Create a copy of UpdateTimeEntryRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? hours = null,Object? description = freezed,Object? billableRate = freezed,Object? isBillable = null,Object? taskId = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,billableRate: freezed == billableRate ? _self.billableRate : billableRate // ignore: cast_nullable_to_non_nullable
as double?,isBillable: null == isBillable ? _self.isBillable : isBillable // ignore: cast_nullable_to_non_nullable
as bool,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateTimeEntryRequest].
extension UpdateTimeEntryRequestPatterns on UpdateTimeEntryRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateTimeEntryRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateTimeEntryRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateTimeEntryRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateTimeEntryRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateTimeEntryRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateTimeEntryRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  double hours,  String? description,  double? billableRate,  bool isBillable,  String? taskId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateTimeEntryRequest() when $default != null:
return $default(_that.date,_that.hours,_that.description,_that.billableRate,_that.isBillable,_that.taskId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@DateOnlyConverter()  DateTime date,  double hours,  String? description,  double? billableRate,  bool isBillable,  String? taskId)  $default,) {final _that = this;
switch (_that) {
case _UpdateTimeEntryRequest():
return $default(_that.date,_that.hours,_that.description,_that.billableRate,_that.isBillable,_that.taskId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@DateOnlyConverter()  DateTime date,  double hours,  String? description,  double? billableRate,  bool isBillable,  String? taskId)?  $default,) {final _that = this;
switch (_that) {
case _UpdateTimeEntryRequest() when $default != null:
return $default(_that.date,_that.hours,_that.description,_that.billableRate,_that.isBillable,_that.taskId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateTimeEntryRequest implements UpdateTimeEntryRequest {
  const _UpdateTimeEntryRequest({@DateOnlyConverter() required this.date, required this.hours, this.description, this.billableRate, required this.isBillable, this.taskId});
  factory _UpdateTimeEntryRequest.fromJson(Map<String, dynamic> json) => _$UpdateTimeEntryRequestFromJson(json);

@override@DateOnlyConverter() final  DateTime date;
@override final  double hours;
@override final  String? description;
@override final  double? billableRate;
@override final  bool isBillable;
@override final  String? taskId;

/// Create a copy of UpdateTimeEntryRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateTimeEntryRequestCopyWith<_UpdateTimeEntryRequest> get copyWith => __$UpdateTimeEntryRequestCopyWithImpl<_UpdateTimeEntryRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateTimeEntryRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateTimeEntryRequest&&(identical(other.date, date) || other.date == date)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.description, description) || other.description == description)&&(identical(other.billableRate, billableRate) || other.billableRate == billableRate)&&(identical(other.isBillable, isBillable) || other.isBillable == isBillable)&&(identical(other.taskId, taskId) || other.taskId == taskId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,date,hours,description,billableRate,isBillable,taskId);

@override
String toString() {
  return 'UpdateTimeEntryRequest(date: $date, hours: $hours, description: $description, billableRate: $billableRate, isBillable: $isBillable, taskId: $taskId)';
}


}

/// @nodoc
abstract mixin class _$UpdateTimeEntryRequestCopyWith<$Res> implements $UpdateTimeEntryRequestCopyWith<$Res> {
  factory _$UpdateTimeEntryRequestCopyWith(_UpdateTimeEntryRequest value, $Res Function(_UpdateTimeEntryRequest) _then) = __$UpdateTimeEntryRequestCopyWithImpl;
@override @useResult
$Res call({
@DateOnlyConverter() DateTime date, double hours, String? description, double? billableRate, bool isBillable, String? taskId
});




}
/// @nodoc
class __$UpdateTimeEntryRequestCopyWithImpl<$Res>
    implements _$UpdateTimeEntryRequestCopyWith<$Res> {
  __$UpdateTimeEntryRequestCopyWithImpl(this._self, this._then);

  final _UpdateTimeEntryRequest _self;
  final $Res Function(_UpdateTimeEntryRequest) _then;

/// Create a copy of UpdateTimeEntryRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? hours = null,Object? description = freezed,Object? billableRate = freezed,Object? isBillable = null,Object? taskId = freezed,}) {
  return _then(_UpdateTimeEntryRequest(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,billableRate: freezed == billableRate ? _self.billableRate : billableRate // ignore: cast_nullable_to_non_nullable
as double?,isBillable: null == isBillable ? _self.isBillable : isBillable // ignore: cast_nullable_to_non_nullable
as bool,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
