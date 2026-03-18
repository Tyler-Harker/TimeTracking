// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_InvoiceDetail _$InvoiceDetailFromJson(Map<String, dynamic> json) =>
    _InvoiceDetail(
      id: json['id'] as String,
      invoiceNumber: json['invoiceNumber'] as String,
      status: json['status'] as String,
      clientId: json['clientId'] as String?,
      projectId: json['projectId'] as String?,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      taxRate: (json['taxRate'] as num).toDouble(),
      taxAmount: (json['taxAmount'] as num).toDouble(),
      notes: json['notes'] as String?,
      issuedDate: const DateOnlyConverter().fromJson(
        json['issuedDate'] as String,
      ),
      dueDate: const DateOnlyConverter().fromJson(json['dueDate'] as String),
      paidDate: const NullableDateOnlyConverter().fromJson(
        json['paidDate'] as String?,
      ),
      lineItems:
          (json['lineItems'] as List<dynamic>?)
              ?.map((e) => InvoiceLineItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$InvoiceDetailToJson(_InvoiceDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoiceNumber': instance.invoiceNumber,
      'status': instance.status,
      'clientId': instance.clientId,
      'projectId': instance.projectId,
      'totalAmount': instance.totalAmount,
      'taxRate': instance.taxRate,
      'taxAmount': instance.taxAmount,
      'notes': instance.notes,
      'issuedDate': const DateOnlyConverter().toJson(instance.issuedDate),
      'dueDate': const DateOnlyConverter().toJson(instance.dueDate),
      'paidDate': const NullableDateOnlyConverter().toJson(instance.paidDate),
      'lineItems': instance.lineItems.map((e) => e.toJson()).toList(),
    };
