// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'team_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TeamDetail {

 String get id; String get projectId; String get name; String? get description; DateTime get createdAt; List<TeamMember> get members;
/// Create a copy of TeamDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TeamDetailCopyWith<TeamDetail> get copyWith => _$TeamDetailCopyWithImpl<TeamDetail>(this as TeamDetail, _$identity);

  /// Serializes this TeamDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TeamDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.members, members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,name,description,createdAt,const DeepCollectionEquality().hash(members));

@override
String toString() {
  return 'TeamDetail(id: $id, projectId: $projectId, name: $name, description: $description, createdAt: $createdAt, members: $members)';
}


}

/// @nodoc
abstract mixin class $TeamDetailCopyWith<$Res>  {
  factory $TeamDetailCopyWith(TeamDetail value, $Res Function(TeamDetail) _then) = _$TeamDetailCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, String name, String? description, DateTime createdAt, List<TeamMember> members
});




}
/// @nodoc
class _$TeamDetailCopyWithImpl<$Res>
    implements $TeamDetailCopyWith<$Res> {
  _$TeamDetailCopyWithImpl(this._self, this._then);

  final TeamDetail _self;
  final $Res Function(TeamDetail) _then;

/// Create a copy of TeamDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? name = null,Object? description = freezed,Object? createdAt = null,Object? members = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,members: null == members ? _self.members : members // ignore: cast_nullable_to_non_nullable
as List<TeamMember>,
  ));
}

}


/// Adds pattern-matching-related methods to [TeamDetail].
extension TeamDetailPatterns on TeamDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TeamDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TeamDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TeamDetail value)  $default,){
final _that = this;
switch (_that) {
case _TeamDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TeamDetail value)?  $default,){
final _that = this;
switch (_that) {
case _TeamDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  String name,  String? description,  DateTime createdAt,  List<TeamMember> members)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TeamDetail() when $default != null:
return $default(_that.id,_that.projectId,_that.name,_that.description,_that.createdAt,_that.members);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  String name,  String? description,  DateTime createdAt,  List<TeamMember> members)  $default,) {final _that = this;
switch (_that) {
case _TeamDetail():
return $default(_that.id,_that.projectId,_that.name,_that.description,_that.createdAt,_that.members);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  String name,  String? description,  DateTime createdAt,  List<TeamMember> members)?  $default,) {final _that = this;
switch (_that) {
case _TeamDetail() when $default != null:
return $default(_that.id,_that.projectId,_that.name,_that.description,_that.createdAt,_that.members);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TeamDetail implements TeamDetail {
  const _TeamDetail({required this.id, required this.projectId, required this.name, this.description, required this.createdAt, final  List<TeamMember> members = const []}): _members = members;
  factory _TeamDetail.fromJson(Map<String, dynamic> json) => _$TeamDetailFromJson(json);

@override final  String id;
@override final  String projectId;
@override final  String name;
@override final  String? description;
@override final  DateTime createdAt;
 final  List<TeamMember> _members;
@override@JsonKey() List<TeamMember> get members {
  if (_members is EqualUnmodifiableListView) return _members;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_members);
}


/// Create a copy of TeamDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TeamDetailCopyWith<_TeamDetail> get copyWith => __$TeamDetailCopyWithImpl<_TeamDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TeamDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TeamDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._members, _members));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,name,description,createdAt,const DeepCollectionEquality().hash(_members));

@override
String toString() {
  return 'TeamDetail(id: $id, projectId: $projectId, name: $name, description: $description, createdAt: $createdAt, members: $members)';
}


}

/// @nodoc
abstract mixin class _$TeamDetailCopyWith<$Res> implements $TeamDetailCopyWith<$Res> {
  factory _$TeamDetailCopyWith(_TeamDetail value, $Res Function(_TeamDetail) _then) = __$TeamDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, String name, String? description, DateTime createdAt, List<TeamMember> members
});




}
/// @nodoc
class __$TeamDetailCopyWithImpl<$Res>
    implements _$TeamDetailCopyWith<$Res> {
  __$TeamDetailCopyWithImpl(this._self, this._then);

  final _TeamDetail _self;
  final $Res Function(_TeamDetail) _then;

/// Create a copy of TeamDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? name = null,Object? description = freezed,Object? createdAt = null,Object? members = null,}) {
  return _then(_TeamDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,members: null == members ? _self._members : members // ignore: cast_nullable_to_non_nullable
as List<TeamMember>,
  ));
}


}

// dart format on
