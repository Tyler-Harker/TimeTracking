// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_member_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AddMemberResponse _$AddMemberResponseFromJson(Map<String, dynamic> json) =>
    _AddMemberResponse(
      teamId: json['teamId'] as String,
      userId: json['userId'] as String,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
    );

Map<String, dynamic> _$AddMemberResponseToJson(_AddMemberResponse instance) =>
    <String, dynamic>{
      'teamId': instance.teamId,
      'userId': instance.userId,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };
