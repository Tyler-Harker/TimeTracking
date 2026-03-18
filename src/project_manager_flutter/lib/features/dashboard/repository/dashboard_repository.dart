import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exceptions.dart';
import '../models/dashboard_summary.dart';

class DashboardRepository {
  final Dio _dio;

  DashboardRepository(this._dio);

  Future<DashboardSummary> getSummary() async {
    try {
      final response = await _dio.get(ApiConstants.dashboardSummary);
      return DashboardSummary.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(
        e.response?.statusCode ?? 500,
        e.response?.data,
      );
    }
  }
}
