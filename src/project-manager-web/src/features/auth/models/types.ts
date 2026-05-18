export interface RegisterRequest {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
}

export interface RegisterResponse {
  token: string;
  refreshToken: string;
  expiresAt: string;
  organizations: OrgMembership[];
}

export interface OrgMembership {
  organizationId: string;
  name: string;
  role: string;
}

export type AuthStatus = "initial" | "loading" | "authenticated" | "unauthenticated" | "error";
