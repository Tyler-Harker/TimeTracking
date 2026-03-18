import 'package:freezed_annotation/freezed_annotation.dart';
import 'task_item.dart';

part 'paginated_tasks.freezed.dart';
part 'paginated_tasks.g.dart';

@freezed
abstract class PaginatedTasks with _$PaginatedTasks {
  const factory PaginatedTasks({
    required List<TaskItem> items,
    required int totalCount,
    required int page,
    required int pageSize,
  }) = _PaginatedTasks;

  factory PaginatedTasks.fromJson(Map<String, dynamic> json) =>
      _$PaginatedTasksFromJson(json);
}
