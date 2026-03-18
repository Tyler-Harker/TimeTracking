import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../network/api_interceptors.dart';
import '../network/dio_client.dart';
import '../storage/secure_storage_service.dart';
import '../storage/token_storage.dart';

final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage(ref.watch(secureStorageProvider));
});

final dioProvider = Provider<Dio>((ref) {
  final dio = createDioClient();
  final tokenStorage = ref.watch(tokenStorageProvider);

  // Add interceptors in order
  dio.interceptors.addAll([
    AuthInterceptor(tokenStorage),
    OrganizationInterceptor(
      () async => ref.read(activeOrganizationIdProvider),
    ),
    TokenRefreshInterceptor(
      dio,
      tokenStorage,
      () => ref.read(authActionProvider)?.call(),
    ),
    ErrorMappingInterceptor(),
  ]);

  return dio;
});

// These will be overridden by feature providers
final activeOrganizationIdProvider = StateProvider<String?>((ref) => null);
final authActionProvider = StateProvider<void Function()?>((ref) => null);
