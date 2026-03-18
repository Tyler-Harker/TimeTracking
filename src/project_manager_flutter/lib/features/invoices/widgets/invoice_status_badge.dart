import 'package:flutter/material.dart';
import '../../../core/widgets/status_badge.dart';
import '../models/invoice_status.dart';

class InvoiceStatusBadge extends StatelessWidget {
  final InvoiceStatus status;

  const InvoiceStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return StatusBadge(label: status.displayName, color: status.color);
  }
}
