// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paginated_tasks.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PaginatedTasks {

 List<TaskItem> get items; int get totalCount; int get page; int get pageSize;
/// Create a copy of PaginatedTasks
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaginatedTasksCopyWith<PaginatedTasks> get copyWith => _$PaginatedTasksCopyWithImpl<PaginatedTasks>(this as PaginatedTasks, _$identity);

  /// Serializes this PaginatedTasks to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaginatedTasks&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),totalCount,page,pageSize);

@override
String toString() {
  return 'PaginatedTasks(items: $items, totalCount: $totalCount, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class $PaginatedTasksCopyWith<$Res>  {
  factory $PaginatedTasksCopyWith(PaginatedTasks value, $Res Function(PaginatedTasks) _then) = _$PaginatedTasksCopyWithImpl;
@useResult
$Res call({
 List<TaskItem> items, int totalCount, int page, int pageSize
});




}
/// @nodoc
class _$PaginatedTasksCopyWithImpl<$Res>
    implements $PaginatedTasksCopyWith<$Res> {
  _$PaginatedTasksCopyWithImpl(this._self, this._then);

  final PaginatedTasks _self;
  final $Res Function(PaginatedTasks) _then;

/// Create a copy of PaginatedTasks
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? totalCount = null,Object? page = null,Object? pageSize = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TaskItem>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PaginatedTasks].
extension PaginatedTasksPatterns on PaginatedTasks {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaginatedTasks value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaginatedTasks() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaginatedTasks value)  $default,){
final _that = this;
switch (_that) {
case _PaginatedTasks():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaginatedTasks value)?  $default,){
final _that = this;
switch (_that) {
case _PaginatedTasks() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<TaskItem> items,  int totalCount,  int page,  int pageSize)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaginatedTasks() when $default != null:
return $default(_that.items,_that.totalCount,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<TaskItem> items,  int totalCount,  int page,  int pageSize)  $default,) {final _that = this;
switch (_that) {
case _PaginatedTasks():
return $default(_that.items,_that.totalCount,_that.page,_that.pageSize);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<TaskItem> items,  int totalCount,  int page,  int pageSize)?  $default,) {final _that = this;
switch (_that) {
case _PaginatedTasks() when $default != null:
return $default(_that.items,_that.totalCount,_that.page,_that.pageSize);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PaginatedTasks implements PaginatedTasks {
  const _PaginatedTasks({required final  List<TaskItem> items, required this.totalCount, required this.page, required this.pageSize}): _items = items;
  factory _PaginatedTasks.fromJson(Map<String, dynamic> json) => _$PaginatedTasksFromJson(json);

 final  List<TaskItem> _items;
@override List<TaskItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int totalCount;
@override final  int page;
@override final  int pageSize;

/// Create a copy of PaginatedTasks
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaginatedTasksCopyWith<_PaginatedTasks> get copyWith => __$PaginatedTasksCopyWithImpl<_PaginatedTasks>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PaginatedTasksToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaginatedTasks&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.totalCount, totalCount) || other.totalCount == totalCount)&&(identical(other.page, page) || other.page == page)&&(identical(other.pageSize, pageSize) || other.pageSize == pageSize));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),totalCount,page,pageSize);

@override
String toString() {
  return 'PaginatedTasks(items: $items, totalCount: $totalCount, page: $page, pageSize: $pageSize)';
}


}

/// @nodoc
abstract mixin class _$PaginatedTasksCopyWith<$Res> implements $PaginatedTasksCopyWith<$Res> {
  factory _$PaginatedTasksCopyWith(_PaginatedTasks value, $Res Function(_PaginatedTasks) _then) = __$PaginatedTasksCopyWithImpl;
@override @useResult
$Res call({
 List<TaskItem> items, int totalCount, int page, int pageSize
});




}
/// @nodoc
class __$PaginatedTasksCopyWithImpl<$Res>
    implements _$PaginatedTasksCopyWith<$Res> {
  __$PaginatedTasksCopyWithImpl(this._self, this._then);

  final _PaginatedTasks _self;
  final $Res Function(_PaginatedTasks) _then;

/// Create a copy of PaginatedTasks
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? totalCount = null,Object? page = null,Object? pageSize = null,}) {
  return _then(_PaginatedTasks(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TaskItem>,totalCount: null == totalCount ? _self.totalCount : totalCount // ignore: cast_nullable_to_non_nullable
as int,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,pageSize: null == pageSize ? _self.pageSize : pageSize // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
