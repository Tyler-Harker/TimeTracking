// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'project_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProjectDetail {

 String get id; String get name; String? get description; String get status; double? get budgetAmount; double? get defaultBillableRate;@NullableDateOnlyConverter() DateTime? get startDate;@NullableDateOnlyConverter() DateTime? get endDate; DateTime get createdAt; String get clientId; String get clientName; double? get inheritedBillableRate;
/// Create a copy of ProjectDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectDetailCopyWith<ProjectDetail> get copyWith => _$ProjectDetailCopyWithImpl<ProjectDetail>(this as ProjectDetail, _$identity);

  /// Serializes this ProjectDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.defaultBillableRate, defaultBillableRate) || other.defaultBillableRate == defaultBillableRate)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.inheritedBillableRate, inheritedBillableRate) || other.inheritedBillableRate == inheritedBillableRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,status,budgetAmount,defaultBillableRate,startDate,endDate,createdAt,clientId,clientName,inheritedBillableRate);

@override
String toString() {
  return 'ProjectDetail(id: $id, name: $name, description: $description, status: $status, budgetAmount: $budgetAmount, defaultBillableRate: $defaultBillableRate, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, clientId: $clientId, clientName: $clientName, inheritedBillableRate: $inheritedBillableRate)';
}


}

/// @nodoc
abstract mixin class $ProjectDetailCopyWith<$Res>  {
  factory $ProjectDetailCopyWith(ProjectDetail value, $Res Function(ProjectDetail) _then) = _$ProjectDetailCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description, String status, double? budgetAmount, double? defaultBillableRate,@NullableDateOnlyConverter() DateTime? startDate,@NullableDateOnlyConverter() DateTime? endDate, DateTime createdAt, String clientId, String clientName, double? inheritedBillableRate
});




}
/// @nodoc
class _$ProjectDetailCopyWithImpl<$Res>
    implements $ProjectDetailCopyWith<$Res> {
  _$ProjectDetailCopyWithImpl(this._self, this._then);

  final ProjectDetail _self;
  final $Res Function(ProjectDetail) _then;

/// Create a copy of ProjectDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? status = null,Object? budgetAmount = freezed,Object? defaultBillableRate = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? createdAt = null,Object? clientId = null,Object? clientName = null,Object? inheritedBillableRate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,budgetAmount: freezed == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as double?,defaultBillableRate: freezed == defaultBillableRate ? _self.defaultBillableRate : defaultBillableRate // ignore: cast_nullable_to_non_nullable
as double?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,inheritedBillableRate: freezed == inheritedBillableRate ? _self.inheritedBillableRate : inheritedBillableRate // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectDetail].
extension ProjectDetailPatterns on ProjectDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectDetail value)  $default,){
final _that = this;
switch (_that) {
case _ProjectDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String status,  double? budgetAmount,  double? defaultBillableRate, @NullableDateOnlyConverter()  DateTime? startDate, @NullableDateOnlyConverter()  DateTime? endDate,  DateTime createdAt,  String clientId,  String clientName,  double? inheritedBillableRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectDetail() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.status,_that.budgetAmount,_that.defaultBillableRate,_that.startDate,_that.endDate,_that.createdAt,_that.clientId,_that.clientName,_that.inheritedBillableRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description,  String status,  double? budgetAmount,  double? defaultBillableRate, @NullableDateOnlyConverter()  DateTime? startDate, @NullableDateOnlyConverter()  DateTime? endDate,  DateTime createdAt,  String clientId,  String clientName,  double? inheritedBillableRate)  $default,) {final _that = this;
switch (_that) {
case _ProjectDetail():
return $default(_that.id,_that.name,_that.description,_that.status,_that.budgetAmount,_that.defaultBillableRate,_that.startDate,_that.endDate,_that.createdAt,_that.clientId,_that.clientName,_that.inheritedBillableRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description,  String status,  double? budgetAmount,  double? defaultBillableRate, @NullableDateOnlyConverter()  DateTime? startDate, @NullableDateOnlyConverter()  DateTime? endDate,  DateTime createdAt,  String clientId,  String clientName,  double? inheritedBillableRate)?  $default,) {final _that = this;
switch (_that) {
case _ProjectDetail() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.status,_that.budgetAmount,_that.defaultBillableRate,_that.startDate,_that.endDate,_that.createdAt,_that.clientId,_that.clientName,_that.inheritedBillableRate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProjectDetail implements ProjectDetail {
  const _ProjectDetail({required this.id, required this.name, this.description, required this.status, this.budgetAmount, this.defaultBillableRate, @NullableDateOnlyConverter() this.startDate, @NullableDateOnlyConverter() this.endDate, required this.createdAt, required this.clientId, required this.clientName, this.inheritedBillableRate});
  factory _ProjectDetail.fromJson(Map<String, dynamic> json) => _$ProjectDetailFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override final  String status;
@override final  double? budgetAmount;
@override final  double? defaultBillableRate;
@override@NullableDateOnlyConverter() final  DateTime? startDate;
@override@NullableDateOnlyConverter() final  DateTime? endDate;
@override final  DateTime createdAt;
@override final  String clientId;
@override final  String clientName;
@override final  double? inheritedBillableRate;

/// Create a copy of ProjectDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectDetailCopyWith<_ProjectDetail> get copyWith => __$ProjectDetailCopyWithImpl<_ProjectDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.status, status) || other.status == status)&&(identical(other.budgetAmount, budgetAmount) || other.budgetAmount == budgetAmount)&&(identical(other.defaultBillableRate, defaultBillableRate) || other.defaultBillableRate == defaultBillableRate)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.clientName, clientName) || other.clientName == clientName)&&(identical(other.inheritedBillableRate, inheritedBillableRate) || other.inheritedBillableRate == inheritedBillableRate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,status,budgetAmount,defaultBillableRate,startDate,endDate,createdAt,clientId,clientName,inheritedBillableRate);

@override
String toString() {
  return 'ProjectDetail(id: $id, name: $name, description: $description, status: $status, budgetAmount: $budgetAmount, defaultBillableRate: $defaultBillableRate, startDate: $startDate, endDate: $endDate, createdAt: $createdAt, clientId: $clientId, clientName: $clientName, inheritedBillableRate: $inheritedBillableRate)';
}


}

/// @nodoc
abstract mixin class _$ProjectDetailCopyWith<$Res> implements $ProjectDetailCopyWith<$Res> {
  factory _$ProjectDetailCopyWith(_ProjectDetail value, $Res Function(_ProjectDetail) _then) = __$ProjectDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description, String status, double? budgetAmount, double? defaultBillableRate,@NullableDateOnlyConverter() DateTime? startDate,@NullableDateOnlyConverter() DateTime? endDate, DateTime createdAt, String clientId, String clientName, double? inheritedBillableRate
});




}
/// @nodoc
class __$ProjectDetailCopyWithImpl<$Res>
    implements _$ProjectDetailCopyWith<$Res> {
  __$ProjectDetailCopyWithImpl(this._self, this._then);

  final _ProjectDetail _self;
  final $Res Function(_ProjectDetail) _then;

/// Create a copy of ProjectDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? status = null,Object? budgetAmount = freezed,Object? defaultBillableRate = freezed,Object? startDate = freezed,Object? endDate = freezed,Object? createdAt = null,Object? clientId = null,Object? clientName = null,Object? inheritedBillableRate = freezed,}) {
  return _then(_ProjectDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,budgetAmount: freezed == budgetAmount ? _self.budgetAmount : budgetAmount // ignore: cast_nullable_to_non_nullable
as double?,defaultBillableRate: freezed == defaultBillableRate ? _self.defaultBillableRate : defaultBillableRate // ignore: cast_nullable_to_non_nullable
as double?,startDate: freezed == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime?,endDate: freezed == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,clientId: null == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String,clientName: null == clientName ? _self.clientName : clientName // ignore: cast_nullable_to_non_nullable
as String,inheritedBillableRate: freezed == inheritedBillableRate ? _self.inheritedBillableRate : inheritedBillableRate // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

// dart format on
