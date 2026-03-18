// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_time_entry_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateTimeEntryRequest _$CreateTimeEntryRequestFromJson(
  Map<String, dynamic> json,
) => _CreateTimeEntryRequest(
  projectId: json['projectId'] as String,
  date: const DateOnlyConverter().fromJson(json['date'] as String),
  hours: (json['hours'] as num).toDouble(),
  description: json['description'] as String?,
  billableRate: (json['billableRate'] as num?)?.toDouble(),
  isBillable: json['isBillable'] as bool,
  taskId: json['taskId'] as String?,
);

Map<String, dynamic> _$CreateTimeEntryRequestToJson(
  _CreateTimeEntryRequest instance,
) => <String, dynamic>{
  'projectId': instance.projectId,
  'date': const DateOnlyConverter().toJson(instance.date),
  'hours': instance.hours,
  'description': instance.description,
  'billableRate': instance.billableRate,
  'isBillable': instance.isBillable,
  'taskId': instance.taskId,
};
