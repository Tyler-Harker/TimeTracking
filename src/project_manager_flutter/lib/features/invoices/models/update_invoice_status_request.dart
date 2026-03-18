import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_invoice_status_request.freezed.dart';
part 'update_invoice_status_request.g.dart';

@freezed
abstract class UpdateInvoiceStatusRequest with _$UpdateInvoiceStatusRequest {
  const factory UpdateInvoiceStatusRequest({
    required String status,
  }) = _UpdateInvoiceStatusRequest;

  factory UpdateInvoiceStatusRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateInvoiceStatusRequestFromJson(json);
}
