// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_organization_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateOrganizationRequest _$CreateOrganizationRequestFromJson(
  Map<String, dynamic> json,
) => _CreateOrganizationRequest(
  name: json['name'] as String,
  description: json['description'] as String?,
  defaultBillableRate: (json['defaultBillableRate'] as num?)?.toDouble(),
);

Map<String, dynamic> _$CreateOrganizationRequestToJson(
  _CreateOrganizationRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'defaultBillableRate': instance.defaultBillableRate,
};
