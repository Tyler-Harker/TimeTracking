import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/widgets/error_display.dart';
import '../models/add_line_item_request.dart';
import '../models/invoice_detail.dart';
import '../models/invoice_line_item.dart';
import '../models/invoice_status.dart';
import '../models/update_invoice_status_request.dart';
import '../../clients/providers/client_providers.dart';
import '../../dashboard/providers/dashboard_providers.dart';
import '../providers/invoice_providers.dart';
import '../widgets/invoice_status_badge.dart';
import '../widgets/line_item_tile.dart';

class InvoiceDetailScreen extends ConsumerWidget {
  final String invoiceId;

  const InvoiceDetailScreen({super.key, required this.invoiceId});

  InvoiceStatus _parseStatus(String status) {
    return InvoiceStatus.values.firstWhere(
      (e) => e.displayName == status,
      orElse: () => InvoiceStatus.draft,
    );
  }

  List<InvoiceStatus> _nextStatuses(InvoiceStatus current) {
    switch (current) {
      case InvoiceStatus.draft: return [InvoiceStatus.sent, InvoiceStatus.cancelled];
      case InvoiceStatus.sent: return [InvoiceStatus.paid, InvoiceStatus.overdue, InvoiceStatus.cancelled];
      case InvoiceStatus.overdue: return [InvoiceStatus.paid, InvoiceStatus.cancelled];
      case InvoiceStatus.paid: return [];
      case InvoiceStatus.cancelled: return [];
    }
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  Future<void> _emailInvoice(BuildContext context, WidgetRef ref, InvoiceDetail invoice) async {
    if (invoice.clientId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No client associated with this invoice')),
      );
      return;
    }

    try {
      final client = await ref.read(clientDetailProvider(invoice.clientId!).future);
      final invoicingContacts = client.contacts
          .where((c) => c.isInvoicing && c.email != null)
          .toList();

      if (invoicingContacts.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No invoicing contacts found for this client')),
          );
        }
        return;
      }

      final toEmails = invoicingContacts.map((c) => c.email!).join(',');
      final subject = Uri.encodeComponent(
        'Invoice ${invoice.invoiceNumber} - \$${invoice.totalAmount.toStringAsFixed(2)}',
      );
      final body = Uri.encodeComponent(
        'Please find attached invoice ${invoice.invoiceNumber}.\n\n'
        'Amount Due: \$${invoice.totalAmount.toStringAsFixed(2)}\n'
        'Due Date: ${_formatDate(invoice.dueDate)}\n\n'
        'Thank you.',
      );

      final uri = Uri.parse('mailto:$toEmails?subject=$subject&body=$body');
      if (!await launchUrl(uri)) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open email client')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoiceAsync = ref.watch(invoiceDetailProvider(invoiceId));

    return Scaffold(
      appBar: AppBar(title: const Text('Invoice Details')),
      body: invoiceAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.invalidate(invoiceDetailProvider(invoiceId)),
        ),
        data: (invoice) {
          final status = _parseStatus(invoice.status);
          final nextStatuses = _nextStatuses(status);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              invoice.invoiceNumber,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          InvoiceStatusBadge(status: status),
                        ],
                      ),
                      const SizedBox(height: 16),
                      _Row(label: 'Issued', value: _formatDate(invoice.issuedDate)),
                      _Row(label: 'Due', value: _formatDate(invoice.dueDate)),
                      if (invoice.paidDate != null)
                        _Row(label: 'Paid', value: _formatDate(invoice.paidDate!)),
                      const Divider(),
                      _Row(label: 'Subtotal', value: '\$${(invoice.totalAmount - invoice.taxAmount).toStringAsFixed(2)}'),
                      _Row(label: 'Tax (${invoice.taxRate}%)', value: '\$${invoice.taxAmount.toStringAsFixed(2)}'),
                      _Row(
                        label: 'Total',
                        value: '\$${invoice.totalAmount.toStringAsFixed(2)}',
                      ),
                      if (invoice.notes != null) ...[
                        const Divider(),
                        Text('Notes', style: TextStyle(color: AppColors.slate400, fontSize: 12)),
                        const SizedBox(height: 4),
                        Text(invoice.notes!),
                      ],
                    ],
                  ),
                ),
              ),
              if (nextStatuses.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: nextStatuses.map((s) => ElevatedButton(
                    onPressed: () async {
                      try {
                        await ref.read(invoiceRepositoryProvider).updateInvoiceStatus(
                          invoiceId,
                          UpdateInvoiceStatusRequest(status: s.displayName),
                        );
                        ref.invalidate(invoiceDetailProvider(invoiceId));
                        ref.invalidate(invoicesProvider);
                        ref.invalidate(dashboardProvider);
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: s.color),
                    child: Text('Mark as ${s.displayName}'),
                  )).toList(),
                ),
              ],
              if (invoice.clientId != null) ...[
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () => _emailInvoice(context, ref, invoice),
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Email Invoice'),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Line Items (${invoice.lineItems.length})',
                      style: Theme.of(context).textTheme.titleMedium),
                  if (status == InvoiceStatus.draft)
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => _showAddLineItemDialog(context, ref),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              ..._buildGroupedLineItems(context, invoice.lineItems),
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildGroupedLineItems(BuildContext context, List<InvoiceLineItem> lineItems) {
    final grouped = <String?, List<InvoiceLineItem>>{};
    for (final item in lineItems) {
      grouped.putIfAbsent(item.projectName, () => []).add(item);
    }

    final widgets = <Widget>[];
    for (final entry in grouped.entries) {
      if (grouped.length > 1 || entry.key != null) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 4),
          child: Text(
            entry.key ?? 'Other',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.slate400,
              fontSize: 13,
            ),
          ),
        ));
      }
      for (final item in entry.value) {
        widgets.add(LineItemTile(lineItem: item));
      }
    }
    return widgets;
  }

  void _showAddLineItemDialog(BuildContext context, WidgetRef ref) {
    final descController = TextEditingController();
    final qtyController = TextEditingController();
    final priceController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Line Item'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: qtyController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v == null || double.tryParse(v) == null ? 'Invalid' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Unit Price'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                validator: (v) => v == null || double.tryParse(v) == null ? 'Invalid' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              try {
                await ref.read(invoiceRepositoryProvider).addLineItem(
                  invoiceId,
                  AddLineItemRequest(
                    description: descController.text.trim(),
                    quantity: double.parse(qtyController.text),
                    unitPrice: double.parse(priceController.text),
                  ),
                );
                ref.invalidate(invoiceDetailProvider(invoiceId));
                if (context.mounted) Navigator.of(context).pop();
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(e.toString())),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: AppColors.slate400)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
