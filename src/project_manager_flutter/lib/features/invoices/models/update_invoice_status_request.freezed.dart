// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_invoice_status_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateInvoiceStatusRequest {

 String get status;
/// Create a copy of UpdateInvoiceStatusRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateInvoiceStatusRequestCopyWith<UpdateInvoiceStatusRequest> get copyWith => _$UpdateInvoiceStatusRequestCopyWithImpl<UpdateInvoiceStatusRequest>(this as UpdateInvoiceStatusRequest, _$identity);

  /// Serializes this UpdateInvoiceStatusRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateInvoiceStatusRequest&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'UpdateInvoiceStatusRequest(status: $status)';
}


}

/// @nodoc
abstract mixin class $UpdateInvoiceStatusRequestCopyWith<$Res>  {
  factory $UpdateInvoiceStatusRequestCopyWith(UpdateInvoiceStatusRequest value, $Res Function(UpdateInvoiceStatusRequest) _then) = _$UpdateInvoiceStatusRequestCopyWithImpl;
@useResult
$Res call({
 String status
});




}
/// @nodoc
class _$UpdateInvoiceStatusRequestCopyWithImpl<$Res>
    implements $UpdateInvoiceStatusRequestCopyWith<$Res> {
  _$UpdateInvoiceStatusRequestCopyWithImpl(this._self, this._then);

  final UpdateInvoiceStatusRequest _self;
  final $Res Function(UpdateInvoiceStatusRequest) _then;

/// Create a copy of UpdateInvoiceStatusRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateInvoiceStatusRequest].
extension UpdateInvoiceStatusRequestPatterns on UpdateInvoiceStatusRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateInvoiceStatusRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateInvoiceStatusRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateInvoiceStatusRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateInvoiceStatusRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateInvoiceStatusRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateInvoiceStatusRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateInvoiceStatusRequest() when $default != null:
return $default(_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status)  $default,) {final _that = this;
switch (_that) {
case _UpdateInvoiceStatusRequest():
return $default(_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status)?  $default,) {final _that = this;
switch (_that) {
case _UpdateInvoiceStatusRequest() when $default != null:
return $default(_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateInvoiceStatusRequest implements UpdateInvoiceStatusRequest {
  const _UpdateInvoiceStatusRequest({required this.status});
  factory _UpdateInvoiceStatusRequest.fromJson(Map<String, dynamic> json) => _$UpdateInvoiceStatusRequestFromJson(json);

@override final  String status;

/// Create a copy of UpdateInvoiceStatusRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateInvoiceStatusRequestCopyWith<_UpdateInvoiceStatusRequest> get copyWith => __$UpdateInvoiceStatusRequestCopyWithImpl<_UpdateInvoiceStatusRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateInvoiceStatusRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateInvoiceStatusRequest&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status);

@override
String toString() {
  return 'UpdateInvoiceStatusRequest(status: $status)';
}


}

/// @nodoc
abstract mixin class _$UpdateInvoiceStatusRequestCopyWith<$Res> implements $UpdateInvoiceStatusRequestCopyWith<$Res> {
  factory _$UpdateInvoiceStatusRequestCopyWith(_UpdateInvoiceStatusRequest value, $Res Function(_UpdateInvoiceStatusRequest) _then) = __$UpdateInvoiceStatusRequestCopyWithImpl;
@override @useResult
$Res call({
 String status
});




}
/// @nodoc
class __$UpdateInvoiceStatusRequestCopyWithImpl<$Res>
    implements _$UpdateInvoiceStatusRequestCopyWith<$Res> {
  __$UpdateInvoiceStatusRequestCopyWithImpl(this._self, this._then);

  final _UpdateInvoiceStatusRequest _self;
  final $Res Function(_UpdateInvoiceStatusRequest) _then;

/// Create a copy of UpdateInvoiceStatusRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,}) {
  return _then(_UpdateInvoiceStatusRequest(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
