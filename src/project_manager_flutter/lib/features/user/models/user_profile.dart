import 'package:freezed_annotation/freezed_annotation.dart';
import '../../auth/models/login_response.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    String? avatarUrl,
    @Default([]) List<OrgMembership> organizations,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      _$UserProfileFromJson(json);
}
