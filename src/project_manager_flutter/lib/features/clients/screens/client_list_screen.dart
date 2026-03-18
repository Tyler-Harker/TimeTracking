import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_display.dart';
import '../providers/client_providers.dart';
import '../widgets/client_card.dart';

class ClientListScreen extends ConsumerWidget {
  const ClientListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientsAsync = ref.watch(clientsProvider);

    return Scaffold(
      body: clientsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.invalidate(clientsProvider),
        ),
        data: (clients) {
          if (clients.isEmpty) {
            return EmptyState(
              icon: Icons.people_outline,
              title: 'No clients yet',
              subtitle: 'Add your first client to get started',
              action: ElevatedButton.icon(
                onPressed: () => context.goNamed(RouteNames.clientNew),
                icon: const Icon(Icons.add),
                label: const Text('Add Client'),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(clientsProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: clients.length,
              itemBuilder: (context, index) => ClientCard(
                client: clients[index],
                onTap: () => context.goNamed(
                  RouteNames.clientDetail,
                  pathParameters: {'id': clients[index].id},
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.goNamed(RouteNames.clientNew),
        child: const Icon(Icons.add),
      ),
    );
  }
}
