// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_project_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateProjectRequest _$UpdateProjectRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateProjectRequest(
  name: json['name'] as String,
  description: json['description'] as String?,
  status: json['status'] as String,
  budgetAmount: (json['budgetAmount'] as num?)?.toDouble(),
  defaultBillableRate: (json['defaultBillableRate'] as num?)?.toDouble(),
  startDate: const NullableDateOnlyConverter().fromJson(
    json['startDate'] as String?,
  ),
  endDate: const NullableDateOnlyConverter().fromJson(
    json['endDate'] as String?,
  ),
);

Map<String, dynamic> _$UpdateProjectRequestToJson(
  _UpdateProjectRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'status': instance.status,
  'budgetAmount': instance.budgetAmount,
  'defaultBillableRate': instance.defaultBillableRate,
  'startDate': const NullableDateOnlyConverter().toJson(instance.startDate),
  'endDate': const NullableDateOnlyConverter().toJson(instance.endDate),
};
