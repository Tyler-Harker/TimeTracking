// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_task_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateTaskRequest _$UpdateTaskRequestFromJson(Map<String, dynamic> json) =>
    _UpdateTaskRequest(
      name: json['name'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      priority: json['priority'] as String,
      assigneeId: json['assigneeId'] as String?,
      dueDate: json['dueDate'] as String?,
      estimatedHours: (json['estimatedHours'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UpdateTaskRequestToJson(_UpdateTaskRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'description': instance.description,
      'status': instance.status,
      'priority': instance.priority,
      'assigneeId': instance.assigneeId,
      'dueDate': instance.dueDate,
      'estimatedHours': instance.estimatedHours,
    };
