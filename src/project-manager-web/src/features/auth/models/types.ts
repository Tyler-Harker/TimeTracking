export interface LoginRequest {
  email: string;
  password: string;
}

export interface RegisterRequest {
  email: string;
  password: string;
  firstName: string;
  lastName: string;
}

export interface LoginResponse {
  token: string;
  refreshToken: string;
  expiresAt: string;
  organizations: OrgMembership[];
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

export interface RefreshTokenRequest {
  token: string;
  refreshToken: string;
}

export interface RefreshTokenResponse {
  token: string;
  refreshToken: string;
  expiresAt: string;
}

export type AuthStatus = "initial" | "loading" | "authenticated" | "unauthenticated" | "error";
