"use client";

import { useEffect } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { useAuthStore } from "@/features/auth/store/auth-store";

export default function LoginPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const { loginWithOidc, status, error } = useAuthStore();

  useEffect(() => {
    if (status === "authenticated") {
      const state = useAuthStore.getState();
      router.replace(
        state.activeOrganizationId
          ? `/organizations/${state.activeOrganizationId}/dashboard`
          : "/organizations"
      );
      return;
    }

    if (status === "initial" || status === "unauthenticated") {
      const returnTo = searchParams?.get("returnTo") ?? undefined;
      void loginWithOidc(returnTo);
    }
  }, [status, loginWithOidc, router, searchParams]);

  return (
    <div className="flex min-h-screen items-center justify-center bg-background p-4">
      <div className="text-center text-sm text-muted-foreground">
        {error ? (
          <p className="text-destructive">{error}</p>
        ) : (
          <p>Redirecting to sign in…</p>
        )}
      </div>
    </div>
  );
}
