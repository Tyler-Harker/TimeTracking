import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../models/update_user_request.dart';
import '../models/user_profile.dart';
import '../repository/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(ref.watch(dioProvider));
});

final currentUserProvider = FutureProvider.autoDispose<UserProfile>((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getCurrentUser();
});

final updateUserProvider =
    FutureProvider.autoDispose.family<UserProfile, UpdateUserRequest>(
  (ref, request) async {
    final repo = ref.watch(userRepositoryProvider);
    final result = await repo.updateUser(request);
    ref.invalidate(currentUserProvider);
    return result;
  },
);
