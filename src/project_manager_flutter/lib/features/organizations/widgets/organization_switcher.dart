import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/color_schemes.dart';
import '../providers/active_organization_provider.dart';
import '../providers/organization_providers.dart';

class OrganizationSwitcher extends ConsumerWidget {
  const OrganizationSwitcher({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orgsAsync = ref.watch(organizationsProvider);
    final activeOrgId = ref.watch(activeOrganizationNotifierProvider);

    return orgsAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (orgs) {
        final activeOrg = orgs.where((o) => o.id == activeOrgId).firstOrNull;
        if (activeOrg == null) return const SizedBox.shrink();

        return PopupMenuButton<String>(
          tooltip: 'Switch organization',
          offset: const Offset(0, 40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 14,
                  backgroundColor: AppColors.indigo600,
                  child: Text(
                    activeOrg.name[0],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  activeOrg.name,
                  style: TextStyle(color: AppColors.slate200),
                ),
                const SizedBox(width: 4),
                Icon(Icons.arrow_drop_down, color: AppColors.slate400),
              ],
            ),
          ),
          itemBuilder: (context) => [
            ...orgs.map(
              (org) => PopupMenuItem<String>(
                value: org.id,
                child: Row(
                  children: [
                    if (org.id == activeOrgId)
                      Icon(Icons.check, size: 18, color: AppColors.indigo400)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text(org.name),
                  ],
                ),
              ),
            ),
            const PopupMenuDivider(),
            PopupMenuItem<String>(
              value: '__manage__',
              child: Row(
                children: [
                  Icon(Icons.settings, size: 18, color: AppColors.slate400),
                  const SizedBox(width: 8),
                  const Text('Manage Organizations'),
                ],
              ),
            ),
          ],
          onSelected: (value) {
            if (value == '__manage__') {
              context.go('/organizations');
            } else {
              ref
                  .read(activeOrganizationNotifierProvider.notifier)
                  .setOrganization(value);
            }
          },
        );
      },
    );
  }
}
