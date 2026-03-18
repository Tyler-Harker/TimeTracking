// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RefreshTokenResponse _$RefreshTokenResponseFromJson(
  Map<String, dynamic> json,
) => _RefreshTokenResponse(
  token: json['token'] as String,
  refreshToken: json['refreshToken'] as String,
  expiresAt: json['expiresAt'] as String,
);

Map<String, dynamic> _$RefreshTokenResponseToJson(
  _RefreshTokenResponse instance,
) => <String, dynamic>{
  'token': instance.token,
  'refreshToken': instance.refreshToken,
  'expiresAt': instance.expiresAt,
};
