import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_client_request.freezed.dart';
part 'create_client_request.g.dart';

@freezed
abstract class CreateClientRequest with _$CreateClientRequest {
  const factory CreateClientRequest({
    required String name,
    String? address,
    String? website,
    double? defaultBillableRate,
  }) = _CreateClientRequest;

  factory CreateClientRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateClientRequestFromJson(json);
}
