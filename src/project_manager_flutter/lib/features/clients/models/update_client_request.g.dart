// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_client_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateClientRequest _$UpdateClientRequestFromJson(Map<String, dynamic> json) =>
    _UpdateClientRequest(
      name: json['name'] as String,
      address: json['address'] as String?,
      website: json['website'] as String?,
      defaultBillableRate: (json['defaultBillableRate'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$UpdateClientRequestToJson(
  _UpdateClientRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'address': instance.address,
  'website': instance.website,
  'defaultBillableRate': instance.defaultBillableRate,
};
