"use client";

import { useEffect } from "react";
import { useParams } from "next/navigation";
import { useAuthStore } from "@/features/auth/store/auth-store";
import { AppShell } from "@/core/components/app-shell";
import { Breadcrumbs } from "@/core/components/breadcrumbs";

export default function OrgScopedLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const params = useParams<{ orgId: string }>();
  const { setActiveOrganization, activeOrganizationId } = useAuthStore();

  // Sync the org ID from the URL to the store (for API headers)
  useEffect(() => {
    if (params.orgId && params.orgId !== activeOrganizationId) {
      setActiveOrganization(params.orgId);
    }
  }, [params.orgId, activeOrganizationId, setActiveOrganization]);

  return (
    <AppShell>
      <Breadcrumbs />
      {children}
    </AppShell>
  );
}
