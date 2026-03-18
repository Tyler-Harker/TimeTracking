// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_client_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateClientRequest {

 String get name; String? get address; String? get website; double? get defaultBillableRate;
/// Create a copy of UpdateClientRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateClientRequestCopyWith<UpdateClientRequest> get copyWith => _$UpdateClientRequestCopyWithImpl<UpdateClientRequest>(this as UpdateClientRequest, _$identity);

  /// Serializes this UpdateClientRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateClientRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.website, website) || other.website == website)&&(identical(other.defaultBillableRate, defaultBillableRate) || other.defaultBillableRate == defaultBillableRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,website,defaultBillableRate);

@override
String toString() {
  return 'UpdateClientRequest(name: $name, address: $address, website: $website, defaultBillableRate: $defaultBillableRate)';
}


}

/// @nodoc
abstract mixin class $UpdateClientRequestCopyWith<$Res>  {
  factory $UpdateClientRequestCopyWith(UpdateClientRequest value, $Res Function(UpdateClientRequest) _then) = _$UpdateClientRequestCopyWithImpl;
@useResult
$Res call({
 String name, String? address, String? website, double? defaultBillableRate
});




}
/// @nodoc
class _$UpdateClientRequestCopyWithImpl<$Res>
    implements $UpdateClientRequestCopyWith<$Res> {
  _$UpdateClientRequestCopyWithImpl(this._self, this._then);

  final UpdateClientRequest _self;
  final $Res Function(UpdateClientRequest) _then;

/// Create a copy of UpdateClientRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? address = freezed,Object? website = freezed,Object? defaultBillableRate = freezed,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,defaultBillableRate: freezed == defaultBillableRate ? _self.defaultBillableRate : defaultBillableRate // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateClientRequest].
extension UpdateClientRequestPatterns on UpdateClientRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateClientRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateClientRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateClientRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateClientRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateClientRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateClientRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? address,  String? website,  double? defaultBillableRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateClientRequest() when $default != null:
return $default(_that.name,_that.address,_that.website,_that.defaultBillableRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? address,  String? website,  double? defaultBillableRate)  $default,) {final _that = this;
switch (_that) {
case _UpdateClientRequest():
return $default(_that.name,_that.address,_that.website,_that.defaultBillableRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? address,  String? website,  double? defaultBillableRate)?  $default,) {final _that = this;
switch (_that) {
case _UpdateClientRequest() when $default != null:
return $default(_that.name,_that.address,_that.website,_that.defaultBillableRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateClientRequest implements UpdateClientRequest {
  const _UpdateClientRequest({required this.name, this.address, this.website, this.defaultBillableRate});
  factory _UpdateClientRequest.fromJson(Map<String, dynamic> json) => _$UpdateClientRequestFromJson(json);

@override final  String name;
@override final  String? address;
@override final  String? website;
@override final  double? defaultBillableRate;

/// Create a copy of UpdateClientRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateClientRequestCopyWith<_UpdateClientRequest> get copyWith => __$UpdateClientRequestCopyWithImpl<_UpdateClientRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateClientRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateClientRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.website, website) || other.website == website)&&(identical(other.defaultBillableRate, defaultBillableRate) || other.defaultBillableRate == defaultBillableRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,address,website,defaultBillableRate);

@override
String toString() {
  return 'UpdateClientRequest(name: $name, address: $address, website: $website, defaultBillableRate: $defaultBillableRate)';
}


}

/// @nodoc
abstract mixin class _$UpdateClientRequestCopyWith<$Res> implements $UpdateClientRequestCopyWith<$Res> {
  factory _$UpdateClientRequestCopyWith(_UpdateClientRequest value, $Res Function(_UpdateClientRequest) _then) = __$UpdateClientRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String? address, String? website, double? defaultBillableRate
});




}
/// @nodoc
class __$UpdateClientRequestCopyWithImpl<$Res>
    implements _$UpdateClientRequestCopyWith<$Res> {
  __$UpdateClientRequestCopyWithImpl(this._self, this._then);

  final _UpdateClientRequest _self;
  final $Res Function(_UpdateClientRequest) _then;

/// Create a copy of UpdateClientRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? address = freezed,Object? website = freezed,Object? defaultBillableRate = freezed,}) {
  return _then(_UpdateClientRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,defaultBillableRate: freezed == defaultBillableRate ? _self.defaultBillableRate : defaultBillableRate // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
