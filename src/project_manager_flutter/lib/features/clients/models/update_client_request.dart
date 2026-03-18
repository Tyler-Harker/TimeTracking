import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_client_request.freezed.dart';
part 'update_client_request.g.dart';

@freezed
abstract class UpdateClientRequest with _$UpdateClientRequest {
  const factory UpdateClientRequest({
    required String name,
    String? address,
    String? website,
    double? defaultBillableRate,
  }) = _UpdateClientRequest;

  factory UpdateClientRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateClientRequestFromJson(json);
}
