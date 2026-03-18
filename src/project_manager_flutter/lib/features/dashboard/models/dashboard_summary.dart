import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_summary.freezed.dart';
part 'dashboard_summary.g.dart';

@freezed
abstract class DashboardSummary with _$DashboardSummary {
  const factory DashboardSummary({
    required int clientCount,
    required int projectCount,
    required int activeProjectCount,
    required double totalHoursYtd,
    required double totalInvoicedYtd,
    required double totalUninvoicedHours,
    required double totalUninvoicedAmount,
  }) = _DashboardSummary;

  factory DashboardSummary.fromJson(Map<String, dynamic> json) =>
      _$DashboardSummaryFromJson(json);
}
