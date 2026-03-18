import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/routing/route_names.dart';
import '../../../core/theme/color_schemes.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/error_display.dart';
import '../../projects/providers/project_providers.dart';
import '../../projects/widgets/project_card.dart';
import '../models/client_contact.dart';
import '../providers/client_providers.dart';

class ClientDetailScreen extends ConsumerWidget {
  final String clientId;

  const ClientDetailScreen({super.key, required this.clientId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clientAsync = ref.watch(clientDetailProvider(clientId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Client Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => context.goNamed(
              RouteNames.clientEdit,
              pathParameters: {'id': clientId},
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final confirmed = await ConfirmDialog.show(
                context,
                title: 'Delete Client',
                message: 'Are you sure you want to delete this client?',
                confirmText: 'Delete',
                isDestructive: true,
              );
              if (confirmed) {
                try {
                  await ref.read(clientRepositoryProvider).deleteClient(clientId);
                  ref.invalidate(clientsProvider);
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
      body: clientAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => ErrorDisplay(
          message: error.toString(),
          onRetry: () => ref.invalidate(clientDetailProvider(clientId)),
        ),
        data: (client) {
          final projectsAsync = ref.watch(projectsProvider(clientId));

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              client.name,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: client.isActive
                                  ? AppColors.success.withValues(alpha: 0.15)
                                  : AppColors.slate600.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              client.isActive ? 'Active' : 'Inactive',
                              style: TextStyle(
                                color: client.isActive ? AppColors.success : AppColors.slate400,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (client.address != null)
                        _DetailRow(icon: Icons.location_on, label: 'Address', value: client.address!),
                      if (client.website != null)
                        _DetailRow(icon: Icons.language, label: 'Website', value: client.website!),
                      if (client.defaultBillableRate != null)
                        _DetailRow(icon: Icons.attach_money, label: 'Default Rate', value: '\$${client.defaultBillableRate!.toStringAsFixed(2)}/hr')
                      else if (client.inheritedBillableRate != null)
                        _DetailRow(icon: Icons.attach_money, label: 'Rate (inherited)', value: '\$${client.inheritedBillableRate!.toStringAsFixed(2)}/hr'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Contacts section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Contacts',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.slate600.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${client.contacts.length}',
                          style: TextStyle(
                            color: AppColors.slate400,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.person_add),
                    onPressed: () => context.goNamed(
                      RouteNames.contactNew,
                      pathParameters: {'id': clientId},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              if (client.contacts.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    'No contacts yet',
                    style: TextStyle(color: AppColors.slate400),
                  ),
                )
              else
                ...client.contacts.map((contact) => _ContactCard(
                  contact: contact,
                  onEdit: () => context.goNamed(
                    RouteNames.contactEdit,
                    pathParameters: {'id': clientId, 'contactId': contact.id},
                  ),
                  onRemove: () => _removeContact(context, ref, contact),
                )),
              const SizedBox(height: 24),
              // Projects section
              projectsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, _) => ErrorDisplay(
                  message: error.toString(),
                  onRetry: () => ref.invalidate(projectsProvider(clientId)),
                ),
                data: (projects) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Projects',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.slate600.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${projects.length}',
                                style: TextStyle(
                                  color: AppColors.slate400,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => context.pushNamed(
                            RouteNames.projectNew,
                            queryParameters: {'clientId': clientId},
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (projects.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(
                          'No projects yet',
                          style: TextStyle(color: AppColors.slate400),
                        ),
                      )
                    else
                      ...projects.map((project) => ProjectCard(
                        project: project,
                        onTap: () => context.pushNamed(
                          RouteNames.projectDetail,
                          pathParameters: {'id': project.id},
                        ),
                      )),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _removeContact(BuildContext context, WidgetRef ref, ClientContact contact) async {
    final confirmed = await ConfirmDialog.show(
      context,
      title: 'Remove Contact',
      message: 'Remove ${contact.name} from this client?',
      confirmText: 'Remove',
      isDestructive: true,
    );
    if (confirmed) {
      try {
        await ref.read(clientRepositoryProvider).removeContact(clientId, contact.id);
        ref.invalidate(clientDetailProvider(clientId));
        ref.invalidate(clientsProvider);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        }
      }
    }
  }
}

class _ContactCard extends StatelessWidget {
  final ClientContact contact;
  final VoidCallback? onEdit;
  final VoidCallback? onRemove;

  const _ContactCard({required this.contact, this.onEdit, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.indigo600,
              radius: 18,
              child: Text(
                contact.name[0].toUpperCase(),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(contact.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  if (contact.email != null)
                    Text(contact.email!, style: TextStyle(color: AppColors.slate400, fontSize: 13)),
                  if (contact.phone != null)
                    Text(contact.phone!, style: TextStyle(color: AppColors.slate400, fontSize: 13)),
                  if (contact.isStakeHolder || contact.isInvoicing)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Wrap(
                        spacing: 6,
                        children: [
                          if (contact.isStakeHolder)
                            _Badge(label: 'Stakeholder', color: AppColors.indigo600),
                          if (contact.isInvoicing)
                            _Badge(label: 'Invoicing', color: AppColors.success),
                        ],
                      ),
                    ),
                ],
              ),
            ),
            if (onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 20),
                onPressed: onEdit,
              ),
            if (onRemove != null)
              IconButton(
                icon: Icon(Icons.remove_circle_outline, size: 20, color: AppColors.error),
                onPressed: onRemove,
              ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.slate400),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: AppColors.slate500, fontSize: 12)),
              Text(value),
            ],
          ),
        ],
      ),
    );
  }
}
