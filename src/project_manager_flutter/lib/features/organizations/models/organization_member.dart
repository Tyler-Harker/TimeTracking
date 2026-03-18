import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_member.freezed.dart';
part 'organization_member.g.dart';

@freezed
abstract class OrganizationMember with _$OrganizationMember {
  const factory OrganizationMember({
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
    required String role,
  }) = _OrganizationMember;

  factory OrganizationMember.fromJson(Map<String, dynamic> json) =>
      _$OrganizationMemberFromJson(json);
}
