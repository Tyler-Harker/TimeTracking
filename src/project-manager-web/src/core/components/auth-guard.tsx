"use client";

import { useEffect } from "react";
import { usePathname, useRouter } from "next/navigation";
import { useAuthStore } from "@/features/auth/store/auth-store";

const PUBLIC_ROUTES = ["/login", "/register"];

export function AuthGuard({ children }: { children: React.ReactNode }) {
  const router = useRouter();
  const pathname = usePathname();
  const { status, checkAuthStatus } = useAuthStore();

  useEffect(() => {
    checkAuthStatus();
  }, [checkAuthStatus]);

  useEffect(() => {
    if (status === "initial" || status === "loading") return;

    const isPublic = PUBLIC_ROUTES.includes(pathname);

    if (status === "unauthenticated" && !isPublic) {
      router.replace("/login");
    }

    if (status === "authenticated" && isPublic) {
      router.replace("/dashboard");
    }
  }, [status, pathname, router]);

  if (status === "initial" || status === "loading") {
    return (
      <div className="flex min-h-screen items-center justify-center">
        <div className="h-8 w-8 animate-spin rounded-full border-2 border-slate-600 border-t-indigo-500" />
      </div>
    );
  }

  return <>{children}</>;
}
