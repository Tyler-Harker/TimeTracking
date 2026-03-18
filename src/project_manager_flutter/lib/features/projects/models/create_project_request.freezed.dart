// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_project_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateProjectRequest {

 String get clientId; String get name; String? get description; double? get budgetAmount; double? get defaultBillableRate;@NullableDateOnlyConverter() DateTime? get startDate;@NullableDateOnlyConverter() DateTime? get endDate;
/// Create a copy of CreateProjectRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateProjectRequestCopyWith<CreateProjectRequest> get copyWith => _$CreateProjectRequestCopyWithImpl<CreateProjectRequest>(this as CreateProjectRequest, _$identity);

  /// Serializes this CreateProjectRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateProjectRequest&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.defaultBillableRate, defaultBillableRate) || other.defaultBillableRate == defaultBillableRate)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clientId,name,description,budgetAmount,defaultBillableRate,startDate,endDate);

@override
String toString() {
  return 'CreateProjectRequest(clientId: $clientId, name: $name, description: $description, budgetAmount: $budgetAmount, defaultBillableRate: $defaultBillableRate, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $CreateProjectRequestCopyWith<$Res>  {
  factory $CreateProjectRequestCopyWith(CreateProjectRequest value, $Res Function(CreateProjectRequest) _then) = _$CreateProjectRequestCopyWithImpl;
@useResult
$Res call({
 String clientId, String name, String? description, double? budgetAmount, double? defaultBillableRate,@NullableDateOnlyConverter() DateTime? startDate,@NullableDateOnlyConverter() DateTime? endDate
});




}
/// @nodoc
class _$CreateProjectRequestCopyWithImpl<$Res>
    implements $CreateProjectRequestCopyWith<$Res> {
  _$CreateProjectRequestCopyWithImpl(this._self, this._then);

  final CreateProjectRequest _self;
  final $Res Function(CreateProjectRequest) _then;

/// Create a copy of CreateProjectRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientId = null,Object? name = null,Object? description = freezed,Object? budgetAmount = freezed,Object? defaultBillableRate = freezed,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_self.copyWith(
clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,budgetAmount: freezed == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as double?,defaultBillableRate: freezed == defaultBillableRate ? _self.defaultBillableRate : defaultBillableRate // ignore: cast_nullable_to_non_nullable
as double?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateProjectRequest].
extension CreateProjectRequestPatterns on CreateProjectRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateProjectRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateProjectRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateProjectRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateProjectRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateProjectRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateProjectRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String clientId,  String name,  String? description,  double? budgetAmount,  double? defaultBillableRate, @NullableDateOnlyConverter()  DateTime? startDate, @NullableDateOnlyConverter()  DateTime? endDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateProjectRequest() when $default != null:
return $default(_that.clientId,_that.name,_that.description,_that.budgetAmount,_that.defaultBillableRate,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String clientId,  String name,  String? description,  double? budgetAmount,  double? defaultBillableRate, @NullableDateOnlyConverter()  DateTime? startDate, @NullableDateOnlyConverter()  DateTime? endDate)  $default,) {final _that = this;
switch (_that) {
case _CreateProjectRequest():
return $default(_that.clientId,_that.name,_that.description,_that.budgetAmount,_that.defaultBillableRate,_that.startDate,_that.endDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String clientId,  String name,  String? description,  double? budgetAmount,  double? defaultBillableRate, @NullableDateOnlyConverter()  DateTime? startDate, @NullableDateOnlyConverter()  DateTime? endDate)?  $default,) {final _that = this;
switch (_that) {
case _CreateProjectRequest() when $default != null:
return $default(_that.clientId,_that.name,_that.description,_that.budgetAmount,_that.defaultBillableRate,_that.startDate,_that.endDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateProjectRequest implements CreateProjectRequest {
  const _CreateProjectRequest({required this.clientId, required this.name, this.description, this.budgetAmount, this.defaultBillableRate, @NullableDateOnlyConverter() this.startDate, @NullableDateOnlyConverter() this.endDate});
  factory _CreateProjectRequest.fromJson(Map<String, dynamic> json) => _$CreateProjectRequestFromJson(json);

@override final  String clientId;
@override final  String name;
@override final  String? description;
@override final  double? budgetAmount;
@override final  double? defaultBillableRate;
@override@NullableDateOnlyConverter() final  DateTime? startDate;
@override@NullableDateOnlyConverter() final  DateTime? endDate;

/// Create a copy of CreateProjectRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateProjectRequestCopyWith<_CreateProjectRequest> get copyWith => __$CreateProjectRequestCopyWithImpl<_CreateProjectRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateProjectRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateProjectRequest&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.defaultBillableRate, defaultBillableRate) || other.defaultBillableRate == defaultBillableRate)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clientId,name,description,budgetAmount,defaultBillableRate,startDate,endDate);

@override
String toString() {
  return 'CreateProjectRequest(clientId: $clientId, name: $name, description: $description, budgetAmount: $budgetAmount, defaultBillableRate: $defaultBillableRate, startDate: $startDate, endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class _$CreateProjectRequestCopyWith<$Res> implements $CreateProjectRequestCopyWith<$Res> {
  factory _$CreateProjectRequestCopyWith(_CreateProjectRequest value, $Res Function(_CreateProjectRequest) _then) = __$CreateProjectRequestCopyWithImpl;
@override @useResult
$Res call({
 String clientId, String name, String? description, double? budgetAmount, double? defaultBillableRate,@NullableDateOnlyConverter() DateTime? startDate,@NullableDateOnlyConverter() DateTime? endDate
});




}
/// @nodoc
class __$CreateProjectRequestCopyWithImpl<$Res>
    implements _$CreateProjectRequestCopyWith<$Res> {
  __$CreateProjectRequestCopyWithImpl(this._self, this._then);

  final _CreateProjectRequest _self;
  final $Res Function(_CreateProjectRequest) _then;

/// Create a copy of CreateProjectRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientId = null,Object? name = null,Object? description = freezed,Object? budgetAmount = freezed,Object? defaultBillableRate = freezed,Object? startDate = freezed,Object? endDate = freezed,}) {
  return _then(_CreateProjectRequest(
clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,budgetAmount: freezed == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as double?,defaultBillableRate: freezed == defaultBillableRate ? _self.defaultBillableRate : defaultBillableRate // ignore: cast_nullable_to_non_nullable
as double?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
