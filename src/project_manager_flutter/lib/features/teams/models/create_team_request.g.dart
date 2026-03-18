// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_team_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateTeamRequest _$CreateTeamRequestFromJson(Map<String, dynamic> json) =>
    _CreateTeamRequest(
      projectId: json['projectId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$CreateTeamRequestToJson(_CreateTeamRequest instance) =>
    <String, dynamic>{
      'projectId': instance.projectId,
      'name': instance.name,
      'description': instance.description,
    };
