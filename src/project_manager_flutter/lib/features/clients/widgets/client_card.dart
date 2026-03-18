import 'package:flutter/material.dart';
import '../../../core/theme/color_schemes.dart';
import '../models/client.dart';

class ClientCard extends StatelessWidget {
  final Client client;
  final VoidCallback? onTap;

  const ClientCard({super.key, required this.client, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.indigo600,
          child: Text(
            client.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(client.name),
        subtitle: Text(
          client.contactCount == 1
              ? '1 contact'
              : '${client.contactCount} contacts',
        ),
        trailing: Container(
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
            ),
          ),
        ),
      ),
    );
  }
}
