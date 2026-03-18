// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InvoiceDetail {

 String get id; String get invoiceNumber; String get status; String? get clientId; String? get projectId; double get totalAmount; double get taxRate; double get taxAmount; String? get notes;@DateOnlyConverter() DateTime get issuedDate;@DateOnlyConverter() DateTime get dueDate;@NullableDateOnlyConverter() DateTime? get paidDate; List<InvoiceLineItem> get lineItems;
/// Create a copy of InvoiceDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceDetailCopyWith<InvoiceDetail> get copyWith => _$InvoiceDetailCopyWithImpl<InvoiceDetail>(this as InvoiceDetail, _$identity);

  /// Serializes this InvoiceDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.issuedDate, issuedDate) || other.issuedDate == issuedDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&const DeepCollectionEquality().equals(other.lineItems, lineItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,invoiceNumber,status,clientId,projectId,totalAmount,taxRate,taxAmount,notes,issuedDate,dueDate,paidDate,const DeepCollectionEquality().hash(lineItems));

@override
String toString() {
  return 'InvoiceDetail(id: $id, invoiceNumber: $invoiceNumber, status: $status, clientId: $clientId, projectId: $projectId, totalAmount: $totalAmount, taxRate: $taxRate, taxAmount: $taxAmount, notes: $notes, issuedDate: $issuedDate, dueDate: $dueDate, paidDate: $paidDate, lineItems: $lineItems)';
}


}

/// @nodoc
abstract mixin class $InvoiceDetailCopyWith<$Res>  {
  factory $InvoiceDetailCopyWith(InvoiceDetail value, $Res Function(InvoiceDetail) _then) = _$InvoiceDetailCopyWithImpl;
@useResult
$Res call({
 String id, String invoiceNumber, String status, String? clientId, String? projectId, double totalAmount, double taxRate, double taxAmount, String? notes,@DateOnlyConverter() DateTime issuedDate,@DateOnlyConverter() DateTime dueDate,@NullableDateOnlyConverter() DateTime? paidDate, List<InvoiceLineItem> lineItems
});




}
/// @nodoc
class _$InvoiceDetailCopyWithImpl<$Res>
    implements $InvoiceDetailCopyWith<$Res> {
  _$InvoiceDetailCopyWithImpl(this._self, this._then);

  final InvoiceDetail _self;
  final $Res Function(InvoiceDetail) _then;

/// Create a copy of InvoiceDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? invoiceNumber = null,Object? status = null,Object? clientId = freezed,Object? projectId = freezed,Object? totalAmount = null,Object? taxRate = null,Object? taxAmount = null,Object? notes = freezed,Object? issuedDate = null,Object? dueDate = null,Object? paidDate = freezed,Object? lineItems = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as double,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,issuedDate: null == issuedDate ? _self.issuedDate : issuedDate // ignore: cast_nullable_to_non_nullable
as DateTime,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,paidDate: freezed == paidDate ? _self.paidDate : paidDate // ignore: cast_nullable_to_non_nullable
as DateTime?,lineItems: null == lineItems ? _self.lineItems : lineItems // ignore: cast_nullable_to_non_nullable
as List<InvoiceLineItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [InvoiceDetail].
extension InvoiceDetailPatterns on InvoiceDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoiceDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoiceDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoiceDetail value)  $default,){
final _that = this;
switch (_that) {
case _InvoiceDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoiceDetail value)?  $default,){
final _that = this;
switch (_that) {
case _InvoiceDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String invoiceNumber,  String status,  String? clientId,  String? projectId,  double totalAmount,  double taxRate,  double taxAmount,  String? notes, @DateOnlyConverter()  DateTime issuedDate, @DateOnlyConverter()  DateTime dueDate, @NullableDateOnlyConverter()  DateTime? paidDate,  List<InvoiceLineItem> lineItems)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoiceDetail() when $default != null:
return $default(_that.id,_that.invoiceNumber,_that.status,_that.clientId,_that.projectId,_that.totalAmount,_that.taxRate,_that.taxAmount,_that.notes,_that.issuedDate,_that.dueDate,_that.paidDate,_that.lineItems);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String invoiceNumber,  String status,  String? clientId,  String? projectId,  double totalAmount,  double taxRate,  double taxAmount,  String? notes, @DateOnlyConverter()  DateTime issuedDate, @DateOnlyConverter()  DateTime dueDate, @NullableDateOnlyConverter()  DateTime? paidDate,  List<InvoiceLineItem> lineItems)  $default,) {final _that = this;
switch (_that) {
case _InvoiceDetail():
return $default(_that.id,_that.invoiceNumber,_that.status,_that.clientId,_that.projectId,_that.totalAmount,_that.taxRate,_that.taxAmount,_that.notes,_that.issuedDate,_that.dueDate,_that.paidDate,_that.lineItems);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String invoiceNumber,  String status,  String? clientId,  String? projectId,  double totalAmount,  double taxRate,  double taxAmount,  String? notes, @DateOnlyConverter()  DateTime issuedDate, @DateOnlyConverter()  DateTime dueDate, @NullableDateOnlyConverter()  DateTime? paidDate,  List<InvoiceLineItem> lineItems)?  $default,) {final _that = this;
switch (_that) {
case _InvoiceDetail() when $default != null:
return $default(_that.id,_that.invoiceNumber,_that.status,_that.clientId,_that.projectId,_that.totalAmount,_that.taxRate,_that.taxAmount,_that.notes,_that.issuedDate,_that.dueDate,_that.paidDate,_that.lineItems);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvoiceDetail implements InvoiceDetail {
  const _InvoiceDetail({required this.id, required this.invoiceNumber, required this.status, this.clientId, this.projectId, required this.totalAmount, required this.taxRate, required this.taxAmount, this.notes, @DateOnlyConverter() required this.issuedDate, @DateOnlyConverter() required this.dueDate, @NullableDateOnlyConverter() this.paidDate, final  List<InvoiceLineItem> lineItems = const []}): _lineItems = lineItems;
  factory _InvoiceDetail.fromJson(Map<String, dynamic> json) => _$InvoiceDetailFromJson(json);

@override final  String id;
@override final  String invoiceNumber;
@override final  String status;
@override final  String? clientId;
@override final  String? projectId;
@override final  double totalAmount;
@override final  double taxRate;
@override final  double taxAmount;
@override final  String? notes;
@override@DateOnlyConverter() final  DateTime issuedDate;
@override@DateOnlyConverter() final  DateTime dueDate;
@override@NullableDateOnlyConverter() final  DateTime? paidDate;
 final  List<InvoiceLineItem> _lineItems;
@override@JsonKey() List<InvoiceLineItem> get lineItems {
  if (_lineItems is EqualUnmodifiableListView) return _lineItems;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lineItems);
}


/// Create a copy of InvoiceDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceDetailCopyWith<_InvoiceDetail> get copyWith => __$InvoiceDetailCopyWithImpl<_InvoiceDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoiceDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.invoiceNumber, invoiceNumber) || other.invoiceNumber == invoiceNumber)&&(identical(other.status, status) || other.status == status)&&(identical(other.clientId, clientId) || other.clientId == clientId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.taxRate, taxRate) || other.taxRate == taxRate)&&(identical(other.taxAmount, taxAmount) || other.taxAmount == taxAmount)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.issuedDate, issuedDate) || other.issuedDate == issuedDate)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.paidDate, paidDate) || other.paidDate == paidDate)&&const DeepCollectionEquality().equals(other._lineItems, _lineItems));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,invoiceNumber,status,clientId,projectId,totalAmount,taxRate,taxAmount,notes,issuedDate,dueDate,paidDate,const DeepCollectionEquality().hash(_lineItems));

@override
String toString() {
  return 'InvoiceDetail(id: $id, invoiceNumber: $invoiceNumber, status: $status, clientId: $clientId, projectId: $projectId, totalAmount: $totalAmount, taxRate: $taxRate, taxAmount: $taxAmount, notes: $notes, issuedDate: $issuedDate, dueDate: $dueDate, paidDate: $paidDate, lineItems: $lineItems)';
}


}

/// @nodoc
abstract mixin class _$InvoiceDetailCopyWith<$Res> implements $InvoiceDetailCopyWith<$Res> {
  factory _$InvoiceDetailCopyWith(_InvoiceDetail value, $Res Function(_InvoiceDetail) _then) = __$InvoiceDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String invoiceNumber, String status, String? clientId, String? projectId, double totalAmount, double taxRate, double taxAmount, String? notes,@DateOnlyConverter() DateTime issuedDate,@DateOnlyConverter() DateTime dueDate,@NullableDateOnlyConverter() DateTime? paidDate, List<InvoiceLineItem> lineItems
});




}
/// @nodoc
class __$InvoiceDetailCopyWithImpl<$Res>
    implements _$InvoiceDetailCopyWith<$Res> {
  __$InvoiceDetailCopyWithImpl(this._self, this._then);

  final _InvoiceDetail _self;
  final $Res Function(_InvoiceDetail) _then;

/// Create a copy of InvoiceDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? invoiceNumber = null,Object? status = null,Object? clientId = freezed,Object? projectId = freezed,Object? totalAmount = null,Object? taxRate = null,Object? taxAmount = null,Object? notes = freezed,Object? issuedDate = null,Object? dueDate = null,Object? paidDate = freezed,Object? lineItems = null,}) {
  return _then(_InvoiceDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,invoiceNumber: null == invoiceNumber ? _self.invoiceNumber : invoiceNumber // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,clientId: freezed == clientId ? _self.clientId : clientId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,taxRate: null == taxRate ? _self.taxRate : taxRate // ignore: cast_nullable_to_non_nullable
as double,taxAmount: null == taxAmount ? _self.taxAmount : taxAmount // ignore: cast_nullable_to_non_nullable
as double,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,issuedDate: null == issuedDate ? _self.issuedDate : issuedDate // ignore: cast_nullable_to_non_nullable
as DateTime,dueDate: null == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime,paidDate: freezed == paidDate ? _self.paidDate : paidDate // ignore: cast_nullable_to_non_nullable
as DateTime?,lineItems: null == lineItems ? _self._lineItems : lineItems // ignore: cast_nullable_to_non_nullable
as List<InvoiceLineItem>,
  ));
}


}

// dart format on
