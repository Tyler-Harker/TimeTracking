// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrganizationDetail _$OrganizationDetailFromJson(Map<String, dynamic> json) =>
    _OrganizationDetail(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      defaultBillableRate: (json['defaultBillableRate'] as num?)?.toDouble(),
      members:
          (json['members'] as List<dynamic>?)
              ?.map(
                (e) => OrganizationMember.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );

Map<String, dynamic> _$OrganizationDetailToJson(_OrganizationDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'slug': instance.slug,
      'description': instance.description,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'defaultBillableRate': instance.defaultBillableRate,
      'members': instance.members.map((e) => e.toJson()).toList(),
    };
