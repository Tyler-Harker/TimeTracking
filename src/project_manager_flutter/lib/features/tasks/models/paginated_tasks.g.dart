// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paginated_tasks.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaginatedTasks _$PaginatedTasksFromJson(Map<String, dynamic> json) =>
    _PaginatedTasks(
      items:
          (json['items'] as List<dynamic>)
              .map((e) => TaskItem.fromJson(e as Map<String, dynamic>))
              .toList(),
      totalCount: (json['totalCount'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      pageSize: (json['pageSize'] as num).toInt(),
    );

Map<String, dynamic> _$PaginatedTasksToJson(_PaginatedTasks instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'totalCount': instance.totalCount,
      'page': instance.page,
      'pageSize': instance.pageSize,
    };
