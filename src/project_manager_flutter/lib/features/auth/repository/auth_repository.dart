import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exceptions.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';
import '../models/refresh_token_request.dart';
import '../models/refresh_token_response.dart';
import '../models/register_request.dart';
import '../models/register_response.dart';

class AuthRepository {
  final Dio _dio;

  AuthRepository(this._dio);

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(
        e.response?.statusCode ?? 500,
        e.response?.data,
      );
    }
  }

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );
      return RegisterResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(
        e.response?.statusCode ?? 500,
        e.response?.data,
      );
    }
  }

  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: request.toJson(),
      );
      return RefreshTokenResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(
        e.response?.statusCode ?? 500,
        e.response?.data,
      );
    }
  }
}
