import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/widgets/error_display.dart';
import '../../auth/providers/auth_providers.dart';
import '../providers/active_organization_provider.dart';
import '../providers/organization_providers.dart';
import '../widgets/organization_card.dart';
import 'organization_form_screen.dart';

class OrganizationListScreen extends ConsumerWidget {
  const OrganizationListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgsAsync = ref.watch(organizationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Organization'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
          ),
        ],
      ),
      body: orgsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.invalidate(organizationsProvider),
        ),
        data: (orgs) {
          if (orgs.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.business, size: 64, color: AppColors.slate600),
                  const SizedBox(height: 16),
                  Text(
                    'No organizations yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.slate300,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Create one to get started',
                    style: TextStyle(color: AppColors.slate500),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => _showCreateDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Organization'),
                  ),
                ],
              ),
            );
          }

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...orgs.map(
                    (org) => OrganizationCard(
                      organization: org,
                      onTap: () {
                        ref
                            .read(activeOrganizationNotifierProvider.notifier)
                            .setOrganization(org.id);
                        context.go('/dashboard');
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () => _showCreateDialog(context, ref),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Organization'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCreateDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => const OrganizationFormDialog(),
    );
  }
}
