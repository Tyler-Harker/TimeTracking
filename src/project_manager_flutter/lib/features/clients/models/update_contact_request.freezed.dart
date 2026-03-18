// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'update_contact_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UpdateContactRequest {

 String get name; String? get email; String? get phone; bool get isStakeHolder; bool get isInvoicing;
/// Create a copy of UpdateContactRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateContactRequestCopyWith<UpdateContactRequest> get copyWith => _$UpdateContactRequestCopyWithImpl<UpdateContactRequest>(this as UpdateContactRequest, _$identity);

  /// Serializes this UpdateContactRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateContactRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isStakeHolder, isStakeHolder) || other.isStakeHolder == isStakeHolder)&&(identical(other.isInvoicing, isInvoicing) || other.isInvoicing == isInvoicing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email,phone,isStakeHolder,isInvoicing);

@override
String toString() {
  return 'UpdateContactRequest(name: $name, email: $email, phone: $phone, isStakeHolder: $isStakeHolder, isInvoicing: $isInvoicing)';
}


}

/// @nodoc
abstract mixin class $UpdateContactRequestCopyWith<$Res>  {
  factory $UpdateContactRequestCopyWith(UpdateContactRequest value, $Res Function(UpdateContactRequest) _then) = _$UpdateContactRequestCopyWithImpl;
@useResult
$Res call({
 String name, String? email, String? phone, bool isStakeHolder, bool isInvoicing
});




}
/// @nodoc
class _$UpdateContactRequestCopyWithImpl<$Res>
    implements $UpdateContactRequestCopyWith<$Res> {
  _$UpdateContactRequestCopyWithImpl(this._self, this._then);

  final UpdateContactRequest _self;
  final $Res Function(UpdateContactRequest) _then;

/// Create a copy of UpdateContactRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? email = freezed,Object? phone = freezed,Object? isStakeHolder = null,Object? isInvoicing = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,isStakeHolder: null == isStakeHolder ? _self.isStakeHolder : isStakeHolder // ignore: cast_nullable_to_non_nullable
as bool,isInvoicing: null == isInvoicing ? _self.isInvoicing : isInvoicing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [UpdateContactRequest].
extension UpdateContactRequestPatterns on UpdateContactRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UpdateContactRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UpdateContactRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UpdateContactRequest value)  $default,){
final _that = this;
switch (_that) {
case _UpdateContactRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UpdateContactRequest value)?  $default,){
final _that = this;
switch (_that) {
case _UpdateContactRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? email,  String? phone,  bool isStakeHolder,  bool isInvoicing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UpdateContactRequest() when $default != null:
return $default(_that.name,_that.email,_that.phone,_that.isStakeHolder,_that.isInvoicing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? email,  String? phone,  bool isStakeHolder,  bool isInvoicing)  $default,) {final _that = this;
switch (_that) {
case _UpdateContactRequest():
return $default(_that.name,_that.email,_that.phone,_that.isStakeHolder,_that.isInvoicing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? email,  String? phone,  bool isStakeHolder,  bool isInvoicing)?  $default,) {final _that = this;
switch (_that) {
case _UpdateContactRequest() when $default != null:
return $default(_that.name,_that.email,_that.phone,_that.isStakeHolder,_that.isInvoicing);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UpdateContactRequest implements UpdateContactRequest {
  const _UpdateContactRequest({required this.name, this.email, this.phone, this.isStakeHolder = false, this.isInvoicing = false});
  factory _UpdateContactRequest.fromJson(Map<String, dynamic> json) => _$UpdateContactRequestFromJson(json);

@override final  String name;
@override final  String? email;
@override final  String? phone;
@override@JsonKey() final  bool isStakeHolder;
@override@JsonKey() final  bool isInvoicing;

/// Create a copy of UpdateContactRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UpdateContactRequestCopyWith<_UpdateContactRequest> get copyWith => __$UpdateContactRequestCopyWithImpl<_UpdateContactRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UpdateContactRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UpdateContactRequest&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isStakeHolder, isStakeHolder) || other.isStakeHolder == isStakeHolder)&&(identical(other.isInvoicing, isInvoicing) || other.isInvoicing == isInvoicing));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,name,email,phone,isStakeHolder,isInvoicing);

@override
String toString() {
  return 'UpdateContactRequest(name: $name, email: $email, phone: $phone, isStakeHolder: $isStakeHolder, isInvoicing: $isInvoicing)';
}


}

/// @nodoc
abstract mixin class _$UpdateContactRequestCopyWith<$Res> implements $UpdateContactRequestCopyWith<$Res> {
  factory _$UpdateContactRequestCopyWith(_UpdateContactRequest value, $Res Function(_UpdateContactRequest) _then) = __$UpdateContactRequestCopyWithImpl;
@override @useResult
$Res call({
 String name, String? email, String? phone, bool isStakeHolder, bool isInvoicing
});




}
/// @nodoc
class __$UpdateContactRequestCopyWithImpl<$Res>
    implements _$UpdateContactRequestCopyWith<$Res> {
  __$UpdateContactRequestCopyWithImpl(this._self, this._then);

  final _UpdateContactRequest _self;
  final $Res Function(_UpdateContactRequest) _then;

/// Create a copy of UpdateContactRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = freezed,Object? phone = freezed,Object? isStakeHolder = null,Object? isInvoicing = null,}) {
  return _then(_UpdateContactRequest(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,isStakeHolder: null == isStakeHolder ? _self.isStakeHolder : isStakeHolder // ignore: cast_nullable_to_non_nullable
as bool,isInvoicing: null == isInvoicing ? _self.isInvoicing : isInvoicing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
