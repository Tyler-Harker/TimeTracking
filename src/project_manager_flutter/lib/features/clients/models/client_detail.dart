import 'package:freezed_annotation/freezed_annotation.dart';
import 'client_contact.dart';

part 'client_detail.freezed.dart';
part 'client_detail.g.dart';

@freezed
abstract class ClientDetail with _$ClientDetail {
  const factory ClientDetail({
    required String id,
    required String name,
    String? address,
    String? website,
    required bool isActive,
    required DateTime createdAt,
    double? defaultBillableRate,
    double? inheritedBillableRate,
    @Default([]) List<ClientContact> contacts,
  }) = _ClientDetail;

  factory ClientDetail.fromJson(Map<String, dynamic> json) =>
      _$ClientDetailFromJson(json);
}
