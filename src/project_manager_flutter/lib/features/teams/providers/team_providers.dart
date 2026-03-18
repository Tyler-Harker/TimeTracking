import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../models/team.dart';
import '../models/team_detail.dart';
import '../repository/team_repository.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepository(ref.watch(dioProvider));
});

final teamsProvider = FutureProvider.autoDispose.family<List<Team>, String>(
  (ref, projectId) async {
    final repo = ref.watch(teamRepositoryProvider);
    return repo.listTeams(projectId);
  },
);

final teamDetailProvider =
    FutureProvider.autoDispose.family<TeamDetail, String>((ref, id) async {
  final repo = ref.watch(teamRepositoryProvider);
  return repo.getTeam(id);
});
