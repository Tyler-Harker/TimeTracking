// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_line_item_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddLineItemRequest _$AddLineItemRequestFromJson(Map<String, dynamic> json) =>
    _AddLineItemRequest(
      description: json['description'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
    );

Map<String, dynamic> _$AddLineItemRequestToJson(_AddLineItemRequest instance) =>
    <String, dynamic>{
      'description': instance.description,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
    };
