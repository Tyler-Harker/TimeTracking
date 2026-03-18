import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_contact_request.freezed.dart';
part 'update_contact_request.g.dart';

@freezed
abstract class UpdateContactRequest with _$UpdateContactRequest {
  const factory UpdateContactRequest({
    required String name,
    String? email,
    String? phone,
    @Default(false) bool isStakeHolder,
    @Default(false) bool isInvoicing,
  }) = _UpdateContactRequest;

  factory UpdateContactRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateContactRequestFromJson(json);
}
