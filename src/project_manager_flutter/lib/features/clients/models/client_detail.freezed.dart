// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ClientDetail {

 String get id; String get name; String? get address; String? get website; bool get isActive; DateTime get createdAt; double? get defaultBillableRate; double? get inheritedBillableRate; List<ClientContact> get contacts;
/// Create a copy of ClientDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClientDetailCopyWith<ClientDetail> get copyWith => _$ClientDetailCopyWithImpl<ClientDetail>(this as ClientDetail, _$identity);

  /// Serializes this ClientDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClientDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.website, website) || other.website == website)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.defaultBillableRate, defaultBillableRate) || other.defaultBillableRate == defaultBillableRate)&&(identical(other.inheritedBillableRate, inheritedBillableRate) || other.inheritedBillableRate == inheritedBillableRate)&&const DeepCollectionEquality().equals(other.contacts, contacts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,website,isActive,createdAt,defaultBillableRate,inheritedBillableRate,const DeepCollectionEquality().hash(contacts));

@override
String toString() {
  return 'ClientDetail(id: $id, name: $name, address: $address, website: $website, isActive: $isActive, createdAt: $createdAt, defaultBillableRate: $defaultBillableRate, inheritedBillableRate: $inheritedBillableRate, contacts: $contacts)';
}


}

/// @nodoc
abstract mixin class $ClientDetailCopyWith<$Res>  {
  factory $ClientDetailCopyWith(ClientDetail value, $Res Function(ClientDetail) _then) = _$ClientDetailCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? address, String? website, bool isActive, DateTime createdAt, double? defaultBillableRate, double? inheritedBillableRate, List<ClientContact> contacts
});




}
/// @nodoc
class _$ClientDetailCopyWithImpl<$Res>
    implements $ClientDetailCopyWith<$Res> {
  _$ClientDetailCopyWithImpl(this._self, this._then);

  final ClientDetail _self;
  final $Res Function(ClientDetail) _then;

/// Create a copy of ClientDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? website = freezed,Object? isActive = null,Object? createdAt = null,Object? defaultBillableRate = freezed,Object? inheritedBillableRate = freezed,Object? contacts = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,defaultBillableRate: freezed == defaultBillableRate ? _self.defaultBillableRate : defaultBillableRate // ignore: cast_nullable_to_non_nullable
as double?,inheritedBillableRate: freezed == inheritedBillableRate ? _self.inheritedBillableRate : inheritedBillableRate // ignore: cast_nullable_to_non_nullable
as double?,contacts: null == contacts ? _self.contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<ClientContact>,
  ));
}

}


/// Adds pattern-matching-related methods to [ClientDetail].
extension ClientDetailPatterns on ClientDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ClientDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ClientDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ClientDetail value)  $default,){
final _that = this;
switch (_that) {
case _ClientDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ClientDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ClientDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? address,  String? website,  bool isActive,  DateTime createdAt,  double? defaultBillableRate,  double? inheritedBillableRate,  List<ClientContact> contacts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ClientDetail() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.website,_that.isActive,_that.createdAt,_that.defaultBillableRate,_that.inheritedBillableRate,_that.contacts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? address,  String? website,  bool isActive,  DateTime createdAt,  double? defaultBillableRate,  double? inheritedBillableRate,  List<ClientContact> contacts)  $default,) {final _that = this;
switch (_that) {
case _ClientDetail():
return $default(_that.id,_that.name,_that.address,_that.website,_that.isActive,_that.createdAt,_that.defaultBillableRate,_that.inheritedBillableRate,_that.contacts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? address,  String? website,  bool isActive,  DateTime createdAt,  double? defaultBillableRate,  double? inheritedBillableRate,  List<ClientContact> contacts)?  $default,) {final _that = this;
switch (_that) {
case _ClientDetail() when $default != null:
return $default(_that.id,_that.name,_that.address,_that.website,_that.isActive,_that.createdAt,_that.defaultBillableRate,_that.inheritedBillableRate,_that.contacts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ClientDetail implements ClientDetail {
  const _ClientDetail({required this.id, required this.name, this.address, this.website, required this.isActive, required this.createdAt, this.defaultBillableRate, this.inheritedBillableRate, final  List<ClientContact> contacts = const []}): _contacts = contacts;
  factory _ClientDetail.fromJson(Map<String, dynamic> json) => _$ClientDetailFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? address;
@override final  String? website;
@override final  bool isActive;
@override final  DateTime createdAt;
@override final  double? defaultBillableRate;
@override final  double? inheritedBillableRate;
 final  List<ClientContact> _contacts;
@override@JsonKey() List<ClientContact> get contacts {
  if (_contacts is EqualUnmodifiableListView) return _contacts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contacts);
}


/// Create a copy of ClientDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClientDetailCopyWith<_ClientDetail> get copyWith => __$ClientDetailCopyWithImpl<_ClientDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClientDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ClientDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.address, address) || other.address == address)&&(identical(other.website, website) || other.website == website)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.defaultBillableRate, defaultBillableRate) || other.defaultBillableRate == defaultBillableRate)&&(identical(other.inheritedBillableRate, inheritedBillableRate) || other.inheritedBillableRate == inheritedBillableRate)&&const DeepCollectionEquality().equals(other._contacts, _contacts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,address,website,isActive,createdAt,defaultBillableRate,inheritedBillableRate,const DeepCollectionEquality().hash(_contacts));

@override
String toString() {
  return 'ClientDetail(id: $id, name: $name, address: $address, website: $website, isActive: $isActive, createdAt: $createdAt, defaultBillableRate: $defaultBillableRate, inheritedBillableRate: $inheritedBillableRate, contacts: $contacts)';
}


}

/// @nodoc
abstract mixin class _$ClientDetailCopyWith<$Res> implements $ClientDetailCopyWith<$Res> {
  factory _$ClientDetailCopyWith(_ClientDetail value, $Res Function(_ClientDetail) _then) = __$ClientDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? address, String? website, bool isActive, DateTime createdAt, double? defaultBillableRate, double? inheritedBillableRate, List<ClientContact> contacts
});




}
/// @nodoc
class __$ClientDetailCopyWithImpl<$Res>
    implements _$ClientDetailCopyWith<$Res> {
  __$ClientDetailCopyWithImpl(this._self, this._then);

  final _ClientDetail _self;
  final $Res Function(_ClientDetail) _then;

/// Create a copy of ClientDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? address = freezed,Object? website = freezed,Object? isActive = null,Object? createdAt = null,Object? defaultBillableRate = freezed,Object? inheritedBillableRate = freezed,Object? contacts = null,}) {
  return _then(_ClientDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,website: freezed == website ? _self.website : website // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,defaultBillableRate: freezed == defaultBillableRate ? _self.defaultBillableRate : defaultBillableRate // ignore: cast_nullable_to_non_nullable
as double?,inheritedBillableRate: freezed == inheritedBillableRate ? _self.inheritedBillableRate : inheritedBillableRate // ignore: cast_nullable_to_non_nullable
as double?,contacts: null == contacts ? _self._contacts : contacts // ignore: cast_nullable_to_non_nullable
as List<ClientContact>,
  ));
}


}

// dart format on
