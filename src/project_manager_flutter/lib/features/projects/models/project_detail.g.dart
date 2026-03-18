// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProjectDetail _$ProjectDetailFromJson(Map<String, dynamic> json) =>
    _ProjectDetail(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      status: json['status'] as String,
      budgetAmount: (json['budgetAmount'] as num?)?.toDouble(),
      defaultBillableRate: (json['defaultBillableRate'] as num?)?.toDouble(),
      startDate: const NullableDateOnlyConverter().fromJson(
        json['startDate'] as String?,
      ),
      endDate: const NullableDateOnlyConverter().fromJson(
        json['endDate'] as String?,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      clientId: json['clientId'] as String,
      clientName: json['clientName'] as String,
      inheritedBillableRate:
          (json['inheritedBillableRate'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$ProjectDetailToJson(_ProjectDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'status': instance.status,
      'budgetAmount': instance.budgetAmount,
      'defaultBillableRate': instance.defaultBillableRate,
      'startDate': const NullableDateOnlyConverter().toJson(instance.startDate),
      'endDate': const NullableDateOnlyConverter().toJson(instance.endDate),
      'createdAt': instance.createdAt.toIso8601String(),
      'clientId': instance.clientId,
      'clientName': instance.clientName,
      'inheritedBillableRate': instance.inheritedBillableRate,
    };
