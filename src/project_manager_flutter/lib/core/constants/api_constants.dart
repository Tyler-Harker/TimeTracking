class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:5000',
  );

  // Auth
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String refreshToken = '/api/auth/refresh-token';

  // Users
  static const String currentUser = '/api/users/me';

  // Organizations
  static const String organizations = '/api/organizations';
  static String organizationById(String id) => '/api/organizations/$id';

  // Clients
  static const String clients = '/api/clients';
  static String clientById(String id) => '/api/clients/$id';
  static String clientContacts(String clientId) =>
      '/api/clients/$clientId/contacts';
  static String clientContactById(String clientId, String contactId) =>
      '/api/clients/$clientId/contacts/$contactId';

  // Projects
  static const String projects = '/api/projects';
  static String projectById(String id) => '/api/projects/$id';

  // Teams
  static const String teams = '/api/teams';
  static String teamById(String id) => '/api/teams/$id';
  static String teamMembers(String teamId) => '/api/teams/$teamId/members';
  static String teamMember(String teamId, String userId) =>
      '/api/teams/$teamId/members/$userId';

  // Time Entries
  static const String timeEntries = '/api/time-entries';
  static String timeEntryById(String id) => '/api/time-entries/$id';

  // Tasks
  static const String tasks = '/api/tasks';
  static String taskById(String id) => '/api/tasks/$id';

  // Dashboard
  static const String dashboardSummary = '/api/dashboard/summary';

  // Invoices
  static const String invoices = '/api/invoices';
  static String invoiceById(String id) => '/api/invoices/$id';
  static const String generateInvoice = '/api/invoices/generate';
  static String invoiceStatus(String id) => '/api/invoices/$id/status';
  static String invoiceLineItems(String invoiceId) =>
      '/api/invoices/$invoiceId/line-items';
}
