import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exceptions.dart';
import '../models/update_user_request.dart';
import '../models/user_profile.dart';

class UserRepository {
  final Dio _dio;

  UserRepository(this._dio);

  Future<UserProfile> getCurrentUser() async {
    try {
      final response = await _dio.get(ApiConstants.currentUser);
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(
        e.response?.statusCode ?? 500,
        e.response?.data,
      );
    }
  }

  Future<UserProfile> updateUser(UpdateUserRequest request) async {
    try {
      final response = await _dio.put(
        ApiConstants.currentUser,
        data: request.toJson(),
      );
      return UserProfile.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(
        e.response?.statusCode ?? 500,
        e.response?.data,
      );
    }
  }
}
