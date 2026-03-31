"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";
import { useAuthStore } from "@/features/auth/store/auth-store";

export default function Home() {
  const router = useRouter();
  const { status, activeOrganizationId } = useAuthStore();

  useEffect(() => {
    if (status === "authenticated") {
      if (activeOrganizationId) {
        router.replace(`/organizations/${activeOrganizationId}/dashboard`);
      } else {
        router.replace("/organizations");
      }
    } else if (status === "unauthenticated") {
      router.replace("/login");
    }
  }, [status, activeOrganizationId, router]);

  return (
    <div className="flex min-h-screen items-center justify-center">
      <div className="h-8 w-8 animate-spin rounded-full border-2 border-muted border-t-primary" />
    </div>
  );
}
