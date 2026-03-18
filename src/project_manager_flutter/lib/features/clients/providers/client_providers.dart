import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../models/client.dart';
import '../models/client_contact.dart';
import '../models/client_detail.dart';
import '../repository/client_repository.dart';

final clientRepositoryProvider = Provider<ClientRepository>((ref) {
  return ClientRepository(ref.watch(dioProvider));
});

final clientsProvider = FutureProvider.autoDispose<List<Client>>((ref) async {
  final repo = ref.watch(clientRepositoryProvider);
  return repo.listClients();
});

final clientDetailProvider =
    FutureProvider.autoDispose.family<ClientDetail, String>((ref, id) async {
  final repo = ref.watch(clientRepositoryProvider);
  return repo.getClient(id);
});

final clientContactsProvider =
    FutureProvider.autoDispose.family<List<ClientContact>, String>(
        (ref, clientId) async {
  final repo = ref.watch(clientRepositoryProvider);
  return repo.listContacts(clientId);
});
