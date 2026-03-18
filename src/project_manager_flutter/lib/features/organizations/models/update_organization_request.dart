import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_organization_request.freezed.dart';
part 'update_organization_request.g.dart';

@freezed
abstract class UpdateOrganizationRequest with _$UpdateOrganizationRequest {
  const factory UpdateOrganizationRequest({
    required String name,
    String? description,
    double? defaultBillableRate,
  }) = _UpdateOrganizationRequest;

  factory UpdateOrganizationRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateOrganizationRequestFromJson(json);
}
