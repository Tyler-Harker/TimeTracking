// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'invoice_line_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$InvoiceLineItem {

 String get id; String get description; double get quantity; double get unitPrice; double get amount; String? get projectName;
/// Create a copy of InvoiceLineItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InvoiceLineItemCopyWith<InvoiceLineItem> get copyWith => _$InvoiceLineItemCopyWithImpl<InvoiceLineItem>(this as InvoiceLineItem, _$identity);

  /// Serializes this InvoiceLineItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InvoiceLineItem&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.projectName, projectName) || other.projectName == projectName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,quantity,unitPrice,amount,projectName);

@override
String toString() {
  return 'InvoiceLineItem(id: $id, description: $description, quantity: $quantity, unitPrice: $unitPrice, amount: $amount, projectName: $projectName)';
}


}

/// @nodoc
abstract mixin class $InvoiceLineItemCopyWith<$Res>  {
  factory $InvoiceLineItemCopyWith(InvoiceLineItem value, $Res Function(InvoiceLineItem) _then) = _$InvoiceLineItemCopyWithImpl;
@useResult
$Res call({
 String id, String description, double quantity, double unitPrice, double amount, String? projectName
});




}
/// @nodoc
class _$InvoiceLineItemCopyWithImpl<$Res>
    implements $InvoiceLineItemCopyWith<$Res> {
  _$InvoiceLineItemCopyWithImpl(this._self, this._then);

  final InvoiceLineItem _self;
  final $Res Function(InvoiceLineItem) _then;

/// Create a copy of InvoiceLineItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? description = null,Object? quantity = null,Object? unitPrice = null,Object? amount = null,Object? projectName = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,projectName: freezed == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [InvoiceLineItem].
extension InvoiceLineItemPatterns on InvoiceLineItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InvoiceLineItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InvoiceLineItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InvoiceLineItem value)  $default,){
final _that = this;
switch (_that) {
case _InvoiceLineItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InvoiceLineItem value)?  $default,){
final _that = this;
switch (_that) {
case _InvoiceLineItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String description,  double quantity,  double unitPrice,  double amount,  String? projectName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InvoiceLineItem() when $default != null:
return $default(_that.id,_that.description,_that.quantity,_that.unitPrice,_that.amount,_that.projectName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String description,  double quantity,  double unitPrice,  double amount,  String? projectName)  $default,) {final _that = this;
switch (_that) {
case _InvoiceLineItem():
return $default(_that.id,_that.description,_that.quantity,_that.unitPrice,_that.amount,_that.projectName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String description,  double quantity,  double unitPrice,  double amount,  String? projectName)?  $default,) {final _that = this;
switch (_that) {
case _InvoiceLineItem() when $default != null:
return $default(_that.id,_that.description,_that.quantity,_that.unitPrice,_that.amount,_that.projectName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InvoiceLineItem implements InvoiceLineItem {
  const _InvoiceLineItem({required this.id, required this.description, required this.quantity, required this.unitPrice, required this.amount, this.projectName});
  factory _InvoiceLineItem.fromJson(Map<String, dynamic> json) => _$InvoiceLineItemFromJson(json);

@override final  String id;
@override final  String description;
@override final  double quantity;
@override final  double unitPrice;
@override final  double amount;
@override final  String? projectName;

/// Create a copy of InvoiceLineItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InvoiceLineItemCopyWith<_InvoiceLineItem> get copyWith => __$InvoiceLineItemCopyWithImpl<_InvoiceLineItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InvoiceLineItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _InvoiceLineItem&&(identical(other.id, id) || other.id == id)&&(identical(other.description, description) || other.description == description)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.projectName, projectName) || other.projectName == projectName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,description,quantity,unitPrice,amount,projectName);

@override
String toString() {
  return 'InvoiceLineItem(id: $id, description: $description, quantity: $quantity, unitPrice: $unitPrice, amount: $amount, projectName: $projectName)';
}


}

/// @nodoc
abstract mixin class _$InvoiceLineItemCopyWith<$Res> implements $InvoiceLineItemCopyWith<$Res> {
  factory _$InvoiceLineItemCopyWith(_InvoiceLineItem value, $Res Function(_InvoiceLineItem) _then) = __$InvoiceLineItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String description, double quantity, double unitPrice, double amount, String? projectName
});




}
/// @nodoc
class __$InvoiceLineItemCopyWithImpl<$Res>
    implements _$InvoiceLineItemCopyWith<$Res> {
  __$InvoiceLineItemCopyWithImpl(this._self, this._then);

  final _InvoiceLineItem _self;
  final $Res Function(_InvoiceLineItem) _then;

/// Create a copy of InvoiceLineItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? description = null,Object? quantity = null,Object? unitPrice = null,Object? amount = null,Object? projectName = freezed,}) {
  return _then(_InvoiceLineItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as double,projectName: freezed == projectName ? _self.projectName : projectName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
