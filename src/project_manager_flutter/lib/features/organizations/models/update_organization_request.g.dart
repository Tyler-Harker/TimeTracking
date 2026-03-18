// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_organization_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UpdateOrganizationRequest _$UpdateOrganizationRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateOrganizationRequest(
  name: json['name'] as String,
  description: json['description'] as String?,
  defaultBillableRate: (json['defaultBillableRate'] as num?)?.toDouble(),
);

Map<String, dynamic> _$UpdateOrganizationRequestToJson(
  _UpdateOrganizationRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'description': instance.description,
  'defaultBillableRate': instance.defaultBillableRate,
};
