import 'package:freezed_annotation/freezed_annotation.dart';
import 'login_response.dart';

part 'auth_state.freezed.dart';

@Freezed(fromJson: false, toJson: false)
sealed class AuthState with _$AuthState {
  const factory AuthState.initial() = AuthInitial;
  const factory AuthState.loading() = AuthLoading;
  const factory AuthState.authenticated({
    required List<OrgMembership> organizations,
  }) = AuthAuthenticated;
  const factory AuthState.unauthenticated() = AuthUnauthenticated;
  const factory AuthState.error(String message) = AuthError;
}
