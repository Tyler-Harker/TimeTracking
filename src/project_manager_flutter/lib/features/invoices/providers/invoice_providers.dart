import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../models/invoice_detail.dart';
import '../models/paginated_invoices.dart';
import '../repository/invoice_repository.dart';

final invoiceRepositoryProvider = Provider<InvoiceRepository>((ref) {
  return InvoiceRepository(ref.watch(dioProvider));
});

final invoiceFilterProvider = StateProvider.autoDispose<InvoiceFilter>((ref) {
  return const InvoiceFilter();
});

class InvoiceFilter {
  final String? clientId;
  final String? status;
  final int page;

  const InvoiceFilter({this.clientId, this.status, this.page = 1});

  InvoiceFilter copyWith({
    String? clientId,
    String? status,
    int? page,
    bool clearClientId = false,
    bool clearStatus = false,
  }) {
    return InvoiceFilter(
      clientId: clearClientId ? null : (clientId ?? this.clientId),
      status: clearStatus ? null : (status ?? this.status),
      page: page ?? this.page,
    );
  }
}

final invoicesProvider =
    FutureProvider.autoDispose<PaginatedInvoices>((ref) async {
  final filter = ref.watch(invoiceFilterProvider);
  final repo = ref.watch(invoiceRepositoryProvider);
  return repo.listInvoices(
    clientId: filter.clientId,
    status: filter.status,
    page: filter.page,
  );
});

final invoiceDetailProvider =
    FutureProvider.autoDispose.family<InvoiceDetail, String>((ref, id) async {
  final repo = ref.watch(invoiceRepositoryProvider);
  return repo.getInvoice(id);
});
