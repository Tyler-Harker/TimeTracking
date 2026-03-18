// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_time_entry_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateTimeEntryRequest _$UpdateTimeEntryRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateTimeEntryRequest(
  date: const DateOnlyConverter().fromJson(json['date'] as String),
  hours: (json['hours'] as num).toDouble(),
  description: json['description'] as String?,
  billableRate: (json['billableRate'] as num?)?.toDouble(),
  isBillable: json['isBillable'] as bool,
  taskId: json['taskId'] as String?,
);

Map<String, dynamic> _$UpdateTimeEntryRequestToJson(
  _UpdateTimeEntryRequest instance,
) => <String, dynamic>{
  'date': const DateOnlyConverter().toJson(instance.date),
  'hours': instance.hours,
  'description': instance.description,
  'billableRate': instance.billableRate,
  'isBillable': instance.isBillable,
  'taskId': instance.taskId,
};
