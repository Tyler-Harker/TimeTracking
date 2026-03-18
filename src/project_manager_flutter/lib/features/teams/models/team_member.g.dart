// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_member.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamMember _$TeamMemberFromJson(Map<String, dynamic> json) => _TeamMember(
  userId: json['userId'] as String,
  email: json['email'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  joinedAt: DateTime.parse(json['joinedAt'] as String),
);

Map<String, dynamic> _$TeamMemberToJson(_TeamMember instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'joinedAt': instance.joinedAt.toIso8601String(),
    };
