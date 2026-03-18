// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_contact_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreateContactRequest _$CreateContactRequestFromJson(
  Map<String, dynamic> json,
) => _CreateContactRequest(
  name: json['name'] as String,
  email: json['email'] as String?,
  phone: json['phone'] as String?,
  isStakeHolder: json['isStakeHolder'] as bool? ?? false,
  isInvoicing: json['isInvoicing'] as bool? ?? false,
);

Map<String, dynamic> _$CreateContactRequestToJson(
  _CreateContactRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'email': instance.email,
  'phone': instance.phone,
  'isStakeHolder': instance.isStakeHolder,
  'isInvoicing': instance.isInvoicing,
};
