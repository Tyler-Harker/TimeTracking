import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_contact.freezed.dart';
part 'client_contact.g.dart';

@freezed
abstract class ClientContact with _$ClientContact {
  const factory ClientContact({
    required String id,
    required String name,
    String? email,
    String? phone,
    required bool isStakeHolder,
    required bool isInvoicing,
    required DateTime createdAt,
  }) = _ClientContact;

  factory ClientContact.fromJson(Map<String, dynamic> json) =>
      _$ClientContactFromJson(json);
}
