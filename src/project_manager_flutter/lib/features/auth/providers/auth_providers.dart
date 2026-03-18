import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/storage/token_storage.dart';
import '../models/auth_state.dart';
import '../models/login_request.dart';
import '../models/refresh_token_request.dart';
import '../models/register_request.dart';
import '../repository/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(dioProvider));
});

final authStateProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(tokenStorageProvider),
    ref.watch(secureStorageProvider),
    ref,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final TokenStorage _tokenStorage;
  final SecureStorageService _storage;
  final Ref _ref;

  static const _activeOrgKey = 'active_organization_id';

  AuthNotifier(this._repository, this._tokenStorage, this._storage, this._ref)
      : super(const AuthState.initial()) {
    // Defer registration to avoid modifying another provider during initialization
    Future.microtask(() {
      _ref.read(authActionProvider.notifier).state = logout;
      checkAuthStatus();
    });
  }

  Future<void> _restoreActiveOrganization() async {
    final orgId = await _storage.read(_activeOrgKey);
    if (orgId != null) {
      _ref.read(activeOrganizationIdProvider.notifier).state = orgId;
    }
  }

  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();

    // If the access token is still valid, we're good
    final hasValidToken = await _tokenStorage.hasValidToken();
    if (hasValidToken) {
      await _restoreActiveOrganization();
      state = const AuthState.authenticated(organizations: []);
      return;
    }

    // Access token expired or missing — try refreshing with the refresh token
    final accessToken = await _tokenStorage.getAccessToken();
    final refreshToken = await _tokenStorage.getRefreshToken();
    if (accessToken != null && refreshToken != null) {
      try {
        final response = await _repository.refreshToken(
          RefreshTokenRequest(token: accessToken, refreshToken: refreshToken),
        );
        await _tokenStorage.saveTokens(
          accessToken: response.token,
          refreshToken: response.refreshToken,
          expiresAt: response.expiresAt,
        );
        await _restoreActiveOrganization();
        state = const AuthState.authenticated(organizations: []);
        return;
      } catch (_) {
        // Refresh failed — fall through to unauthenticated
      }
    }

    await _tokenStorage.clearTokens();
    state = const AuthState.unauthenticated();
  }

  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      final response = await _repository.login(
        LoginRequest(email: email, password: password),
      );

      await _tokenStorage.saveTokens(
        accessToken: response.token,
        refreshToken: response.refreshToken,
        expiresAt: response.expiresAt,
      );

      state = AuthState.authenticated(organizations: response.organizations);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> register(String email, String password, String firstName, String lastName) async {
    state = const AuthState.loading();
    try {
      await _repository.register(
        RegisterRequest(
          email: email,
          password: password,
          firstName: firstName,
          lastName: lastName,
        ),
      );
      // After successful registration, auto-login
      await login(email, password);
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clearTokens();
    _ref.read(activeOrganizationIdProvider.notifier).state = null;
    state = const AuthState.unauthenticated();
  }
}
