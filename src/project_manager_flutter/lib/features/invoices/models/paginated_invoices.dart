import 'package:freezed_annotation/freezed_annotation.dart';
import 'invoice.dart';

part 'paginated_invoices.freezed.dart';
part 'paginated_invoices.g.dart';

@freezed
abstract class PaginatedInvoices with _$PaginatedInvoices {
  const factory PaginatedInvoices({
    required List<Invoice> items,
    required int totalCount,
    required int page,
    required int pageSize,
  }) = _PaginatedInvoices;

  factory PaginatedInvoices.fromJson(Map<String, dynamic> json) =>
      _$PaginatedInvoicesFromJson(json);
}
