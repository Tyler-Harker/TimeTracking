import 'package:flutter/material.dart';
import '../../../core/theme/color_schemes.dart';
import '../models/invoice_line_item.dart';

class LineItemTile extends StatelessWidget {
  final InvoiceLineItem lineItem;

  const LineItemTile({super.key, required this.lineItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lineItem.description, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${lineItem.quantity} x \$${lineItem.unitPrice.toStringAsFixed(2)}',
                  style: TextStyle(color: AppColors.slate400, fontSize: 13),
                ),
                Text(
                  '\$${lineItem.amount.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
