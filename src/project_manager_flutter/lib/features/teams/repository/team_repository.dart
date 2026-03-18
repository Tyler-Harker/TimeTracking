import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_exceptions.dart';
import '../models/add_member_request.dart';
import '../models/add_member_response.dart';
import '../models/create_team_request.dart';
import '../models/team.dart';
import '../models/team_detail.dart';

class TeamRepository {
  final Dio _dio;

  TeamRepository(this._dio);

  Future<List<Team>> listTeams(String projectId) async {
    try {
      final response = await _dio.get(
        ApiConstants.teams,
        queryParameters: {'projectId': projectId},
      );
      return (response.data as List).map((e) => Team.fromJson(e)).toList();
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<TeamDetail> getTeam(String id) async {
    try {
      final response = await _dio.get(ApiConstants.teamById(id));
      return TeamDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<void> createTeam(CreateTeamRequest request) async {
    try {
      await _dio.post(ApiConstants.teams, data: request.toJson());
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<AddMemberResponse> addMember(String teamId, AddMemberRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.teamMembers(teamId),
        data: request.toJson(),
      );
      return AddMemberResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }

  Future<void> removeMember(String teamId, String userId) async {
    try {
      await _dio.delete(ApiConstants.teamMember(teamId, userId));
    } on DioException catch (e) {
      throw ApiException.fromResponse(e.response?.statusCode ?? 500, e.response?.data);
    }
  }
}
