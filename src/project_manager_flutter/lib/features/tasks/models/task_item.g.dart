// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskItem _$TaskItemFromJson(Map<String, dynamic> json) => _TaskItem(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  projectName: json['projectName'] as String,
  name: json['name'] as String,
  status: json['status'] as String,
  priority: json['priority'] as String,
  assigneeId: json['assigneeId'] as String?,
  assigneeName: json['assigneeName'] as String?,
  dueDate: json['dueDate'] as String?,
  estimatedHours: (json['estimatedHours'] as num?)?.toDouble(),
);

Map<String, dynamic> _$TaskItemToJson(_TaskItem instance) => <String, dynamic>{
  'id': instance.id,
  'projectId': instance.projectId,
  'projectName': instance.projectName,
  'name': instance.name,
  'status': instance.status,
  'priority': instance.priority,
  'assigneeId': instance.assigneeId,
  'assigneeName': instance.assigneeName,
  'dueDate': instance.dueDate,
  'estimatedHours': instance.estimatedHours,
};
