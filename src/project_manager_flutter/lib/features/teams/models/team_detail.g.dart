// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'team_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeamDetail _$TeamDetailFromJson(Map<String, dynamic> json) => _TeamDetail(
  id: json['id'] as String,
  projectId: json['projectId'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  members:
      (json['members'] as List<dynamic>?)
          ?.map((e) => TeamMember.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$TeamDetailToJson(_TeamDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'projectId': instance.projectId,
      'name': instance.name,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'members': instance.members.map((e) => e.toJson()).toList(),
    };
