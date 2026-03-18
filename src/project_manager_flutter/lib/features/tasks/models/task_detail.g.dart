// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskDetail _$TaskDetailFromJson(Map<String, dynamic> json) => _TaskDetail(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  projectName: json['projectName'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  status: json['status'] as String,
  priority: json['priority'] as String,
  assigneeId: json['assigneeId'] as String?,
  assigneeName: json['assigneeName'] as String?,
  dueDate: json['dueDate'] as String?,
  estimatedHours: (json['estimatedHours'] as num?)?.toDouble(),
  totalHoursLogged: (json['totalHoursLogged'] as num).toDouble(),
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$TaskDetailToJson(_TaskDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'projectName': instance.projectName,
      'name': instance.name,
      'description': instance.description,
      'status': instance.status,
      'priority': instance.priority,
      'assigneeId': instance.assigneeId,
      'assigneeName': instance.assigneeName,
      'dueDate': instance.dueDate,
      'estimatedHours': instance.estimatedHours,
      'totalHoursLogged': instance.totalHoursLogged,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
