import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../features/organizations/widgets/organization_switcher.dart';

class AppScaffold extends ConsumerWidget {
  final Widget child;

  const AppScaffold({super.key, required this.child});

  static const _destinations = [
    _NavDestination(Icons.dashboard_outlined, Icons.dashboard, 'Dashboard', '/dashboard'),
    _NavDestination(Icons.people_outline, Icons.people, 'Clients', '/clients'),
    _NavDestination(Icons.folder_outlined, Icons.folder, 'Projects', '/projects'),
    _NavDestination(Icons.timer_outlined, Icons.timer, 'Time', '/time-entries'),
    _NavDestination(Icons.receipt_long_outlined, Icons.receipt_long, 'Invoices', '/invoices'),
  ];

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (var i = 0; i < _destinations.length; i++) {
      if (location.startsWith(_destinations[i].path)) return i;
    }
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    context.go(_destinations[index].path);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final selectedIndex = _selectedIndex(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ProjectManager'),
        actions: [
          const OrganizationSwitcher(),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.goNamed('profile'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authStateProvider.notifier).logout(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: width < 600
          ? child
          : Row(
              children: [
                NavigationRail(
                  extended: width > 900,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (i) =>
                      _onDestinationSelected(context, i),
                  destinations: _destinations
                      .map((d) => NavigationRailDestination(
                            icon: Icon(d.icon),
                            selectedIcon: Icon(d.selectedIcon),
                            label: Text(d.label),
                          ))
                      .toList(),
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: child),
              ],
            ),
      bottomNavigationBar: width < 600
          ? BottomNavigationBar(
              currentIndex: selectedIndex,
              onTap: (i) => _onDestinationSelected(context, i),
              type: BottomNavigationBarType.fixed,
              items: _destinations
                  .map((d) => BottomNavigationBarItem(
                        icon: Icon(d.icon),
                        activeIcon: Icon(d.selectedIcon),
                        label: d.label,
                      ))
                  .toList(),
            )
          : null,
    );
  }
}

class _NavDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String path;

  const _NavDestination(this.icon, this.selectedIcon, this.label, this.path);
}
