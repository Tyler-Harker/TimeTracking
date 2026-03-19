const TOKEN_KEY = "access_token";
const REFRESH_TOKEN_KEY = "refresh_token";
const EXPIRES_AT_KEY = "expires_at";

export const tokenStorage = {
  getAccessToken(): string | null {
    if (typeof window === "undefined") return null;
    return localStorage.getItem(TOKEN_KEY);
  },

  getRefreshToken(): string | null {
    if (typeof window === "undefined") return null;
    return localStorage.getItem(REFRESH_TOKEN_KEY);
  },

  getExpiresAt(): string | null {
    if (typeof window === "undefined") return null;
    return localStorage.getItem(EXPIRES_AT_KEY);
  },

  saveTokens(accessToken: string, refreshToken: string, expiresAt: string) {
    localStorage.setItem(TOKEN_KEY, accessToken);
    localStorage.setItem(REFRESH_TOKEN_KEY, refreshToken);
    localStorage.setItem(EXPIRES_AT_KEY, expiresAt);
  },

  clearTokens() {
    localStorage.removeItem(TOKEN_KEY);
    localStorage.removeItem(REFRESH_TOKEN_KEY);
    localStorage.removeItem(EXPIRES_AT_KEY);
  },

  hasValidToken(): boolean {
    const token = this.getAccessToken();
    const expiresAt = this.getExpiresAt();
    if (!token || !expiresAt) return false;
    return new Date(expiresAt) > new Date();
  },
};

const ACTIVE_ORG_KEY = "active_organization_id";

export const orgStorage = {
  getActiveOrganizationId(): string | null {
    if (typeof window === "undefined") return null;
    return localStorage.getItem(ACTIVE_ORG_KEY);
  },

  setActiveOrganizationId(id: string) {
    localStorage.setItem(ACTIVE_ORG_KEY, id);
  },

  clearActiveOrganizationId() {
    localStorage.removeItem(ACTIVE_ORG_KEY);
  },
};
