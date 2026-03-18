// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_project_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateProjectRequest _$CreateProjectRequestFromJson(
  Map<String, dynamic> json,
) => _CreateProjectRequest(
  clientId: json['clientId'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  budgetAmount: (json['budgetAmount'] as num?)?.toDouble(),
  defaultBillableRate: (json['defaultBillableRate'] as num?)?.toDouble(),
  startDate: const NullableDateOnlyConverter().fromJson(
    json['startDate'] as String?,
  ),
  endDate: const NullableDateOnlyConverter().fromJson(
    json['endDate'] as String?,
  ),
);

Map<String, dynamic> _$CreateProjectRequestToJson(
  _CreateProjectRequest instance,
) => <String, dynamic>{
  'clientId': instance.clientId,
  'name': instance.name,
  'description': instance.description,
  'budgetAmount': instance.budgetAmount,
  'defaultBillableRate': instance.defaultBillableRate,
  'startDate': const NullableDateOnlyConverter().toJson(instance.startDate),
  'endDate': const NullableDateOnlyConverter().toJson(instance.endDate),
};
