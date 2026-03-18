import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice_line_item.freezed.dart';
part 'invoice_line_item.g.dart';

@freezed
abstract class InvoiceLineItem with _$InvoiceLineItem {
  const factory InvoiceLineItem({
    required String id,
    required String description,
    required double quantity,
    required double unitPrice,
    required double amount,
    String? projectName,
  }) = _InvoiceLineItem;

  factory InvoiceLineItem.fromJson(Map<String, dynamic> json) =>
      _$InvoiceLineItemFromJson(json);
}
