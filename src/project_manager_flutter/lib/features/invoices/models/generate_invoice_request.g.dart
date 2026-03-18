// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_invoice_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GenerateInvoiceRequest _$GenerateInvoiceRequestFromJson(
  Map<String, dynamic> json,
) => _GenerateInvoiceRequest(
  clientId: json['clientId'] as String?,
  projectId: json['projectId'] as String?,
  taxRate: (json['taxRate'] as num).toDouble(),
  notes: json['notes'] as String?,
  dueDate: const DateOnlyConverter().fromJson(json['dueDate'] as String),
);

Map<String, dynamic> _$GenerateInvoiceRequestToJson(
  _GenerateInvoiceRequest instance,
) => <String, dynamic>{
  'clientId': instance.clientId,
  'projectId': instance.projectId,
  'taxRate': instance.taxRate,
  'notes': instance.notes,
  'dueDate': const DateOnlyConverter().toJson(instance.dueDate),
};
