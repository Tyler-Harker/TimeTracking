import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_detail.freezed.dart';
part 'task_detail.g.dart';

@freezed
abstract class TaskDetail with _$TaskDetail {
  const factory TaskDetail({
    required String id,
    required String projectId,
    required String projectName,
    required String name,
    String? description,
    required String status,
    required String priority,
    String? assigneeId,
    String? assigneeName,
    String? dueDate,
    double? estimatedHours,
    required double totalHoursLogged,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TaskDetail;

  factory TaskDetail.fromJson(Map<String, dynamic> json) =>
      _$TaskDetailFromJson(json);
}
