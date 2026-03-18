import 'package:flutter/material.dart';
import '../../../core/theme/color_schemes.dart';
import '../models/team_member.dart';

class MemberListTile extends StatelessWidget {
  final TeamMember member;
  final VoidCallback? onRemove;

  const MemberListTile({super.key, required this.member, this.onRemove});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppColors.indigo600,
        child: Text(
          '${member.firstName[0]}${member.lastName[0]}',
          style: const TextStyle(color: Colors.white),
        ),
      ),
      title: Text('${member.firstName} ${member.lastName}'),
      subtitle: Text(member.email, style: TextStyle(color: AppColors.slate400)),
      trailing: onRemove != null
          ? IconButton(
              icon: Icon(Icons.remove_circle_outline, color: AppColors.error),
              onPressed: onRemove,
            )
          : null,
    );
  }
}
