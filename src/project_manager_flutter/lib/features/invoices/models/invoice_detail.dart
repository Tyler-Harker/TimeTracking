import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_converters.dart';
import 'invoice_line_item.dart';

part 'invoice_detail.freezed.dart';
part 'invoice_detail.g.dart';

@freezed
abstract class InvoiceDetail with _$InvoiceDetail {
  const factory InvoiceDetail({
    required String id,
    required String invoiceNumber,
    required String status,
    String? clientId,
    String? projectId,
    required double totalAmount,
    required double taxRate,
    required double taxAmount,
    String? notes,
    @DateOnlyConverter() required DateTime issuedDate,
    @DateOnlyConverter() required DateTime dueDate,
    @NullableDateOnlyConverter() DateTime? paidDate,
    @Default([]) List<InvoiceLineItem> lineItems,
  }) = _InvoiceDetail;

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) =>
      _$InvoiceDetailFromJson(json);
}
