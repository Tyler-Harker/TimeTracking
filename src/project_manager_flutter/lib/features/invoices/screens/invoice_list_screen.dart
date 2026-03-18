import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_display.dart';
import '../../../core/widgets/paginated_list_view.dart';
import '../models/invoice_status.dart';
import '../providers/invoice_providers.dart';
import '../widgets/invoice_card.dart';

class InvoiceListScreen extends ConsumerWidget {
  const InvoiceListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoicesAsync = ref.watch(invoicesProvider);
    final filter = ref.watch(invoiceFilterProvider);

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.slate900,
              border: Border(bottom: BorderSide(color: AppColors.slate700)),
            ),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                SizedBox(
                  width: 160,
                  child: DropdownButtonFormField<String?>(
                    value: filter.status,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      const DropdownMenuItem(value: null, child: Text('All')),
                      ...InvoiceStatus.values.map(
                        (s) => DropdownMenuItem(value: s.displayName, child: Text(s.displayName)),
                      ),
                    ],
                    onChanged: (v) => ref.read(invoiceFilterProvider.notifier).state =
                        v == null
                            ? filter.copyWith(page: 1, clearStatus: true)
                            : filter.copyWith(status: v, page: 1),
                  ),
                ),
                if (filter.status != null || filter.clientId != null)
                  ActionChip(
                    label: const Text('Clear'),
                    avatar: const Icon(Icons.clear, size: 16),
                    onPressed: () => ref.read(invoiceFilterProvider.notifier).state =
                        const InvoiceFilter(),
                  ),
              ],
            ),
          ),
          Expanded(
            child: invoicesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => ErrorDisplay(
                message: error.toString(),
                onRetry: () => ref.invalidate(invoicesProvider),
              ),
              data: (paginated) {
                if (paginated.items.isEmpty) {
                  return EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'No invoices yet',
                    subtitle: 'Generate your first invoice',
                    action: ElevatedButton.icon(
                      onPressed: () => context.goNamed(RouteNames.invoiceGenerate),
                      icon: const Icon(Icons.add),
                      label: const Text('Generate Invoice'),
                    ),
                  );
                }

                return PaginatedListView(
                  items: paginated.items,
                  totalCount: paginated.totalCount,
                  page: paginated.page,
                  pageSize: paginated.pageSize,
                  isLoading: false,
                  itemBuilder: (context, invoice) => InvoiceCard(
                    invoice: invoice,
                    onTap: () => context.goNamed(
                      RouteNames.invoiceDetail,
                      pathParameters: {'id': invoice.id},
                    ),
                  ),
                  onNextPage: () => ref.read(invoiceFilterProvider.notifier).state =
                      filter.copyWith(page: filter.page + 1),
                  onPreviousPage: () => ref.read(invoiceFilterProvider.notifier).state =
                      filter.copyWith(page: filter.page - 1),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed(RouteNames.invoiceGenerate),
        child: const Icon(Icons.add),
      ),
    );
  }
}
