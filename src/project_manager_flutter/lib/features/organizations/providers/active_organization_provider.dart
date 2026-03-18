import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/storage/secure_storage_service.dart';

const _activeOrgKey = 'active_organization_id';

final activeOrganizationNotifierProvider =
    StateNotifierProvider<ActiveOrganizationNotifier, String?>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final notifier = ActiveOrganizationNotifier(storage, ref);
  notifier._loadFromStorage();
  return notifier;
});

class ActiveOrganizationNotifier extends StateNotifier<String?> {
  final SecureStorageService _storage;
  final Ref _ref;

  ActiveOrganizationNotifier(this._storage, this._ref) : super(null);

  Future<void> _loadFromStorage() async {
    final orgId = await _storage.read(_activeOrgKey);
    if (orgId != null) {
      state = orgId;
      _ref.read(activeOrganizationIdProvider.notifier).state = orgId;
    }
  }

  Future<void> setOrganization(String orgId) async {
    state = orgId;
    await _storage.write(_activeOrgKey, orgId);
    _ref.read(activeOrganizationIdProvider.notifier).state = orgId;
  }

  Future<void> clearOrganization() async {
    state = null;
    await _storage.delete(_activeOrgKey);
    _ref.read(activeOrganizationIdProvider.notifier).state = null;
  }
}
