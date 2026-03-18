import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_member.freezed.dart';
part 'team_member.g.dart';

@freezed
abstract class TeamMember with _$TeamMember {
  const factory TeamMember({
    required String userId,
    required String email,
    required String firstName,
    required String lastName,
    required DateTime joinedAt,
  }) = _TeamMember;

  factory TeamMember.fromJson(Map<String, dynamic> json) =>
      _$TeamMemberFromJson(json);
}
