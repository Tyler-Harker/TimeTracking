import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/error_display.dart';
import '../providers/organization_providers.dart';

class OrganizationDetailScreen extends ConsumerWidget {
  final String organizationId;

  const OrganizationDetailScreen({super.key, required this.organizationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgAsync = ref.watch(organizationDetailProvider(organizationId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Organization Settings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await ConfirmDialog.show(
                context,
                title: 'Delete Organization',
                message: 'Are you sure you want to delete this organization?',
                confirmText: 'Delete',
                isDestructive: true,
              );
              if (confirmed) {
                try {
                  await ref
                      .read(organizationRepositoryProvider)
                      .deleteOrganization(organizationId);
                  ref.invalidate(organizationsProvider);
                  if (context.mounted) context.pop();
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
      body: orgAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorDisplay(
          message: error.toString(),
          onRetry: () =>
              ref.invalidate(organizationDetailProvider(organizationId)),
        ),
        data: (org) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      org.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(org.slug, style: TextStyle(color: AppColors.slate400)),
                    if (org.description != null) ...[
                      const SizedBox(height: 8),
                      Text(org.description!),
                    ],
                    if (org.defaultBillableRate != null) ...[
                      const SizedBox(height: 8),
                      Text('Default Rate: \$${org.defaultBillableRate!.toStringAsFixed(2)}/hr'),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Members (${org.members.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ...org.members.map(
              (member) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.indigo600,
                  child: Text(
                    '${member.firstName[0]}${member.lastName[0]}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text('${member.firstName} ${member.lastName}'),
                subtitle: Text(member.email),
                trailing: Chip(label: Text(member.role)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
