import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_team_request.freezed.dart';
part 'create_team_request.g.dart';

@freezed
abstract class CreateTeamRequest with _$CreateTeamRequest {
  const factory CreateTeamRequest({
    required String projectId,
    required String name,
    String? description,
  }) = _CreateTeamRequest;

  factory CreateTeamRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateTeamRequestFromJson(json);
}
