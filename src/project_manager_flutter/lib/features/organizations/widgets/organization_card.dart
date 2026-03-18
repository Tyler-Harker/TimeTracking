import 'package:flutter/material.dart';
import '../../../core/theme/color_schemes.dart';
import '../models/organization.dart';

class OrganizationCard extends StatelessWidget {
  final Organization organization;
  final VoidCallback? onTap;

  const OrganizationCard({
    super.key,
    required this.organization,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.indigo600,
          child: Text(
            organization.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(organization.name),
        subtitle: organization.description != null
            ? Text(
                organization.description!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : null,
        trailing: organization.role != null
            ? Chip(
                label: Text(
                  organization.role!,
                  style: const TextStyle(fontSize: 12),
                ),
              )
            : const Icon(Icons.chevron_right),
      ),
    );
  }
}
