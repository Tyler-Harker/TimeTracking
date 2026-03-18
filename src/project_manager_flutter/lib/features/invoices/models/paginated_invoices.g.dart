// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_invoices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginatedInvoices _$PaginatedInvoicesFromJson(Map<String, dynamic> json) =>
    _PaginatedInvoices(
      items:
          (json['items'] as List<dynamic>)
              .map((e) => Invoice.fromJson(e as Map<String, dynamic>))
              .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$PaginatedInvoicesToJson(_PaginatedInvoices instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'totalCount': instance.totalCount,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };
