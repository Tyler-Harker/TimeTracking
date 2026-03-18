import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exceptions.dart';
import '../models/create_time_entry_request.dart';
import '../models/paginated_time_entries.dart';
import '../models/time_entry_detail.dart';
import '../models/update_time_entry_request.dart';

class TimeEntryRepository {
  final Dio _dio;

  TimeEntryRepository(this._dio);

  Future<PaginatedTimeEntries> listTimeEntries({
    String? projectId,
    String? userId,
    String? fromDate,
    String? toDate,
    String? taskId,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get(
        ApiConstants.timeEntries,
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          if (projectId != null) 'projectId': projectId,
          if (userId != null) 'userId': userId,
          if (fromDate != null) 'fromDate': fromDate,
          if (toDate != null) 'toDate': toDate,
          if (taskId != null) 'taskId': taskId,
        },
      );
      return PaginatedTimeEntries.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<TimeEntryDetail> getTimeEntry(String id) async {
    try {
      final response = await _dio.get(ApiConstants.timeEntryById(id));
      return TimeEntryDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<void> createTimeEntry(CreateTimeEntryRequest request) async {
    try {
      await _dio.post(ApiConstants.timeEntries, data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<void> updateTimeEntry(String id, UpdateTimeEntryRequest request) async {
    try {
      await _dio.put(ApiConstants.timeEntryById(id), data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<void> deleteTimeEntry(String id) async {
    try {
      await _dio.delete(ApiConstants.timeEntryById(id));
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }
}
