// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'generate_invoice_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GenerateInvoiceRequest {

 String? get clientId; String? get projectId; double get taxRate; String? get notes;@DateOnlyConverter() DateTime get dueDate;
/// Create a copy of GenerateInvoiceRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GenerateInvoiceRequestCopyWith<GenerateInvoiceRequest> get copyWith => _$GenerateInvoiceRequestCopyWithImpl<GenerateInvoiceRequest>(this as GenerateInvoiceRequest, _$identity);

  /// Serializes this GenerateInvoiceRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GenerateInvoiceRequest&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clientId,projectId,taxRate,notes,dueDate);

@override
String toString() {
  return 'GenerateInvoiceRequest(clientId: $clientId, projectId: $projectId, taxRate: $taxRate, notes: $notes, dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class $GenerateInvoiceRequestCopyWith<$Res>  {
  factory $GenerateInvoiceRequestCopyWith(GenerateInvoiceRequest value, $Res Function(GenerateInvoiceRequest) _then) = _$GenerateInvoiceRequestCopyWithImpl;
@useResult
$Res call({
 String? clientId, String? projectId, double taxRate, String? notes,@DateOnlyConverter() DateTime dueDate
});




}
/// @nodoc
class _$GenerateInvoiceRequestCopyWithImpl<$Res>
    implements $GenerateInvoiceRequestCopyWith<$Res> {
  _$GenerateInvoiceRequestCopyWithImpl(this._self, this._then);

  final GenerateInvoiceRequest _self;
  final $Res Function(GenerateInvoiceRequest) _then;

/// Create a copy of GenerateInvoiceRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? clientId = freezed,Object? projectId = freezed,Object? taxRate = null,Object? notes = freezed,Object? dueDate = null,}) {
  return _then(_self.copyWith(
clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [GenerateInvoiceRequest].
extension GenerateInvoiceRequestPatterns on GenerateInvoiceRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GenerateInvoiceRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GenerateInvoiceRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GenerateInvoiceRequest value)  $default,){
final _that = this;
switch (_that) {
case _GenerateInvoiceRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GenerateInvoiceRequest value)?  $default,){
final _that = this;
switch (_that) {
case _GenerateInvoiceRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? clientId,  String? projectId,  double taxRate,  String? notes, @DateOnlyConverter()  DateTime dueDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GenerateInvoiceRequest() when $default != null:
return $default(_that.clientId,_that.projectId,_that.taxRate,_that.notes,_that.dueDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? clientId,  String? projectId,  double taxRate,  String? notes, @DateOnlyConverter()  DateTime dueDate)  $default,) {final _that = this;
switch (_that) {
case _GenerateInvoiceRequest():
return $default(_that.clientId,_that.projectId,_that.taxRate,_that.notes,_that.dueDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? clientId,  String? projectId,  double taxRate,  String? notes, @DateOnlyConverter()  DateTime dueDate)?  $default,) {final _that = this;
switch (_that) {
case _GenerateInvoiceRequest() when $default != null:
return $default(_that.clientId,_that.projectId,_that.taxRate,_that.notes,_that.dueDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GenerateInvoiceRequest implements GenerateInvoiceRequest {
  const _GenerateInvoiceRequest({this.clientId, this.projectId, required this.taxRate, this.notes, @DateOnlyConverter() required this.dueDate});
  factory _GenerateInvoiceRequest.fromJson(Map<String, dynamic> json) => _$GenerateInvoiceRequestFromJson(json);

@override final  String? clientId;
@override final  String? projectId;
@override final  double taxRate;
@override final  String? notes;
@override@DateOnlyConverter() final  DateTime dueDate;

/// Create a copy of GenerateInvoiceRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GenerateInvoiceRequestCopyWith<_GenerateInvoiceRequest> get copyWith => __$GenerateInvoiceRequestCopyWithImpl<_GenerateInvoiceRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GenerateInvoiceRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GenerateInvoiceRequest&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,clientId,projectId,taxRate,notes,dueDate);

@override
String toString() {
  return 'GenerateInvoiceRequest(clientId: $clientId, projectId: $projectId, taxRate: $taxRate, notes: $notes, dueDate: $dueDate)';
}


}

/// @nodoc
abstract mixin class _$GenerateInvoiceRequestCopyWith<$Res> implements $GenerateInvoiceRequestCopyWith<$Res> {
  factory _$GenerateInvoiceRequestCopyWith(_GenerateInvoiceRequest value, $Res Function(_GenerateInvoiceRequest) _then) = __$GenerateInvoiceRequestCopyWithImpl;
@override @useResult
$Res call({
 String? clientId, String? projectId, double taxRate, String? notes,@DateOnlyConverter() DateTime dueDate
});




}
/// @nodoc
class __$GenerateInvoiceRequestCopyWithImpl<$Res>
    implements _$GenerateInvoiceRequestCopyWith<$Res> {
  __$GenerateInvoiceRequestCopyWithImpl(this._self, this._then);

  final _GenerateInvoiceRequest _self;
  final $Res Function(_GenerateInvoiceRequest) _then;

/// Create a copy of GenerateInvoiceRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? clientId = freezed,Object? projectId = freezed,Object? taxRate = null,Object? notes = freezed,Object? dueDate = null,}) {
  return _then(_GenerateInvoiceRequest(
clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
