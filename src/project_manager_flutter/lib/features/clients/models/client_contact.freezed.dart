// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_contact.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClientContact {

 String get id; String get name; String? get email; String? get phone; bool get isStakeHolder; bool get isInvoicing; DateTime get createdAt;
/// Create a copy of ClientContact
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientContactCopyWith<ClientContact> get copyWith => _$ClientContactCopyWithImpl<ClientContact>(this as ClientContact, _$identity);

  /// Serializes this ClientContact to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientContact&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isStakeHolder, isStakeHolder) || other.isStakeHolder == isStakeHolder)&&(identical(other.isInvoicing, isInvoicing) || other.isInvoicing == isInvoicing)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,phone,isStakeHolder,isInvoicing,createdAt);

@override
String toString() {
  return 'ClientContact(id: $id, name: $name, email: $email, phone: $phone, isStakeHolder: $isStakeHolder, isInvoicing: $isInvoicing, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ClientContactCopyWith<$Res>  {
  factory $ClientContactCopyWith(ClientContact value, $Res Function(ClientContact) _then) = _$ClientContactCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? email, String? phone, bool isStakeHolder, bool isInvoicing, DateTime createdAt
});




}
/// @nodoc
class _$ClientContactCopyWithImpl<$Res>
    implements $ClientContactCopyWith<$Res> {
  _$ClientContactCopyWithImpl(this._self, this._then);

  final ClientContact _self;
  final $Res Function(ClientContact) _then;

/// Create a copy of ClientContact
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? email = freezed,Object? phone = freezed,Object? isStakeHolder = null,Object? isInvoicing = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,isStakeHolder: null == isStakeHolder ? _self.isStakeHolder : isStakeHolder // ignore: cast_nullable_to_non_nullable
as bool,isInvoicing: null == isInvoicing ? _self.isInvoicing : isInvoicing // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientContact].
extension ClientContactPatterns on ClientContact {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientContact value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientContact() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientContact value)  $default,){
final _that = this;
switch (_that) {
case _ClientContact():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientContact value)?  $default,){
final _that = this;
switch (_that) {
case _ClientContact() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? email,  String? phone,  bool isStakeHolder,  bool isInvoicing,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientContact() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.isStakeHolder,_that.isInvoicing,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? email,  String? phone,  bool isStakeHolder,  bool isInvoicing,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ClientContact():
return $default(_that.id,_that.name,_that.email,_that.phone,_that.isStakeHolder,_that.isInvoicing,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? email,  String? phone,  bool isStakeHolder,  bool isInvoicing,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ClientContact() when $default != null:
return $default(_that.id,_that.name,_that.email,_that.phone,_that.isStakeHolder,_that.isInvoicing,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClientContact implements ClientContact {
  const _ClientContact({required this.id, required this.name, this.email, this.phone, required this.isStakeHolder, required this.isInvoicing, required this.createdAt});
  factory _ClientContact.fromJson(Map<String, dynamic> json) => _$ClientContactFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? email;
@override final  String? phone;
@override final  bool isStakeHolder;
@override final  bool isInvoicing;
@override final  DateTime createdAt;

/// Create a copy of ClientContact
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientContactCopyWith<_ClientContact> get copyWith => __$ClientContactCopyWithImpl<_ClientContact>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientContactToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientContact&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.isStakeHolder, isStakeHolder) || other.isStakeHolder == isStakeHolder)&&(identical(other.isInvoicing, isInvoicing) || other.isInvoicing == isInvoicing)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,email,phone,isStakeHolder,isInvoicing,createdAt);

@override
String toString() {
  return 'ClientContact(id: $id, name: $name, email: $email, phone: $phone, isStakeHolder: $isStakeHolder, isInvoicing: $isInvoicing, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ClientContactCopyWith<$Res> implements $ClientContactCopyWith<$Res> {
  factory _$ClientContactCopyWith(_ClientContact value, $Res Function(_ClientContact) _then) = __$ClientContactCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? email, String? phone, bool isStakeHolder, bool isInvoicing, DateTime createdAt
});




}
/// @nodoc
class __$ClientContactCopyWithImpl<$Res>
    implements _$ClientContactCopyWith<$Res> {
  __$ClientContactCopyWithImpl(this._self, this._then);

  final _ClientContact _self;
  final $Res Function(_ClientContact) _then;

/// Create a copy of ClientContact
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? email = freezed,Object? phone = freezed,Object? isStakeHolder = null,Object? isInvoicing = null,Object? createdAt = null,}) {
  return _then(_ClientContact(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,isStakeHolder: null == isStakeHolder ? _self.isStakeHolder : isStakeHolder // ignore: cast_nullable_to_non_nullable
as bool,isInvoicing: null == isInvoicing ? _self.isInvoicing : isInvoicing // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
