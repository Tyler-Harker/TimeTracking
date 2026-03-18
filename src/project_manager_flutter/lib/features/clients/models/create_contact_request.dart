import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_contact_request.freezed.dart';
part 'create_contact_request.g.dart';

@freezed
abstract class CreateContactRequest with _$CreateContactRequest {
  const factory CreateContactRequest({
    required String name,
    String? email,
    String? phone,
    @Default(false) bool isStakeHolder,
    @Default(false) bool isInvoicing,
  }) = _CreateContactRequest;

  factory CreateContactRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateContactRequestFromJson(json);
}
