import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../models/create_organization_request.dart';
import '../models/organization.dart';
import '../models/organization_detail.dart';
import '../models/update_organization_request.dart';
import '../repository/organization_repository.dart';

final organizationRepositoryProvider = Provider<OrganizationRepository>((ref) {
  return OrganizationRepository(ref.watch(dioProvider));
});

final organizationsProvider =
    FutureProvider.autoDispose<List<Organization>>((ref) async {
  final repo = ref.watch(organizationRepositoryProvider);
  return repo.listOrganizations();
});

final organizationDetailProvider =
    FutureProvider.autoDispose.family<OrganizationDetail, String>(
  (ref, id) async {
    final repo = ref.watch(organizationRepositoryProvider);
    return repo.getOrganization(id);
  },
);

final createOrganizationProvider =
    FutureProvider.autoDispose.family<Organization, CreateOrganizationRequest>(
  (ref, request) async {
    final repo = ref.watch(organizationRepositoryProvider);
    final result = await repo.createOrganization(request);
    ref.invalidate(organizationsProvider);
    return result;
  },
);

final updateOrganizationProvider = FutureProvider.autoDispose
    .family<Organization, ({String id, UpdateOrganizationRequest request})>(
  (ref, params) async {
    final repo = ref.watch(organizationRepositoryProvider);
    final result = await repo.updateOrganization(params.id, params.request);
    ref.invalidate(organizationsProvider);
    ref.invalidate(organizationDetailProvider(params.id));
    return result;
  },
);

final deleteOrganizationProvider =
    FutureProvider.autoDispose.family<void, String>(
  (ref, id) async {
    final repo = ref.watch(organizationRepositoryProvider);
    await repo.deleteOrganization(id);
    ref.invalidate(organizationsProvider);
  },
);
