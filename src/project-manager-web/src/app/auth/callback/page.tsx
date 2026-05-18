"use client";

import { useEffect, useRef, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { useAuthStore } from "@/features/auth/store/auth-store";

export default function OidcCallbackPage() {
  const router = useRouter();
  const searchParams = useSearchParams();
  const completeOidcCallback = useAuthStore((s) => s.completeOidcCallback);
  const [error, setError] = useState<string | null>(null);
  const handled = useRef(false);

  useEffect(() => {
    if (handled.current) return;
    handled.current = true;

    const code = searchParams?.get("code");
    const state = searchParams?.get("state");
    const oidcError = searchParams?.get("error");

    if (oidcError) {
      setError(searchParams?.get("error_description") ?? oidcError);
      return;
    }
    if (!code || !state) {
      setError("Missing authorization code or state.");
      return;
    }

    void completeOidcCallback(code, state).then((returnTo) => {
      const store = useAuthStore.getState();
      if (store.status !== "authenticated") {
        setError(store.error ?? "Sign-in failed.");
        return;
      }
      const target =
        returnTo ??
        (store.activeOrganizationId
          ? `/organizations/${store.activeOrganizationId}/dashboard`
          : "/organizations");
      router.replace(target);
    });
  }, [searchParams, completeOidcCallback, router]);

  return (
    <div className="flex min-h-screen items-center justify-center bg-background p-4">
      <div className="text-center text-sm text-muted-foreground">
        {error ? (
          <p className="text-destructive">{error}</p>
        ) : (
          <p>Completing sign in…</p>
        )}
      </div>
    </div>
  );
}
