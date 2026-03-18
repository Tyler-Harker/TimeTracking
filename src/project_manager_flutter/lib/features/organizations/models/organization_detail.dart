import 'package:freezed_annotation/freezed_annotation.dart';
import 'organization_member.dart';

part 'organization_detail.freezed.dart';
part 'organization_detail.g.dart';

@freezed
abstract class OrganizationDetail with _$OrganizationDetail {
  const factory OrganizationDetail({
    required String id,
    required String name,
    required String slug,
    String? description,
    required bool isActive,
    required DateTime createdAt,
    double? defaultBillableRate,
    @Default([]) List<OrganizationMember> members,
  }) = _OrganizationDetail;

  factory OrganizationDetail.fromJson(Map<String, dynamic> json) =>
      _$OrganizationDetailFromJson(json);
}
