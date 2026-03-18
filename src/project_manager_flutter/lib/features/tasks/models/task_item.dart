import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_item.freezed.dart';
part 'task_item.g.dart';

@freezed
abstract class TaskItem with _$TaskItem {
  const factory TaskItem({
    required String id,
    required String projectId,
    required String projectName,
    required String name,
    required String status,
    required String priority,
    String? assigneeId,
    String? assigneeName,
    String? dueDate,
    double? estimatedHours,
  }) = _TaskItem;

  factory TaskItem.fromJson(Map<String, dynamic> json) =>
      _$TaskItemFromJson(json);
}
