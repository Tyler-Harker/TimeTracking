// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'time_entry_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TimeEntryDetail {

 String get id; String get userId; String get userName; String get projectId; String get projectName;@DateOnlyConverter() DateTime get date; double get hours; String? get description; double? get billableRate; bool get isBillable; bool get isInvoiced; DateTime get createdAt; double? get inheritedBillableRate; String? get taskId; String? get taskName;
/// Create a copy of TimeEntryDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimeEntryDetailCopyWith<TimeEntryDetail> get copyWith => _$TimeEntryDetailCopyWithImpl<TimeEntryDetail>(this as TimeEntryDetail, _$identity);

  /// Serializes this TimeEntryDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimeEntryDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.date, date) || other.date == date)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.description, description) || other.description == description)&&(identical(other.billableRate, billableRate) || other.billableRate == billableRate)&&(identical(other.isBillable, isBillable) || other.isBillable == isBillable)&&(identical(other.isInvoiced, isInvoiced) || other.isInvoiced == isInvoiced)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.inheritedBillableRate, inheritedBillableRate) || other.inheritedBillableRate == inheritedBillableRate)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.taskName, taskName) || other.taskName == taskName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,projectId,projectName,date,hours,description,billableRate,isBillable,isInvoiced,createdAt,inheritedBillableRate,taskId,taskName);

@override
String toString() {
  return 'TimeEntryDetail(id: $id, userId: $userId, userName: $userName, projectId: $projectId, projectName: $projectName, date: $date, hours: $hours, description: $description, billableRate: $billableRate, isBillable: $isBillable, isInvoiced: $isInvoiced, createdAt: $createdAt, inheritedBillableRate: $inheritedBillableRate, taskId: $taskId, taskName: $taskName)';
}


}

/// @nodoc
abstract mixin class $TimeEntryDetailCopyWith<$Res>  {
  factory $TimeEntryDetailCopyWith(TimeEntryDetail value, $Res Function(TimeEntryDetail) _then) = _$TimeEntryDetailCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String userName, String projectId, String projectName,@DateOnlyConverter() DateTime date, double hours, String? description, double? billableRate, bool isBillable, bool isInvoiced, DateTime createdAt, double? inheritedBillableRate, String? taskId, String? taskName
});




}
/// @nodoc
class _$TimeEntryDetailCopyWithImpl<$Res>
    implements $TimeEntryDetailCopyWith<$Res> {
  _$TimeEntryDetailCopyWithImpl(this._self, this._then);

  final TimeEntryDetail _self;
  final $Res Function(TimeEntryDetail) _then;

/// Create a copy of TimeEntryDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? userName = null,Object? projectId = null,Object? projectName = null,Object? date = null,Object? hours = null,Object? description = freezed,Object? billableRate = freezed,Object? isBillable = null,Object? isInvoiced = null,Object? createdAt = null,Object? inheritedBillableRate = freezed,Object? taskId = freezed,Object? taskName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,billableRate: freezed == billableRate ? _self.billableRate : billableRate // ignore: cast_nullable_to_non_nullable
as double?,isBillable: null == isBillable ? _self.isBillable : isBillable // ignore: cast_nullable_to_non_nullable
as bool,isInvoiced: null == isInvoiced ? _self.isInvoiced : isInvoiced // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,inheritedBillableRate: freezed == inheritedBillableRate ? _self.inheritedBillableRate : inheritedBillableRate // ignore: cast_nullable_to_non_nullable
as double?,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,taskName: freezed == taskName ? _self.taskName : taskName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimeEntryDetail].
extension TimeEntryDetailPatterns on TimeEntryDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimeEntryDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimeEntryDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimeEntryDetail value)  $default,){
final _that = this;
switch (_that) {
case _TimeEntryDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimeEntryDetail value)?  $default,){
final _that = this;
switch (_that) {
case _TimeEntryDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String userName,  String projectId,  String projectName, @DateOnlyConverter()  DateTime date,  double hours,  String? description,  double? billableRate,  bool isBillable,  bool isInvoiced,  DateTime createdAt,  double? inheritedBillableRate,  String? taskId,  String? taskName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimeEntryDetail() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.projectId,_that.projectName,_that.date,_that.hours,_that.description,_that.billableRate,_that.isBillable,_that.isInvoiced,_that.createdAt,_that.inheritedBillableRate,_that.taskId,_that.taskName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String userName,  String projectId,  String projectName, @DateOnlyConverter()  DateTime date,  double hours,  String? description,  double? billableRate,  bool isBillable,  bool isInvoiced,  DateTime createdAt,  double? inheritedBillableRate,  String? taskId,  String? taskName)  $default,) {final _that = this;
switch (_that) {
case _TimeEntryDetail():
return $default(_that.id,_that.userId,_that.userName,_that.projectId,_that.projectName,_that.date,_that.hours,_that.description,_that.billableRate,_that.isBillable,_that.isInvoiced,_that.createdAt,_that.inheritedBillableRate,_that.taskId,_that.taskName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String userName,  String projectId,  String projectName, @DateOnlyConverter()  DateTime date,  double hours,  String? description,  double? billableRate,  bool isBillable,  bool isInvoiced,  DateTime createdAt,  double? inheritedBillableRate,  String? taskId,  String? taskName)?  $default,) {final _that = this;
switch (_that) {
case _TimeEntryDetail() when $default != null:
return $default(_that.id,_that.userId,_that.userName,_that.projectId,_that.projectName,_that.date,_that.hours,_that.description,_that.billableRate,_that.isBillable,_that.isInvoiced,_that.createdAt,_that.inheritedBillableRate,_that.taskId,_that.taskName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TimeEntryDetail implements TimeEntryDetail {
  const _TimeEntryDetail({required this.id, required this.userId, required this.userName, required this.projectId, required this.projectName, @DateOnlyConverter() required this.date, required this.hours, this.description, this.billableRate, required this.isBillable, required this.isInvoiced, required this.createdAt, this.inheritedBillableRate, this.taskId, this.taskName});
  factory _TimeEntryDetail.fromJson(Map<String, dynamic> json) => _$TimeEntryDetailFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String userName;
@override final  String projectId;
@override final  String projectName;
@override@DateOnlyConverter() final  DateTime date;
@override final  double hours;
@override final  String? description;
@override final  double? billableRate;
@override final  bool isBillable;
@override final  bool isInvoiced;
@override final  DateTime createdAt;
@override final  double? inheritedBillableRate;
@override final  String? taskId;
@override final  String? taskName;

/// Create a copy of TimeEntryDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimeEntryDetailCopyWith<_TimeEntryDetail> get copyWith => __$TimeEntryDetailCopyWithImpl<_TimeEntryDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimeEntryDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimeEntryDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.projectName, projectName) || other.projectName == projectName)&&(identical(other.date, date) || other.date == date)&&(identical(other.hours, hours) || other.hours == hours)&&(identical(other.description, description) || other.description == description)&&(identical(other.billableRate, billableRate) || other.billableRate == billableRate)&&(identical(other.isBillable, isBillable) || other.isBillable == isBillable)&&(identical(other.isInvoiced, isInvoiced) || other.isInvoiced == isInvoiced)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.inheritedBillableRate, inheritedBillableRate) || other.inheritedBillableRate == inheritedBillableRate)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.taskName, taskName) || other.taskName == taskName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,userName,projectId,projectName,date,hours,description,billableRate,isBillable,isInvoiced,createdAt,inheritedBillableRate,taskId,taskName);

@override
String toString() {
  return 'TimeEntryDetail(id: $id, userId: $userId, userName: $userName, projectId: $projectId, projectName: $projectName, date: $date, hours: $hours, description: $description, billableRate: $billableRate, isBillable: $isBillable, isInvoiced: $isInvoiced, createdAt: $createdAt, inheritedBillableRate: $inheritedBillableRate, taskId: $taskId, taskName: $taskName)';
}


}

/// @nodoc
abstract mixin class _$TimeEntryDetailCopyWith<$Res> implements $TimeEntryDetailCopyWith<$Res> {
  factory _$TimeEntryDetailCopyWith(_TimeEntryDetail value, $Res Function(_TimeEntryDetail) _then) = __$TimeEntryDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String userName, String projectId, String projectName,@DateOnlyConverter() DateTime date, double hours, String? description, double? billableRate, bool isBillable, bool isInvoiced, DateTime createdAt, double? inheritedBillableRate, String? taskId, String? taskName
});




}
/// @nodoc
class __$TimeEntryDetailCopyWithImpl<$Res>
    implements _$TimeEntryDetailCopyWith<$Res> {
  __$TimeEntryDetailCopyWithImpl(this._self, this._then);

  final _TimeEntryDetail _self;
  final $Res Function(_TimeEntryDetail) _then;

/// Create a copy of TimeEntryDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? userName = null,Object? projectId = null,Object? projectName = null,Object? date = null,Object? hours = null,Object? description = freezed,Object? billableRate = freezed,Object? isBillable = null,Object? isInvoiced = null,Object? createdAt = null,Object? inheritedBillableRate = freezed,Object? taskId = freezed,Object? taskName = freezed,}) {
  return _then(_TimeEntryDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,projectName: null == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,hours: null == hours ? _self.hours : hours // ignore: cast_nullable_to_non_nullable
as double,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,billableRate: freezed == billableRate ? _self.billableRate : billableRate // ignore: cast_nullable_to_non_nullable
as double?,isBillable: null == isBillable ? _self.isBillable : isBillable // ignore: cast_nullable_to_non_nullable
as bool,isInvoiced: null == isInvoiced ? _self.isInvoiced : isInvoiced // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,inheritedBillableRate: freezed == inheritedBillableRate ? _self.inheritedBillableRate : inheritedBillableRate // ignore: cast_nullable_to_non_nullable
as double?,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,taskName: freezed == taskName ? _self.taskName : taskName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
