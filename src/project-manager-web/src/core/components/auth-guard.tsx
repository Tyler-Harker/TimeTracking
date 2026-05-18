"use client";

import { useEffect } from "react";
import { usePathname, useRouter } from "next/navigation";
import { useAuthStore } from "@/features/auth/store/auth-store";

// /register stays public so people can create accounts; /auth/callback handles the OIDC
// redirect target. We intentionally do NOT route through an interstitial /login page —
// unauthenticated users are bounced straight to the OIDC authorize endpoint.
const PUBLIC_ROUTES = ["/register", "/auth/callback"];
const ADMIN_ROUTE_PREFIX = "/admin";

export function AuthGuard({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const pathname = usePathname();
  const { status, activeOrganizationId, checkAuthStatus, loginWithOidc } = useAuthStore();

  const isAdminRoute = pathname === ADMIN_ROUTE_PREFIX || pathname.startsWith(`${ADMIN_ROUTE_PREFIX}/`);

  useEffect(() => {
    if (isAdminRoute) return;
    checkAuthStatus();
  }, [checkAuthStatus, isAdminRoute]);

  useEffect(() => {
    if (isAdminRoute) return;
    if (status === "initial" || status === "loading") return;

    const isPublic = PUBLIC_ROUTES.includes(pathname);

    if (status === "unauthenticated" && !isPublic) {
      // Pass current path as returnTo so the OIDC callback restores their target page.
      void loginWithOidc(pathname);
      return;
    }

    if (status === "authenticated" && isPublic) {
      if (activeOrganizationId) {
        router.replace(`/organizations/${activeOrganizationId}/dashboard`);
      } else {
        router.replace("/organizations");
      }
    }
  }, [status, pathname, router, activeOrganizationId, isAdminRoute, loginWithOidc]);

  if (isAdminRoute) {
    return <>{children}</>;
  }

  if (status === "initial" || status === "loading") {
    return (
      <div className="flex min-h-screen items-center justify-center">
        <div className="h-8 w-8 animate-spin rounded-full border-2 border-muted border-t-primary" />
      </div>
    );
  }

  return <>{children}</>;
}
