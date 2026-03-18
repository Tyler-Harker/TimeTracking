import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exceptions.dart';
import '../models/create_organization_request.dart';
import '../models/organization.dart';
import '../models/organization_detail.dart';
import '../models/update_organization_request.dart';

class OrganizationRepository {
  final Dio _dio;

  OrganizationRepository(this._dio);

  Future<List<Organization>> listOrganizations() async {
    try {
      final response = await _dio.get(ApiConstants.organizations);
      return (response.data as List)
          .map((e) => Organization.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw ApiException.fromResponse(
        e.response?.statusCode ?? 500,
        e.response?.data,
      );
    }
  }

  Future<OrganizationDetail> getOrganization(String id) async {
    try {
      final response = await _dio.get(ApiConstants.organizationById(id));
      return OrganizationDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(
        e.response?.statusCode ?? 500,
        e.response?.data,
      );
    }
  }

  Future<Organization> createOrganization(CreateOrganizationRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.organizations,
        data: request.toJson(),
      );
      return Organization.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(
        e.response?.statusCode ?? 500,
        e.response?.data,
      );
    }
  }

  Future<Organization> updateOrganization(
      String id, UpdateOrganizationRequest request) async {
    try {
      final response = await _dio.put(
        ApiConstants.organizationById(id),
        data: request.toJson(),
      );
      return Organization.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(
        e.response?.statusCode ?? 500,
        e.response?.data,
      );
    }
  }

  Future<void> deleteOrganization(String id) async {
    try {
      await _dio.delete(ApiConstants.organizationById(id));
    } on DioException catch (e) {
      throw ApiException.fromResponse(
        e.response?.statusCode ?? 500,
        e.response?.data,
      );
    }
  }
}
