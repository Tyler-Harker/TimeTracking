import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_member_response.freezed.dart';
part 'add_member_response.g.dart';

@freezed
abstract class AddMemberResponse with _$AddMemberResponse {
  const factory AddMemberResponse({
    required String teamId,
    required String userId,
    required DateTime joinedAt,
  }) = _AddMemberResponse;

  factory AddMemberResponse.fromJson(Map<String, dynamic> json) =>
      _$AddMemberResponseFromJson(json);
}
