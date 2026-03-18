// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'time_entry_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TimeEntryDetail _$TimeEntryDetailFromJson(Map<String, dynamic> json) =>
    _TimeEntryDetail(
      id: json['id'] as String,
      userId: json['userId'] as String,
      userName: json['userName'] as String,
      projectId: json['projectId'] as String,
      projectName: json['projectName'] as String,
      date: const DateOnlyConverter().fromJson(json['date'] as String),
      hours: (json['hours'] as num).toDouble(),
      description: json['description'] as String?,
      billableRate: (json['billableRate'] as num?)?.toDouble(),
      isBillable: json['isBillable'] as bool,
      isInvoiced: json['isInvoiced'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      inheritedBillableRate:
          (json['inheritedBillableRate'] as num?)?.toDouble(),
      taskId: json['taskId'] as String?,
      taskName: json['taskName'] as String?,
    );

Map<String, dynamic> _$TimeEntryDetailToJson(_TimeEntryDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'userName': instance.userName,
      'projectId': instance.projectId,
      'projectName': instance.projectName,
      'date': const DateOnlyConverter().toJson(instance.date),
      'hours': instance.hours,
      'description': instance.description,
      'billableRate': instance.billableRate,
      'isBillable': instance.isBillable,
      'isInvoiced': instance.isInvoiced,
      'createdAt': instance.createdAt.toIso8601String(),
      'inheritedBillableRate': instance.inheritedBillableRate,
      'taskId': instance.taskId,
      'taskName': instance.taskName,
    };
