import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_task_request.freezed.dart';
part 'update_task_request.g.dart';

@freezed
abstract class UpdateTaskRequest with _$UpdateTaskRequest {
  const factory UpdateTaskRequest({
    required String name,
    String? description,
    required String status,
    required String priority,
    String? assigneeId,
    String? dueDate,
    double? estimatedHours,
  }) = _UpdateTaskRequest;

  factory UpdateTaskRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskRequestFromJson(json);
}
