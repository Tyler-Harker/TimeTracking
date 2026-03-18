// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    _LoginResponse(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      expiresAt: json['expiresAt'] as String,
      organizations:
          (json['organizations'] as List<dynamic>)
              .map((e) => OrgMembership.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$LoginResponseToJson(_LoginResponse instance) =>
    <String, dynamic>{
      'token': instance.token,
      'refreshToken': instance.refreshToken,
      'expiresAt': instance.expiresAt,
      'organizations': instance.organizations.map((e) => e.toJson()).toList(),
    };

_OrgMembership _$OrgMembershipFromJson(Map<String, dynamic> json) =>
    _OrgMembership(
      organizationId: json['organizationId'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$OrgMembershipToJson(_OrgMembership instance) =>
    <String, dynamic>{
      'organizationId': instance.organizationId,
      'name': instance.name,
      'role': instance.role,
    };
