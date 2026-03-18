// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimeEntry _$TimeEntryFromJson(Map<String, dynamic> json) => _TimeEntry(
  id: json['id'] as String,
  userId: json['userId'] as String,
  userName: json['userName'] as String,
  projectId: json['projectId'] as String,
  projectName: json['projectName'] as String,
  date: const DateOnlyConverter().fromJson(json['date'] as String),
  hours: (json['hours'] as num).toDouble(),
  description: json['description'] as String?,
  isBillable: json['isBillable'] as bool,
  isInvoiced: json['isInvoiced'] as bool,
  taskId: json['taskId'] as String?,
  taskName: json['taskName'] as String?,
);

Map<String, dynamic> _$TimeEntryToJson(_TimeEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'projectId': instance.projectId,
      'projectName': instance.projectName,
      'date': const DateOnlyConverter().toJson(instance.date),
      'hours': instance.hours,
      'description': instance.description,
      'isBillable': instance.isBillable,
      'isInvoiced': instance.isInvoiced,
      'taskId': instance.taskId,
      'taskName': instance.taskName,
    };
