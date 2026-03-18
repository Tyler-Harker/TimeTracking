import 'package:freezed_annotation/freezed_annotation.dart';
import 'team_member.dart';

part 'team_detail.freezed.dart';
part 'team_detail.g.dart';

@freezed
abstract class TeamDetail with _$TeamDetail {
  const factory TeamDetail({
    required String id,
    required String projectId,
    required String name,
    String? description,
    required DateTime createdAt,
    @Default([]) List<TeamMember> members,
  }) = _TeamDetail;

  factory TeamDetail.fromJson(Map<String, dynamic> json) =>
      _$TeamDetailFromJson(json);
}
