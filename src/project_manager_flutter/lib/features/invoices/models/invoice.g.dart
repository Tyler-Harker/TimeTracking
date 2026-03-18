// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Invoice _$InvoiceFromJson(Map<String, dynamic> json) => _Invoice(
  id: json['id'] as String,
  invoiceNumber: json['invoiceNumber'] as String,
  status: json['status'] as String,
  totalAmount: (json['totalAmount'] as num).toDouble(),
  issuedDate: const DateOnlyConverter().fromJson(json['issuedDate'] as String),
  dueDate: const DateOnlyConverter().fromJson(json['dueDate'] as String),
);

Map<String, dynamic> _$InvoiceToJson(_Invoice instance) => <String, dynamic>{
  'id': instance.id,
  'invoiceNumber': instance.invoiceNumber,
  'status': instance.status,
  'totalAmount': instance.totalAmount,
  'issuedDate': const DateOnlyConverter().toJson(instance.issuedDate),
  'dueDate': const DateOnlyConverter().toJson(instance.dueDate),
};
