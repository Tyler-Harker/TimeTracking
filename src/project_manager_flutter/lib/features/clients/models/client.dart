import 'package:freezed_annotation/freezed_annotation.dart';

part 'client.freezed.dart';
part 'client.g.dart';

@freezed
abstract class Client with _$Client {
  const factory Client({
    required String id,
    required String name,
    required int contactCount,
    required bool isActive,
    double? defaultBillableRate,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) =>
      _$ClientFromJson(json);
}
