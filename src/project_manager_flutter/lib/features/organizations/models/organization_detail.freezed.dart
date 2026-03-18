// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'organization_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrganizationDetail {

 String get id; String get name; String get slug; String? get description; bool get isActive; DateTime get createdAt; double? get defaultBillableRate; List<OrganizationMember> get members;
/// Create a copy of OrganizationDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrganizationDetailCopyWith<OrganizationDetail> get copyWith => _$OrganizationDetailCopyWithImpl<OrganizationDetail>(this as OrganizationDetail, _$identity);

  /// Serializes this OrganizationDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrganizationDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.defaultBillableRate, defaultBillableRate) || other.defaultBillableRate == defaultBillableRate)&&const DeepCollectionEquality().equals(other.members, members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,description,isActive,createdAt,defaultBillableRate,const DeepCollectionEquality().hash(members));

@override
String toString() {
  return 'OrganizationDetail(id: $id, name: $name, slug: $slug, description: $description, isActive: $isActive, createdAt: $createdAt, defaultBillableRate: $defaultBillableRate, members: $members)';
}


}

/// @nodoc
abstract mixin class $OrganizationDetailCopyWith<$Res>  {
  factory $OrganizationDetailCopyWith(OrganizationDetail value, $Res Function(OrganizationDetail) _then) = _$OrganizationDetailCopyWithImpl;
@useResult
$Res call({
 String id, String name, String slug, String? description, bool isActive, DateTime createdAt, double? defaultBillableRate, List<OrganizationMember> members
});




}
/// @nodoc
class _$OrganizationDetailCopyWithImpl<$Res>
    implements $OrganizationDetailCopyWith<$Res> {
  _$OrganizationDetailCopyWithImpl(this._self, this._then);

  final OrganizationDetail _self;
  final $Res Function(OrganizationDetail) _then;

/// Create a copy of OrganizationDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? description = freezed,Object? isActive = null,Object? createdAt = null,Object? defaultBillableRate = freezed,Object? members = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,defaultBillableRate: freezed == defaultBillableRate ? _self.defaultBillableRate : defaultBillableRate // ignore: cast_nullable_to_non_nullable
as double?,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<OrganizationMember>,
  ));
}

}


/// Adds pattern-matching-related methods to [OrganizationDetail].
extension OrganizationDetailPatterns on OrganizationDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrganizationDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrganizationDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrganizationDetail value)  $default,){
final _that = this;
switch (_that) {
case _OrganizationDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrganizationDetail value)?  $default,){
final _that = this;
switch (_that) {
case _OrganizationDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String? description,  bool isActive,  DateTime createdAt,  double? defaultBillableRate,  List<OrganizationMember> members)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrganizationDetail() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.isActive,_that.createdAt,_that.defaultBillableRate,_that.members);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String slug,  String? description,  bool isActive,  DateTime createdAt,  double? defaultBillableRate,  List<OrganizationMember> members)  $default,) {final _that = this;
switch (_that) {
case _OrganizationDetail():
return $default(_that.id,_that.name,_that.slug,_that.description,_that.isActive,_that.createdAt,_that.defaultBillableRate,_that.members);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String slug,  String? description,  bool isActive,  DateTime createdAt,  double? defaultBillableRate,  List<OrganizationMember> members)?  $default,) {final _that = this;
switch (_that) {
case _OrganizationDetail() when $default != null:
return $default(_that.id,_that.name,_that.slug,_that.description,_that.isActive,_that.createdAt,_that.defaultBillableRate,_that.members);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrganizationDetail implements OrganizationDetail {
  const _OrganizationDetail({required this.id, required this.name, required this.slug, this.description, required this.isActive, required this.createdAt, this.defaultBillableRate, final  List<OrganizationMember> members = const []}): _members = members;
  factory _OrganizationDetail.fromJson(Map<String, dynamic> json) => _$OrganizationDetailFromJson(json);

@override final  String id;
@override final  String name;
@override final  String slug;
@override final  String? description;
@override final  bool isActive;
@override final  DateTime createdAt;
@override final  double? defaultBillableRate;
 final  List<OrganizationMember> _members;
@override@JsonKey() List<OrganizationMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}


/// Create a copy of OrganizationDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrganizationDetailCopyWith<_OrganizationDetail> get copyWith => __$OrganizationDetailCopyWithImpl<_OrganizationDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrganizationDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrganizationDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.slug, slug) || other.slug == slug)&&(identical(other.description, description) || other.description == description)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.defaultBillableRate, defaultBillableRate) || other.defaultBillableRate == defaultBillableRate)&&const DeepCollectionEquality().equals(other._members, _members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,slug,description,isActive,createdAt,defaultBillableRate,const DeepCollectionEquality().hash(_members));

@override
String toString() {
  return 'OrganizationDetail(id: $id, name: $name, slug: $slug, description: $description, isActive: $isActive, createdAt: $createdAt, defaultBillableRate: $defaultBillableRate, members: $members)';
}


}

/// @nodoc
abstract mixin class _$OrganizationDetailCopyWith<$Res> implements $OrganizationDetailCopyWith<$Res> {
  factory _$OrganizationDetailCopyWith(_OrganizationDetail value, $Res Function(_OrganizationDetail) _then) = __$OrganizationDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String slug, String? description, bool isActive, DateTime createdAt, double? defaultBillableRate, List<OrganizationMember> members
});




}
/// @nodoc
class __$OrganizationDetailCopyWithImpl<$Res>
    implements _$OrganizationDetailCopyWith<$Res> {
  __$OrganizationDetailCopyWithImpl(this._self, this._then);

  final _OrganizationDetail _self;
  final $Res Function(_OrganizationDetail) _then;

/// Create a copy of OrganizationDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? slug = null,Object? description = freezed,Object? isActive = null,Object? createdAt = null,Object? defaultBillableRate = freezed,Object? members = null,}) {
  return _then(_OrganizationDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,slug: null == slug ? _self.slug : slug // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,defaultBillableRate: freezed == defaultBillableRate ? _self.defaultBillableRate : defaultBillableRate // ignore: cast_nullable_to_non_nullable
as double?,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<OrganizationMember>,
  ));
}


}

// dart format on
