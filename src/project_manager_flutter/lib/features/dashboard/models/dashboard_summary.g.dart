// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardSummary _$DashboardSummaryFromJson(Map<String, dynamic> json) =>
    _DashboardSummary(
      clientCount: (json['clientCount'] as num).toInt(),
      projectCount: (json['projectCount'] as num).toInt(),
      activeProjectCount: (json['activeProjectCount'] as num).toInt(),
      totalHoursYtd: (json['totalHoursYtd'] as num).toDouble(),
      totalInvoicedYtd: (json['totalInvoicedYtd'] as num).toDouble(),
      totalUninvoicedHours: (json['totalUninvoicedHours'] as num).toDouble(),
      totalUninvoicedAmount: (json['totalUninvoicedAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$DashboardSummaryToJson(_DashboardSummary instance) =>
    <String, dynamic>{
      'clientCount': instance.clientCount,
      'projectCount': instance.projectCount,
      'activeProjectCount': instance.activeProjectCount,
      'totalHoursYtd': instance.totalHoursYtd,
      'totalInvoicedYtd': instance.totalInvoicedYtd,
      'totalUninvoicedHours': instance.totalUninvoicedHours,
      'totalUninvoicedAmount': instance.totalUninvoicedAmount,
    };
