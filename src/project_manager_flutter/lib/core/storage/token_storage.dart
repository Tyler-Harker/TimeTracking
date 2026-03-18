import 'secure_storage_service.dart';

class TokenStorage {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _expiresAtKey = 'expires_at';

  final SecureStorageService _storage;

  TokenStorage(this._storage);

  Future<String?> getAccessToken() => _storage.read(_accessTokenKey);
  Future<String?> getRefreshToken() => _storage.read(_refreshTokenKey);
  Future<String?> getExpiresAt() => _storage.read(_expiresAtKey);

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
    required String expiresAt,
  }) async {
    await _storage.write(_accessTokenKey, accessToken);
    await _storage.write(_refreshTokenKey, refreshToken);
    await _storage.write(_expiresAtKey, expiresAt);
  }

  Future<void> clearTokens() async {
    await _storage.delete(_accessTokenKey);
    await _storage.delete(_refreshTokenKey);
    await _storage.delete(_expiresAtKey);
  }

  Future<bool> hasValidToken() async {
    final token = await getAccessToken();
    final expiresAt = await getExpiresAt();
    if (token == null || expiresAt == null) return false;

    final expiry = DateTime.tryParse(expiresAt);
    if (expiry == null) return false;

    return expiry.isAfter(DateTime.now());
  }
}
