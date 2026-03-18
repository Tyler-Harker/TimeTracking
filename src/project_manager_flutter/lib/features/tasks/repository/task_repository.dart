import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exceptions.dart';
import '../models/create_task_request.dart';
import '../models/paginated_tasks.dart';
import '../models/task_detail.dart';
import '../models/task_item.dart';
import '../models/update_task_request.dart';

class TaskRepository {
  final Dio _dio;

  TaskRepository(this._dio);

  Future<PaginatedTasks> listTasks({
    String? projectId,
    String? assigneeId,
    String? status,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.tasks,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          if (projectId != null) 'projectId': projectId,
          if (assigneeId != null) 'assigneeId': assigneeId,
          if (status != null) 'status': status,
        },
      );
      return PaginatedTasks.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<TaskDetail> getTask(String id) async {
    try {
      final response = await _dio.get(ApiConstants.taskById(id));
      return TaskDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<void> createTask(CreateTaskRequest request) async {
    try {
      await _dio.post(ApiConstants.tasks, data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<void> updateTask(String id, UpdateTaskRequest request) async {
    try {
      await _dio.put(ApiConstants.taskById(id), data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await _dio.delete(ApiConstants.taskById(id));
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<List<TaskItem>> listTasksForProject(String projectId) async {
    final result = await listTasks(projectId: projectId, pageSize: 100);
    return result.items;
  }
}
