// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Client _$ClientFromJson(Map<String, dynamic> json) => _Client(
  id: json['id'] as String,
  name: json['name'] as String,
  contactCount: (json['contactCount'] as num).toInt(),
  isActive: json['isActive'] as bool,
  defaultBillableRate: (json['defaultBillableRate'] as num?)?.toDouble(),
);

Map<String, dynamic> _$ClientToJson(_Client instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'contactCount': instance.contactCount,
  'isActive': instance.isActive,
  'defaultBillableRate': instance.defaultBillableRate,
};
