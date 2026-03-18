// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Client {

 String get id; String get name; int get contactCount; bool get isActive; double? get defaultBillableRate;
/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientCopyWith<Client> get copyWith => _$ClientCopyWithImpl<Client>(this as Client, _$identity);

  /// Serializes this Client to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Client&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.contactCount, contactCount) || other.contactCount == contactCount)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.defaultBillableRate, defaultBillableRate) || other.defaultBillableRate == defaultBillableRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,contactCount,isActive,defaultBillableRate);

@override
String toString() {
  return 'Client(id: $id, name: $name, contactCount: $contactCount, isActive: $isActive, defaultBillableRate: $defaultBillableRate)';
}


}

/// @nodoc
abstract mixin class $ClientCopyWith<$Res>  {
  factory $ClientCopyWith(Client value, $Res Function(Client) _then) = _$ClientCopyWithImpl;
@useResult
$Res call({
 String id, String name, int contactCount, bool isActive, double? defaultBillableRate
});




}
/// @nodoc
class _$ClientCopyWithImpl<$Res>
    implements $ClientCopyWith<$Res> {
  _$ClientCopyWithImpl(this._self, this._then);

  final Client _self;
  final $Res Function(Client) _then;

/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? contactCount = null,Object? isActive = null,Object? defaultBillableRate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contactCount: null == contactCount ? _self.contactCount : contactCount // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,defaultBillableRate: freezed == defaultBillableRate ? _self.defaultBillableRate : defaultBillableRate // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [Client].
extension ClientPatterns on Client {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Client value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Client() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Client value)  $default,){
final _that = this;
switch (_that) {
case _Client():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Client value)?  $default,){
final _that = this;
switch (_that) {
case _Client() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int contactCount,  bool isActive,  double? defaultBillableRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Client() when $default != null:
return $default(_that.id,_that.name,_that.contactCount,_that.isActive,_that.defaultBillableRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int contactCount,  bool isActive,  double? defaultBillableRate)  $default,) {final _that = this;
switch (_that) {
case _Client():
return $default(_that.id,_that.name,_that.contactCount,_that.isActive,_that.defaultBillableRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int contactCount,  bool isActive,  double? defaultBillableRate)?  $default,) {final _that = this;
switch (_that) {
case _Client() when $default != null:
return $default(_that.id,_that.name,_that.contactCount,_that.isActive,_that.defaultBillableRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Client implements Client {
  const _Client({required this.id, required this.name, required this.contactCount, required this.isActive, this.defaultBillableRate});
  factory _Client.fromJson(Map<String, dynamic> json) => _$ClientFromJson(json);

@override final  String id;
@override final  String name;
@override final  int contactCount;
@override final  bool isActive;
@override final  double? defaultBillableRate;

/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientCopyWith<_Client> get copyWith => __$ClientCopyWithImpl<_Client>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Client&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.contactCount, contactCount) || other.contactCount == contactCount)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.defaultBillableRate, defaultBillableRate) || other.defaultBillableRate == defaultBillableRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,contactCount,isActive,defaultBillableRate);

@override
String toString() {
  return 'Client(id: $id, name: $name, contactCount: $contactCount, isActive: $isActive, defaultBillableRate: $defaultBillableRate)';
}


}

/// @nodoc
abstract mixin class _$ClientCopyWith<$Res> implements $ClientCopyWith<$Res> {
  factory _$ClientCopyWith(_Client value, $Res Function(_Client) _then) = __$ClientCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int contactCount, bool isActive, double? defaultBillableRate
});




}
/// @nodoc
class __$ClientCopyWithImpl<$Res>
    implements _$ClientCopyWith<$Res> {
  __$ClientCopyWithImpl(this._self, this._then);

  final _Client _self;
  final $Res Function(_Client) _then;

/// Create a copy of Client
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? contactCount = null,Object? isActive = null,Object? defaultBillableRate = freezed,}) {
  return _then(_Client(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contactCount: null == contactCount ? _self.contactCount : contactCount // ignore: cast_nullable_to_non_nullable
as int,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,defaultBillableRate: freezed == defaultBillableRate ? _self.defaultBillableRate : defaultBillableRate // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
