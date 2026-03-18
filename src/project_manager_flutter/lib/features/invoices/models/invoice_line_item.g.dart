// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_line_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InvoiceLineItem _$InvoiceLineItemFromJson(Map<String, dynamic> json) =>
    _InvoiceLineItem(
      id: json['id'] as String,
      description: json['description'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unitPrice: (json['unitPrice'] as num).toDouble(),
      amount: (json['amount'] as num).toDouble(),
      projectName: json['projectName'] as String?,
    );

Map<String, dynamic> _$InvoiceLineItemToJson(_InvoiceLineItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'quantity': instance.quantity,
      'unitPrice': instance.unitPrice,
      'amount': instance.amount,
      'projectName': instance.projectName,
    };
