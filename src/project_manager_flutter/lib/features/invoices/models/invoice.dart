import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../core/utils/json_converters.dart';

part 'invoice.freezed.dart';
part 'invoice.g.dart';

@freezed
abstract class Invoice with _$Invoice {
  const factory Invoice({
    required String id,
    required String invoiceNumber,
    required String status,
    required double totalAmount,
    @DateOnlyConverter() required DateTime issuedDate,
    @DateOnlyConverter() required DateTime dueDate,
  }) = _Invoice;

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);
}
