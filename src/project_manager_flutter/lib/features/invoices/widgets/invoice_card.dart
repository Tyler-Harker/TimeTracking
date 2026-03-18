import 'package:flutter/material.dart';
import '../../../core/theme/color_schemes.dart';
import '../models/invoice.dart';
import '../models/invoice_status.dart';
import 'invoice_status_badge.dart';

class InvoiceCard extends StatelessWidget {
  final Invoice invoice;
  final VoidCallback? onTap;

  const InvoiceCard({super.key, required this.invoice, this.onTap});

  InvoiceStatus _parseStatus(String status) {
    return InvoiceStatus.values.firstWhere(
      (e) => e.displayName == status,
      orElse: () => InvoiceStatus.draft,
    );
  }

  String _formatDate(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        title: Text(invoice.invoiceNumber),
        subtitle: Text(
          'Due: ${_formatDate(invoice.dueDate)}',
          style: TextStyle(color: AppColors.slate400),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '\$${invoice.totalAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 8),
            InvoiceStatusBadge(status: _parseStatus(invoice.status)),
          ],
        ),
      ),
    );
  }
}
