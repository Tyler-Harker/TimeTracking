import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/models/auth_state.dart';
import '../../features/auth/providers/auth_providers.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/clients/screens/client_detail_screen.dart';
import '../../features/clients/screens/client_form_screen.dart';
import '../../features/clients/screens/client_list_screen.dart';
import '../../features/clients/screens/contact_form_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/invoices/screens/invoice_detail_screen.dart';
import '../../features/invoices/screens/invoice_generate_screen.dart';
import '../../features/invoices/screens/invoice_list_screen.dart';
import '../../features/organizations/screens/organization_detail_screen.dart';
import '../../features/organizations/screens/organization_list_screen.dart';
import '../../features/projects/screens/project_detail_screen.dart';
import '../../features/projects/screens/project_form_screen.dart';
import '../../features/projects/screens/project_list_screen.dart';
import '../../features/tasks/screens/task_detail_screen.dart';
import '../../features/tasks/screens/task_form_screen.dart';
import '../../features/teams/screens/team_detail_screen.dart';
import '../../features/teams/screens/team_form_screen.dart';
import '../../features/teams/screens/team_list_screen.dart';
import '../../features/time_entries/screens/time_entry_form_screen.dart';
import '../../features/time_entries/screens/time_entry_list_screen.dart';
import '../../features/user/screens/profile_screen.dart';
import '../providers/core_providers.dart';
import '../widgets/app_scaffold.dart';
import 'route_names.dart';

class _RouterRefreshNotifier extends ChangeNotifier {
  _RouterRefreshNotifier(Ref ref) {
    ref.listen(authStateProvider, (_, __) => notifyListeners());
    ref.listen(activeOrganizationIdProvider, (_, __) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = _RouterRefreshNotifier(ref);

  final router = GoRouter(
    initialLocation: '/login',
    refreshListenable: refreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final activeOrgId = ref.read(activeOrganizationIdProvider);
      final isAuth = authState is AuthAuthenticated;
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final isOrgSelection = state.matchedLocation == '/organizations';

      if (!isAuth && !isLoggingIn) return '/login';
      if (isAuth && isLoggingIn) {
        if (activeOrgId == null) return '/organizations';
        return '/dashboard';
      }
      if (isAuth && !isOrgSelection && activeOrgId == null) {
        return '/organizations';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: RouteNames.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/organizations',
        name: RouteNames.organizationList,
        builder: (context, state) => const OrganizationListScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppScaffold(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            name: RouteNames.dashboard,
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/clients',
            name: RouteNames.clients,
            builder: (context, state) => const ClientListScreen(),
            routes: [
              GoRoute(
                path: 'new',
                name: RouteNames.clientNew,
                builder: (context, state) => const ClientFormScreen(),
              ),
              GoRoute(
                path: ':id',
                name: RouteNames.clientDetail,
                builder: (context, state) => ClientDetailScreen(
                  clientId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: RouteNames.clientEdit,
                    builder: (context, state) => ClientFormScreen(
                      clientId: state.pathParameters['id'],
                    ),
                  ),
                  GoRoute(
                    path: 'contacts/new',
                    name: RouteNames.contactNew,
                    builder: (context, state) => ContactFormScreen(
                      clientId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'contacts/:contactId/edit',
                    name: RouteNames.contactEdit,
                    builder: (context, state) => ContactFormScreen(
                      clientId: state.pathParameters['id']!,
                      contactId: state.pathParameters['contactId'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/projects',
            name: RouteNames.projects,
            builder: (context, state) => const ProjectListScreen(),
            routes: [
              GoRoute(
                path: 'new',
                name: RouteNames.projectNew,
                builder: (context, state) => ProjectFormScreen(
                  clientId: state.uri.queryParameters['clientId'],
                ),
              ),
              GoRoute(
                path: ':id',
                name: RouteNames.projectDetail,
                builder: (context, state) => ProjectDetailScreen(
                  projectId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: RouteNames.projectEdit,
                    builder: (context, state) => ProjectFormScreen(
                      projectId: state.pathParameters['id'],
                    ),
                  ),
                  GoRoute(
                    path: 'teams',
                    name: RouteNames.projectTeams,
                    builder: (context, state) => TeamListScreen(
                      projectId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: 'time-entries/new',
                    name: RouteNames.projectTimeEntryNew,
                    builder: (context, state) => TimeEntryFormScreen(
                      projectId: state.pathParameters['id'],
                    ),
                  ),
                  GoRoute(
                    path: 'tasks/new',
                    name: RouteNames.projectTaskNew,
                    builder: (context, state) => TaskFormScreen(
                      projectId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/tasks',
            redirect: (_, __) => null,
            routes: [
              GoRoute(
                path: ':id',
                name: RouteNames.taskDetail,
                builder: (context, state) => TaskDetailScreen(
                  taskId: state.pathParameters['id']!,
                ),
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: RouteNames.taskEdit,
                    builder: (context, state) => TaskFormScreen(
                      taskId: state.pathParameters['id'],
                    ),
                  ),
                  GoRoute(
                    path: 'log-time',
                    name: RouteNames.taskLogTime,
                    builder: (context, state) => TimeEntryFormScreen(
                      projectId: state.uri.queryParameters['projectId'],
                      taskId: state.pathParameters['id'],
                    ),
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/teams',
            redirect: (_, __) => null,
            routes: [
              GoRoute(
                path: 'new',
                name: RouteNames.teamNew,
                builder: (context, state) => TeamFormScreen(
                  projectId: state.uri.queryParameters['projectId'],
                ),
              ),
              GoRoute(
                path: ':id',
                name: RouteNames.teamDetail,
                builder: (context, state) => TeamDetailScreen(
                  teamId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/time-entries',
            name: RouteNames.timeEntries,
            builder: (context, state) => const TimeEntryListScreen(),
            routes: [
              GoRoute(
                path: 'new',
                name: RouteNames.timeEntryNew,
                builder: (context, state) => const TimeEntryFormScreen(),
              ),
              GoRoute(
                path: ':id/edit',
                name: RouteNames.timeEntryEdit,
                builder: (context, state) => TimeEntryFormScreen(
                  timeEntryId: state.pathParameters['id'],
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/invoices',
            name: RouteNames.invoices,
            builder: (context, state) => const InvoiceListScreen(),
            routes: [
              GoRoute(
                path: 'generate',
                name: RouteNames.invoiceGenerate,
                builder: (context, state) => const InvoiceGenerateScreen(),
              ),
              GoRoute(
                path: ':id',
                name: RouteNames.invoiceDetail,
                builder: (context, state) => InvoiceDetailScreen(
                  invoiceId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            name: RouteNames.profile,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/organizations/:id/settings',
            name: RouteNames.organizationSettings,
            builder: (context, state) => OrganizationDetailScreen(
              organizationId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() => router.dispose());
  return router;
});
