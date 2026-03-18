// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Project _$ProjectFromJson(Map<String, dynamic> json) => _Project(
  id: json['id'] as String,
  name: json['name'] as String,
  status: json['status'] as String,
  clientId: json['clientId'] as String,
  clientName: json['clientName'] as String,
  budgetAmount: (json['budgetAmount'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ProjectToJson(_Project instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'status': instance.status,
  'clientId': instance.clientId,
  'clientName': instance.clientName,
  'budgetAmount': instance.budgetAmount,
};
