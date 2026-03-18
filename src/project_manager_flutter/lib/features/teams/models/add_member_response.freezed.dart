// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_member_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddMemberResponse {

 String get teamId; String get userId; DateTime get joinedAt;
/// Create a copy of AddMemberResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddMemberResponseCopyWith<AddMemberResponse> get copyWith => _$AddMemberResponseCopyWithImpl<AddMemberResponse>(this as AddMemberResponse, _$identity);

  /// Serializes this AddMemberResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddMemberResponse&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,teamId,userId,joinedAt);

@override
String toString() {
  return 'AddMemberResponse(teamId: $teamId, userId: $userId, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class $AddMemberResponseCopyWith<$Res>  {
  factory $AddMemberResponseCopyWith(AddMemberResponse value, $Res Function(AddMemberResponse) _then) = _$AddMemberResponseCopyWithImpl;
@useResult
$Res call({
 String teamId, String userId, DateTime joinedAt
});




}
/// @nodoc
class _$AddMemberResponseCopyWithImpl<$Res>
    implements $AddMemberResponseCopyWith<$Res> {
  _$AddMemberResponseCopyWithImpl(this._self, this._then);

  final AddMemberResponse _self;
  final $Res Function(AddMemberResponse) _then;

/// Create a copy of AddMemberResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? teamId = null,Object? userId = null,Object? joinedAt = null,}) {
  return _then(_self.copyWith(
teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AddMemberResponse].
extension AddMemberResponsePatterns on AddMemberResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddMemberResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddMemberResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddMemberResponse value)  $default,){
final _that = this;
switch (_that) {
case _AddMemberResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddMemberResponse value)?  $default,){
final _that = this;
switch (_that) {
case _AddMemberResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String teamId,  String userId,  DateTime joinedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddMemberResponse() when $default != null:
return $default(_that.teamId,_that.userId,_that.joinedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String teamId,  String userId,  DateTime joinedAt)  $default,) {final _that = this;
switch (_that) {
case _AddMemberResponse():
return $default(_that.teamId,_that.userId,_that.joinedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String teamId,  String userId,  DateTime joinedAt)?  $default,) {final _that = this;
switch (_that) {
case _AddMemberResponse() when $default != null:
return $default(_that.teamId,_that.userId,_that.joinedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddMemberResponse implements AddMemberResponse {
  const _AddMemberResponse({required this.teamId, required this.userId, required this.joinedAt});
  factory _AddMemberResponse.fromJson(Map<String, dynamic> json) => _$AddMemberResponseFromJson(json);

@override final  String teamId;
@override final  String userId;
@override final  DateTime joinedAt;

/// Create a copy of AddMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddMemberResponseCopyWith<_AddMemberResponse> get copyWith => __$AddMemberResponseCopyWithImpl<_AddMemberResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddMemberResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddMemberResponse&&(identical(other.teamId, teamId) || other.teamId == teamId)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,teamId,userId,joinedAt);

@override
String toString() {
  return 'AddMemberResponse(teamId: $teamId, userId: $userId, joinedAt: $joinedAt)';
}


}

/// @nodoc
abstract mixin class _$AddMemberResponseCopyWith<$Res> implements $AddMemberResponseCopyWith<$Res> {
  factory _$AddMemberResponseCopyWith(_AddMemberResponse value, $Res Function(_AddMemberResponse) _then) = __$AddMemberResponseCopyWithImpl;
@override @useResult
$Res call({
 String teamId, String userId, DateTime joinedAt
});




}
/// @nodoc
class __$AddMemberResponseCopyWithImpl<$Res>
    implements _$AddMemberResponseCopyWith<$Res> {
  __$AddMemberResponseCopyWithImpl(this._self, this._then);

  final _AddMemberResponse _self;
  final $Res Function(_AddMemberResponse) _then;

/// Create a copy of AddMemberResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? teamId = null,Object? userId = null,Object? joinedAt = null,}) {
  return _then(_AddMemberResponse(
teamId: null == teamId ? _self.teamId : teamId // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,joinedAt: null == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
