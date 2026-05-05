"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import Link from "next/link";
import { organizationRepository } from "@/features/organizations/repository/organization-repository";
import type { Organization } from "@/features/organizations/models/types";
import { useAuthStore } from "@/features/auth/store/auth-store";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { buttonVariants } from "@/components/ui/button";
import { cn } from "@/lib/utils";

export default function OrganizationListPage() {
  const router = useRouter();
  const { setActiveOrganization } = useAuthStore();
  const [orgs, setOrgs] = useState<Organization[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  async function load() {
    setLoading(true);
    try {
      setOrgs(await organizationRepository.list());
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load organizations");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { load(); }, []);

  function selectOrg(id: string) {
    setActiveOrganization(id);
    router.push(`/organizations/${id}/dashboard`);
  }

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorDisplay message={error} onRetry={load} />;

  return (
    <div className="flex min-h-screen items-center justify-center bg-background p-4">
      <div className="w-full max-w-lg">
        <div className="flex items-start justify-between mb-6">
          <div>
            <h1 className="text-2xl font-bold text-foreground mb-2">Select Organization</h1>
            <p className="text-sm text-muted-foreground">Choose an organization to work in</p>
          </div>
          {orgs.length > 0 && (
            <Link href="/organizations/new" className={cn(buttonVariants())}>
              + New
            </Link>
          )}
        </div>

        {orgs.length === 0 ? (
          <Card>
            <CardContent className="flex flex-col items-center text-center py-10 gap-3">
              <p className="font-medium text-foreground">You're not in any organizations yet</p>
              <p className="text-sm text-muted-foreground">Create your first organization to get started.</p>
              <Link href="/organizations/new" className={cn(buttonVariants(), "mt-2")}>
                Create organization
              </Link>
            </CardContent>
          </Card>
        ) : (
          <div className="space-y-3">
            {orgs.map((org) => (
              <Card
                key={org.id}
                className="cursor-pointer transition-colors hover:ring-primary/50"
                onClick={() => selectOrg(org.id)}
              >
                <CardContent className="pt-1">
                  <p className="font-medium text-foreground">{org.name}</p>
                  {org.description && <p className="text-sm text-muted-foreground mt-1">{org.description}</p>}
                  {org.role && <Badge variant="secondary" className="mt-2">{org.role}</Badge>}
                </CardContent>
              </Card>
            ))}
          </div>
        )}
      </div>
    </div>
  );
}
