import 'package:flutter/material.dart';
import '../../../core/theme/color_schemes.dart';
import '../models/team.dart';

class TeamCard extends StatelessWidget {
  final Team team;
  final VoidCallback? onTap;

  const TeamCard({super.key, required this.team, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: AppColors.indigo600,
          child: const Icon(Icons.group, color: Colors.white),
        ),
        title: Text(team.name),
        subtitle: team.description != null
            ? Text(team.description!, maxLines: 1, overflow: TextOverflow.ellipsis)
            : null,
        trailing: Chip(
          label: Text('${team.memberCount} members', style: const TextStyle(fontSize: 12)),
        ),
      ),
    );
  }
}
