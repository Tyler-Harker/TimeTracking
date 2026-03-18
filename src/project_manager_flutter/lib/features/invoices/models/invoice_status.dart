import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/material.dart';
import '../../../core/theme/color_schemes.dart';

enum InvoiceStatus {
  @JsonValue('Draft')
  draft,
  @JsonValue('Sent')
  sent,
  @JsonValue('Paid')
  paid,
  @JsonValue('Overdue')
  overdue,
  @JsonValue('Cancelled')
  cancelled;

  String get displayName {
    switch (this) {
      case InvoiceStatus.draft: return 'Draft';
      case InvoiceStatus.sent: return 'Sent';
      case InvoiceStatus.paid: return 'Paid';
      case InvoiceStatus.overdue: return 'Overdue';
      case InvoiceStatus.cancelled: return 'Cancelled';
    }
  }

  Color get color {
    switch (this) {
      case InvoiceStatus.draft: return AppColors.slate400;
      case InvoiceStatus.sent: return AppColors.info;
      case InvoiceStatus.paid: return AppColors.success;
      case InvoiceStatus.overdue: return AppColors.warning;
      case InvoiceStatus.cancelled: return AppColors.error;
    }
  }
}
