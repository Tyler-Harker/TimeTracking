// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClientDetail _$ClientDetailFromJson(Map<String, dynamic> json) =>
    _ClientDetail(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      website: json['website'] as String?,
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      defaultBillableRate: (json['defaultBillableRate'] as num?)?.toDouble(),
      inheritedBillableRate:
          (json['inheritedBillableRate'] as num?)?.toDouble(),
      contacts:
          (json['contacts'] as List<dynamic>?)
              ?.map((e) => ClientContact.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$ClientDetailToJson(_ClientDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'website': instance.website,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'defaultBillableRate': instance.defaultBillableRate,
      'inheritedBillableRate': instance.inheritedBillableRate,
      'contacts': instance.contacts.map((e) => e.toJson()).toList(),
    };
