"use client";

import { useEffect } from "react";
import { usePathname, useRouter } from "next/navigation";
import { useAuthStore } from "@/features/auth/store/auth-store";

const PUBLIC_ROUTES = ["/login", "/register"];

export function AuthGuard({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const pathname = usePathname();
  const { status, activeOrganizationId, checkAuthStatus } = useAuthStore();

  useEffect(() => {
    checkAuthStatus();
  }, [checkAuthStatus]);

  useEffect(() => {
    if (status === "initial" || status === "loading") return;

    const isPublic = PUBLIC_ROUTES.includes(pathname);
    const isOrgSelection = pathname === "/organizations";

    if (status === "unauthenticated" && !isPublic) {
      router.replace("/login");
    }

    if (status === "authenticated" && isPublic) {
      if (activeOrganizationId) {
        router.replace(`/organizations/${activeOrganizationId}/dashboard`);
      } else {
        router.replace("/organizations");
      }
    }
  }, [status, pathname, router, activeOrganizationId]);

  if (status === "initial" || status === "loading") {
    return (
      <div className="flex min-h-screen items-center justify-center">
        <div className="h-8 w-8 animate-spin rounded-full border-2 border-muted border-t-primary" />
      </div>
    );
  }

  return <>{children}</>;
}
