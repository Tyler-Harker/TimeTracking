import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_response.freezed.dart';
part 'login_response.g.dart';

@freezed
abstract class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    required String token,
    required String refreshToken,
    required String expiresAt,
    required List<OrgMembership> organizations,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@freezed
abstract class OrgMembership with _$OrgMembership {
  const factory OrgMembership({
    required String organizationId,
    required String name,
    required String role,
  }) = _OrgMembership;

  factory OrgMembership.fromJson(Map<String, dynamic> json) =>
      _$OrgMembershipFromJson(json);
}
