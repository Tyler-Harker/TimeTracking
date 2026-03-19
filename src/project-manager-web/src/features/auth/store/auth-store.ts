import { create } from "zustand";
import { tokenStorage, orgStorage } from "@/core/auth/token-storage";
import { authRepository } from "../repository/auth-repository";
import type { AuthStatus, OrgMembership } from "../models/types";

interface AuthState {
  status: AuthStatus;
  organizations: OrgMembership[];
  activeOrganizationId: string | null;
  error: string | null;

  checkAuthStatus: () => void;
  login: (email: string, password: string) => Promise<void>;
  register: (email: string, password: string, firstName: string, lastName: string) => Promise<void>;
  logout: () => void;
  setActiveOrganization: (id: string) => void;
}

export const useAuthStore = create<AuthState>((set, get) => ({
  status: "initial",
  organizations: [],
  activeOrganizationId: null,
  error: null,

  checkAuthStatus() {
    if (tokenStorage.hasValidToken()) {
      const orgId = orgStorage.getActiveOrganizationId();
      set({
        status: "authenticated",
        activeOrganizationId: orgId,
        error: null,
      });
      return;
    }
    tokenStorage.clearTokens();
    set({ status: "unauthenticated", organizations: [], activeOrganizationId: null });
  },

  async login(email: string, password: string) {
    set({ status: "loading", error: null });
    try {
      const response = await authRepository.login({ email, password });
      tokenStorage.saveTokens(response.token, response.refreshToken, response.expiresAt);
      set({
        status: "authenticated",
        organizations: response.organizations,
        error: null,
      });
    } catch (e) {
      set({ status: "error", error: e instanceof Error ? e.message : "Login failed" });
    }
  },

  async register(email: string, password: string, firstName: string, lastName: string) {
    set({ status: "loading", error: null });
    try {
      await authRepository.register({ email, password, firstName, lastName });
      await get().login(email, password);
    } catch (e) {
      set({ status: "error", error: e instanceof Error ? e.message : "Registration failed" });
    }
  },

  logout() {
    tokenStorage.clearTokens();
    orgStorage.clearActiveOrganizationId();
    set({
      status: "unauthenticated",
      organizations: [],
      activeOrganizationId: null,
      error: null,
    });
  },

  setActiveOrganization(id: string) {
    orgStorage.setActiveOrganizationId(id);
    set({ activeOrganizationId: id });
  },
}));
