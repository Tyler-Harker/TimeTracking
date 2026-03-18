import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_converters.dart';

part 'generate_invoice_request.freezed.dart';
part 'generate_invoice_request.g.dart';

@freezed
abstract class GenerateInvoiceRequest with _$GenerateInvoiceRequest {
  const factory GenerateInvoiceRequest({
    String? clientId,
    String? projectId,
    required double taxRate,
    String? notes,
    @DateOnlyConverter() required DateTime dueDate,
  }) = _GenerateInvoiceRequest;

  factory GenerateInvoiceRequest.fromJson(Map<String, dynamic> json) =>
      _$GenerateInvoiceRequestFromJson(json);
}
