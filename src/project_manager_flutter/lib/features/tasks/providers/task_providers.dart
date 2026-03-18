import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../models/paginated_tasks.dart';
import '../models/task_detail.dart';
import '../models/task_item.dart';
import '../repository/task_repository.dart';

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  return TaskRepository(ref.watch(dioProvider));
});

final projectTasksProvider =
    FutureProvider.autoDispose.family<PaginatedTasks, String>((ref, projectId) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.listTasks(projectId: projectId);
});

final taskDetailProvider =
    FutureProvider.autoDispose.family<TaskDetail, String>((ref, id) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.getTask(id);
});

final projectTaskListProvider =
    FutureProvider.autoDispose.family<List<TaskItem>, String>((ref, projectId) async {
  final repo = ref.watch(taskRepositoryProvider);
  return repo.listTasksForProject(projectId);
});
