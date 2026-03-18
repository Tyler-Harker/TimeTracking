import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exceptions.dart';
import '../models/project.dart';
import '../models/project_detail.dart';
import '../models/create_project_request.dart';
import '../models/update_project_request.dart';

class ProjectRepository {
  final Dio _dio;

  ProjectRepository(this._dio);

  Future<List<Project>> listProjects({String? clientId}) async {
    try {
      final response = await _dio.get(
        ApiConstants.projects,
        queryParameters: {if (clientId != null) 'clientId': clientId},
      );
      return (response.data as List).map((e) => Project.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<ProjectDetail> getProject(String id) async {
    try {
      final response = await _dio.get(ApiConstants.projectById(id));
      return ProjectDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<void> createProject(CreateProjectRequest request) async {
    try {
      await _dio.post(ApiConstants.projects, data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<void> updateProject(String id, UpdateProjectRequest request) async {
    try {
      await _dio.put(ApiConstants.projectById(id), data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      await _dio.delete(ApiConstants.projectById(id));
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }
}
