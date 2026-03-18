// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_time_entries.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginatedTimeEntries _$PaginatedTimeEntriesFromJson(
  Map<String, dynamic> json,
) => _PaginatedTimeEntries(
  items:
      (json['items'] as List<dynamic>)
          .map((e) => TimeEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
  totalCount: (json['totalCount'] as num).toInt(),
  page: (json['page'] as num).toInt(),
  pageSize: (json['pageSize'] as num).toInt(),
);

Map<String, dynamic> _$PaginatedTimeEntriesToJson(
  _PaginatedTimeEntries instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'totalCount': instance.totalCount,
  'page': instance.page,
  'pageSize': instance.pageSize,
};
