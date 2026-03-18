import 'dart:async';
import 'package:dio/dio.dart';
import '../storage/token_storage.dart';

class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;

  AuthInterceptor(this._tokenStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final path = options.path;
    // Skip auth header for auth endpoints
    if (path.contains('/api/auth/')) {
      handler.next(options);
      return;
    }

    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class OrganizationInterceptor extends Interceptor {
  final Future<String?> Function() _getOrganizationId;

  OrganizationInterceptor(this._getOrganizationId);

  static final _excludedPaths = [
    RegExp(r'^/api/auth/'),
    RegExp(r'^/api/organizations$'),
    RegExp(r'^/api/users/me$'),
  ];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final path = options.path;

    final isExcluded = _excludedPaths.any((pattern) => pattern.hasMatch(path));
    if (!isExcluded) {
      final orgId = await _getOrganizationId();
      if (orgId != null) {
        options.headers['X-Organization-Id'] = orgId;
      }
    }
    handler.next(options);
  }
}

class TokenRefreshInterceptor extends Interceptor {
  final Dio _dio;
  final TokenStorage _tokenStorage;
  final void Function() _onRefreshFailed;

  bool _isRefreshing = false;
  Completer<String?>? _refreshCompleter;

  TokenRefreshInterceptor(this._dio, this._tokenStorage, this._onRefreshFailed);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401 ||
        err.requestOptions.path.contains('/api/auth/')) {
      handler.next(err);
      return;
    }

    try {
      final newToken = await _refreshTokens();
      if (newToken != null) {
        // Retry original request with new token
        final opts = err.requestOptions;
        opts.headers['Authorization'] = 'Bearer $newToken';
        final response = await _dio.fetch(opts);
        handler.resolve(response);
        return;
      }
    } catch (_) {
      // Refresh failed
    }

    _onRefreshFailed();
    handler.next(err);
  }

  Future<String?> _refreshTokens() async {
    if (_isRefreshing) {
      // Wait for the in-flight refresh to complete
      return _refreshCompleter?.future;
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<String?>();

    try {
      final token = await _tokenStorage.getAccessToken();
      final refreshToken = await _tokenStorage.getRefreshToken();

      if (token == null || refreshToken == null) {
        _refreshCompleter!.complete(null);
        return null;
      }

      final response = await _dio.post(
        '/api/auth/refresh-token',
        data: {'token': token, 'refreshToken': refreshToken},
      );

      final newToken = response.data['token'] as String;
      final newRefreshToken = response.data['refreshToken'] as String;
      final expiresAt = response.data['expiresAt'] as String;

      await _tokenStorage.saveTokens(
        accessToken: newToken,
        refreshToken: newRefreshToken,
        expiresAt: expiresAt,
      );

      _refreshCompleter!.complete(newToken);
      return newToken;
    } catch (e) {
      _refreshCompleter!.complete(null);
      rethrow;
    } finally {
      _isRefreshing = false;
      _refreshCompleter = null;
    }
  }
}

class ErrorMappingInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Let the repository layer handle error mapping via ApiException.fromResponse
    handler.next(err);
  }
}
