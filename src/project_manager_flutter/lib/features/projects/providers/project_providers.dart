import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/core_providers.dart';
import '../models/project.dart';
import '../models/project_detail.dart';
import '../repository/project_repository.dart';

final projectRepositoryProvider = Provider<ProjectRepository>((ref) {
  return ProjectRepository(ref.watch(dioProvider));
});

final projectsProvider = FutureProvider.autoDispose.family<List<Project>, String?>(
  (ref, clientId) async {
    final repo = ref.watch(projectRepositoryProvider);
    return repo.listProjects(clientId: clientId);
  },
);

final allProjectsProvider = FutureProvider.autoDispose<List<Project>>((ref) async {
  final repo = ref.watch(projectRepositoryProvider);
  return repo.listProjects();
});

final projectDetailProvider =
    FutureProvider.autoDispose.family<ProjectDetail, String>((ref, id) async {
  final repo = ref.watch(projectRepositoryProvider);
  return repo.getProject(id);
});
