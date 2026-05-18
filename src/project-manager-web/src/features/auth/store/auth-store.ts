import { create } from "zustand";
import { tokenStorage, orgStorage } from "@/core/auth/token-storage";
import {
  beginOidcLogin,
  completeOidcLogin,
  oidcLogoutUrl,
  parseOrgClaim,
} from "@/core/auth/oidc-client";
import { authRepository } from "../repository/auth-repository";
import type { AuthStatus, OrgMembership } from "../models/types";

interface AuthState {
  status: AuthStatus;
  organizations: OrgMembership[];
  activeOrganizationId: string | null;
  error: string | null;

  checkAuthStatus: () => void;
  loginWithOidc: (returnTo?: string) => Promise<void>;
  completeOidcCallback: (code: string, state: string) => Promise<string | null>;
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

  async loginWithOidc(returnTo?: string) {
    set({ status: "loading", error: null });
    await beginOidcLogin(returnTo);
  },

  async completeOidcCallback(code: string, state: string) {
    set({ status: "loading", error: null });
    try {
      const { userInfo, returnTo } = await completeOidcLogin(code, state);
      const organizations: OrgMembership[] = parseOrgClaim(userInfo.org).map((m) => ({
        organizationId: m.organizationId,
        name: m.organizationId,
        role: m.role,
      }));

      // Reconcile the persisted active-org against this user's actual memberships.
      // A leftover id from a prior session would otherwise auto-route the user to a
      // dashboard for an org they no longer belong to (or never did).
      const stored = orgStorage.getActiveOrganizationId();
      const storedIsValid = stored !== null && organizations.some((o) => o.organizationId === stored);

      let activeOrganizationId: string | null = null;
      if (storedIsValid) {
        activeOrganizationId = stored;
      } else if (organizations.length === 1) {
        activeOrganizationId = organizations[0].organizationId;
      }

      if (activeOrganizationId) {
        orgStorage.setActiveOrganizationId(activeOrganizationId);
      } else {
        orgStorage.clearActiveOrganizationId();
      }

      set({
        status: "authenticated",
        organizations,
        activeOrganizationId,
        error: null,
      });
      return returnTo;
    } catch (e) {
      set({ status: "error", error: e instanceof Error ? e.message : "Login failed" });
      return null;
    }
  },

  async register(email: string, password: string, firstName: string, lastName: string) {
    set({ status: "loading", error: null });
    try {
      await authRepository.register({ email, password, firstName, lastName });
      // After account creation, route through the OIDC flow so tokens come from the
      // OpenIddict server (single canonical issuer going forward).
      await beginOidcLogin();
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
    if (typeof window !== "undefined") {
      window.location.assign(oidcLogoutUrl());
    }
  },

  setActiveOrganization(id: string) {
    orgStorage.setActiveOrganizationId(id);
    set({ activeOrganizationId: id });
  },
}));
