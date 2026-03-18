// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_project_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateProjectRequest {

 String get name; String? get description; String get status; double? get budgetAmount; double? get defaultBillableRate;@NullableDateOnlyConverter() DateTime? get startDate;@NullableDateOnlyConverter() DateTime? get endDate;
/// Create a copy of UpdateProjectRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateProjectRequestCopyWith<UpdateProjectRequest> get copyWith => _$UpdateProjectRequestCopyWithImpl<UpdateProjectRequest>(this as UpdateProjectRequest, _$identity);

  /// Serializes this UpdateProjectRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateProjectRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.defaultBillableRate, defaultBillableRate) || other.defaultBillableRate == defaultBillableRate)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,status,budgetAmount,defaultBillableRate,startDate,endDate);

@override
String toString() {
  return 'UpdateProjectRequest(name: $name, description: $description, status: $status, budgetAmount: $budgetAmount, defaultBillableRate: $defaultBillableRate, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $UpdateProjectRequestCopyWith<$Res>  {
  factory $UpdateProjectRequestCopyWith(UpdateProjectRequest value, $Res Function(UpdateProjectRequest) _then) = _$UpdateProjectRequestCopyWithImpl;
@useResult
$Res call({
 String name, String? description, String status, double? budgetAmount, double? defaultBillableRate,@NullableDateOnlyConverter() DateTime? startDate,@NullableDateOnlyConverter() DateTime? endDate
});




}
/// @nodoc
class _$UpdateProjectRequestCopyWithImpl<$Res>
    implements $UpdateProjectRequestCopyWith<$Res> {
  _$UpdateProjectRequestCopyWithImpl(this._self, this._then);

  final UpdateProjectRequest _self;
  final $Res Function(UpdateProjectRequest) _then;

/// Create a copy of UpdateProjectRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,Object? status = null,Object? budgetAmount = freezed,Object? defaultBillableRate = freezed,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,budgetAmount: freezed == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as double?,defaultBillableRate: freezed == defaultBillableRate ? _self.defaultBillableRate : defaultBillableRate // ignore: cast_nullable_to_non_nullable
as double?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateProjectRequest].
extension UpdateProjectRequestPatterns on UpdateProjectRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateProjectRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateProjectRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateProjectRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateProjectRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateProjectRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description,  String status,  double? budgetAmount,  double? defaultBillableRate, @NullableDateOnlyConverter()  DateTime? startDate, @NullableDateOnlyConverter()  DateTime? endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateProjectRequest() when $default != null:
return $default(_that.name,_that.description,_that.status,_that.budgetAmount,_that.defaultBillableRate,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description,  String status,  double? budgetAmount,  double? defaultBillableRate, @NullableDateOnlyConverter()  DateTime? startDate, @NullableDateOnlyConverter()  DateTime? endDate)  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectRequest():
return $default(_that.name,_that.description,_that.status,_that.budgetAmount,_that.defaultBillableRate,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description,  String status,  double? budgetAmount,  double? defaultBillableRate, @NullableDateOnlyConverter()  DateTime? startDate, @NullableDateOnlyConverter()  DateTime? endDate)?  $default,) {final _that = this;
switch (_that) {
case _UpdateProjectRequest() when $default != null:
return $default(_that.name,_that.description,_that.status,_that.budgetAmount,_that.defaultBillableRate,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateProjectRequest implements UpdateProjectRequest {
  const _UpdateProjectRequest({required this.name, this.description, required this.status, this.budgetAmount, this.defaultBillableRate, @NullableDateOnlyConverter() this.startDate, @NullableDateOnlyConverter() this.endDate});
  factory _UpdateProjectRequest.fromJson(Map<String, dynamic> json) => _$UpdateProjectRequestFromJson(json);

@override final  String name;
@override final  String? description;
@override final  String status;
@override final  double? budgetAmount;
@override final  double? defaultBillableRate;
@override@NullableDateOnlyConverter() final  DateTime? startDate;
@override@NullableDateOnlyConverter() final  DateTime? endDate;

/// Create a copy of UpdateProjectRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateProjectRequestCopyWith<_UpdateProjectRequest> get copyWith => __$UpdateProjectRequestCopyWithImpl<_UpdateProjectRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateProjectRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateProjectRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.defaultBillableRate, defaultBillableRate) || other.defaultBillableRate == defaultBillableRate)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,description,status,budgetAmount,defaultBillableRate,startDate,endDate);

@override
String toString() {
  return 'UpdateProjectRequest(name: $name, description: $description, status: $status, budgetAmount: $budgetAmount, defaultBillableRate: $defaultBillableRate, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$UpdateProjectRequestCopyWith<$Res> implements $UpdateProjectRequestCopyWith<$Res> {
  factory _$UpdateProjectRequestCopyWith(_UpdateProjectRequest value, $Res Function(_UpdateProjectRequest) _then) = __$UpdateProjectRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description, String status, double? budgetAmount, double? defaultBillableRate,@NullableDateOnlyConverter() DateTime? startDate,@NullableDateOnlyConverter() DateTime? endDate
});




}
/// @nodoc
class __$UpdateProjectRequestCopyWithImpl<$Res>
    implements _$UpdateProjectRequestCopyWith<$Res> {
  __$UpdateProjectRequestCopyWithImpl(this._self, this._then);

  final _UpdateProjectRequest _self;
  final $Res Function(_UpdateProjectRequest) _then;

/// Create a copy of UpdateProjectRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,Object? status = null,Object? budgetAmount = freezed,Object? defaultBillableRate = freezed,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_UpdateProjectRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,budgetAmount: freezed == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as double?,defaultBillableRate: freezed == defaultBillableRate ? _self.defaultBillableRate : defaultBillableRate // ignore: cast_nullable_to_non_nullable
as double?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
