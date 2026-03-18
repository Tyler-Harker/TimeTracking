import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_organization_request.freezed.dart';
part 'create_organization_request.g.dart';

@freezed
abstract class CreateOrganizationRequest with _$CreateOrganizationRequest {
  const factory CreateOrganizationRequest({
    required String name,
    String? description,
    double? defaultBillableRate,
  }) = _CreateOrganizationRequest;

  factory CreateOrganizationRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrganizationRequestFromJson(json);
}
