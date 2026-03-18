// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_line_item_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AddLineItemRequest {

 String get description; double get quantity; double get unitPrice;
/// Create a copy of AddLineItemRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AddLineItemRequestCopyWith<AddLineItemRequest> get copyWith => _$AddLineItemRequestCopyWithImpl<AddLineItemRequest>(this as AddLineItemRequest, _$identity);

  /// Serializes this AddLineItemRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AddLineItemRequest&&(identical(other.description, description) || other.description == description)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,description,quantity,unitPrice);

@override
String toString() {
  return 'AddLineItemRequest(description: $description, quantity: $quantity, unitPrice: $unitPrice)';
}


}

/// @nodoc
abstract mixin class $AddLineItemRequestCopyWith<$Res>  {
  factory $AddLineItemRequestCopyWith(AddLineItemRequest value, $Res Function(AddLineItemRequest) _then) = _$AddLineItemRequestCopyWithImpl;
@useResult
$Res call({
 String description, double quantity, double unitPrice
});




}
/// @nodoc
class _$AddLineItemRequestCopyWithImpl<$Res>
    implements $AddLineItemRequestCopyWith<$Res> {
  _$AddLineItemRequestCopyWithImpl(this._self, this._then);

  final AddLineItemRequest _self;
  final $Res Function(AddLineItemRequest) _then;

/// Create a copy of AddLineItemRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? description = null,Object? quantity = null,Object? unitPrice = null,}) {
  return _then(_self.copyWith(
description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [AddLineItemRequest].
extension AddLineItemRequestPatterns on AddLineItemRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AddLineItemRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AddLineItemRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AddLineItemRequest value)  $default,){
final _that = this;
switch (_that) {
case _AddLineItemRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AddLineItemRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AddLineItemRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String description,  double quantity,  double unitPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AddLineItemRequest() when $default != null:
return $default(_that.description,_that.quantity,_that.unitPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String description,  double quantity,  double unitPrice)  $default,) {final _that = this;
switch (_that) {
case _AddLineItemRequest():
return $default(_that.description,_that.quantity,_that.unitPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String description,  double quantity,  double unitPrice)?  $default,) {final _that = this;
switch (_that) {
case _AddLineItemRequest() when $default != null:
return $default(_that.description,_that.quantity,_that.unitPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AddLineItemRequest implements AddLineItemRequest {
  const _AddLineItemRequest({required this.description, required this.quantity, required this.unitPrice});
  factory _AddLineItemRequest.fromJson(Map<String, dynamic> json) => _$AddLineItemRequestFromJson(json);

@override final  String description;
@override final  double quantity;
@override final  double unitPrice;

/// Create a copy of AddLineItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AddLineItemRequestCopyWith<_AddLineItemRequest> get copyWith => __$AddLineItemRequestCopyWithImpl<_AddLineItemRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AddLineItemRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AddLineItemRequest&&(identical(other.description, description) || other.description == description)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,description,quantity,unitPrice);

@override
String toString() {
  return 'AddLineItemRequest(description: $description, quantity: $quantity, unitPrice: $unitPrice)';
}


}

/// @nodoc
abstract mixin class _$AddLineItemRequestCopyWith<$Res> implements $AddLineItemRequestCopyWith<$Res> {
  factory _$AddLineItemRequestCopyWith(_AddLineItemRequest value, $Res Function(_AddLineItemRequest) _then) = __$AddLineItemRequestCopyWithImpl;
@override @useResult
$Res call({
 String description, double quantity, double unitPrice
});




}
/// @nodoc
class __$AddLineItemRequestCopyWithImpl<$Res>
    implements _$AddLineItemRequestCopyWith<$Res> {
  __$AddLineItemRequestCopyWithImpl(this._self, this._then);

  final _AddLineItemRequest _self;
  final $Res Function(_AddLineItemRequest) _then;

/// Create a copy of AddLineItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? description = null,Object? quantity = null,Object? unitPrice = null,}) {
  return _then(_AddLineItemRequest(
description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
