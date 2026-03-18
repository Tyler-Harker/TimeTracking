// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_task_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateTaskRequest _$CreateTaskRequestFromJson(Map<String, dynamic> json) =>
    _CreateTaskRequest(
      projectId: json['projectId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      priority: json['priority'] as String,
      assigneeId: json['assigneeId'] as String?,
      dueDate: json['dueDate'] as String?,
      estimatedHours: (json['estimatedHours'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CreateTaskRequestToJson(_CreateTaskRequest instance) =>
    <String, dynamic>{
      'projectId': instance.projectId,
      'name': instance.name,
      'description': instance.description,
      'priority': instance.priority,
      'assigneeId': instance.assigneeId,
      'dueDate': instance.dueDate,
      'estimatedHours': instance.estimatedHours,
    };
