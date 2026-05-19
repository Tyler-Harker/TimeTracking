export const API_BASE_URL =
  process.env.NEXT_PUBLIC_API_BASE_URL ?? "http://localhost:5000";

export const OIDC_CLIENT_ID = "pm-web";
export const OIDC_SCOPES = "openid profile email offline_access pm_api";
export const OIDC_REDIRECT_PATH = "/auth/callback";

export const OidcEndpoints = {
  authorize: "/connect/authorize",
  token: "/connect/token",
  userinfo: "/connect/userinfo",
  logout: "/connect/logout",
  discovery: "/.well-known/openid-configuration",
} as const;

export const ApiEndpoints = {
  // Auth (legacy password flow — still supported during transition)
  login: "/api/auth/login",
  register: "/api/auth/register",
  refreshToken: "/api/auth/refresh-token",

  // Users
  currentUser: "/api/users/me",
  organizationUsers: "/api/users",

  // Organizations
  organizations: "/api/organizations",
  organizationById: (id: string) => `/api/organizations/${id}`,

  // Clients
  clients: "/api/clients",
  clientById: (id: string) => `/api/clients/${id}`,
  clientContacts: (clientId: string) => `/api/clients/${clientId}/contacts`,
  clientContactById: (clientId: string, contactId: string) =>
    `/api/clients/${clientId}/contacts/${contactId}`,

  // Projects
  projects: "/api/projects",
  projectById: (id: string) => `/api/projects/${id}`,

  // Teams
  teams: "/api/teams",
  teamById: (id: string) => `/api/teams/${id}`,
  teamMembers: (teamId: string) => `/api/teams/${teamId}/members`,
  teamMember: (teamId: string, userId: string) =>
    `/api/teams/${teamId}/members/${userId}`,

  // Time Entries
  timeEntries: "/api/time-entries",
  timeEntryById: (id: string) => `/api/time-entries/${id}`,

  // Tasks
  tasks: "/api/tasks",
  taskById: (id: string) => `/api/tasks/${id}`,

  // Dashboard
  dashboardSummary: "/api/dashboard/summary",

  // Invoices
  invoices: "/api/invoices",
  invoiceById: (id: string) => `/api/invoices/${id}`,
  generateInvoice: "/api/invoices/generate",
  previewInvoice: "/api/invoices/preview",
  invoiceStatus: (id: string) => `/api/invoices/${id}/status`,
  invoiceLineItems: (invoiceId: string) =>
    `/api/invoices/${invoiceId}/line-items`,

  // Sync
  syncExport: "/api/sync/export",
  syncImport: "/api/sync/import",
} as const;
