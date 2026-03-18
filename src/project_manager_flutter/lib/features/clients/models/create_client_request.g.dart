// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_client_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateClientRequest _$CreateClientRequestFromJson(Map<String, dynamic> json) =>
    _CreateClientRequest(
      name: json['name'] as String,
      address: json['address'] as String?,
      website: json['website'] as String?,
      defaultBillableRate: (json['defaultBillableRate'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CreateClientRequestToJson(
  _CreateClientRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'address': instance.address,
  'website': instance.website,
  'defaultBillableRate': instance.defaultBillableRate,
};
