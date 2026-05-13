const ADMIN_TOKEN_KEY = "admin_access_token";
const ADMIN_EXPIRES_AT_KEY = "admin_expires_at";

export const adminTokenStorage = {
  getToken(): string | null {
    if (typeof window === "undefined") return null;
    return localStorage.getItem(ADMIN_TOKEN_KEY);
  },

  getExpiresAt(): string | null {
    if (typeof window === "undefined") return null;
    return localStorage.getItem(ADMIN_EXPIRES_AT_KEY);
  },

  save(token: string, expiresAt: string) {
    localStorage.setItem(ADMIN_TOKEN_KEY, token);
    localStorage.setItem(ADMIN_EXPIRES_AT_KEY, expiresAt);
  },

  clear() {
    localStorage.removeItem(ADMIN_TOKEN_KEY);
    localStorage.removeItem(ADMIN_EXPIRES_AT_KEY);
  },

  hasValid(): boolean {
    const token = this.getToken();
    const expiresAt = this.getExpiresAt();
    if (!token || !expiresAt) return false;
    return new Date(expiresAt) > new Date();
  },
};
