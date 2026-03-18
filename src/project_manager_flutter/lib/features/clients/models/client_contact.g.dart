// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ClientContact _$ClientContactFromJson(Map<String, dynamic> json) =>
    _ClientContact(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      isStakeHolder: json['isStakeHolder'] as bool,
      isInvoicing: json['isInvoicing'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$ClientContactToJson(_ClientContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'isStakeHolder': instance.isStakeHolder,
      'isInvoicing': instance.isInvoicing,
      'createdAt': instance.createdAt.toIso8601String(),
    };
