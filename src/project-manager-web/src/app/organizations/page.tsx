"use client";

import { useEffect, useState } from "react";
import { useRouter } from "next/navigation";
import { organizationRepository } from "@/features/organizations/repository/organization-repository";
import type { Organization } from "@/features/organizations/models/types";
import { useAuthStore } from "@/features/auth/store/auth-store";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";

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
    router.push("/dashboard");
  }

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorDisplay message={error} onRetry={load} />;

  return (
    <div className="flex min-h-screen items-center justify-center p-4">
      <div className="w-full max-w-lg">
        <h1 className="text-2xl font-bold text-slate-50 mb-2">Select Organization</h1>
        <p className="text-sm text-slate-400 mb-6">Choose an organization to work in</p>
        <div className="space-y-3">
          {orgs.map((org) => (
            <button
              key={org.id}
              onClick={() => selectOrg(org.id)}
              className="w-full rounded-xl border border-slate-700 bg-slate-800 p-4 text-left hover:border-indigo-500 transition-colors"
            >
              <p className="font-medium text-slate-50">{org.name}</p>
              {org.description && <p className="text-sm text-slate-400 mt-1">{org.description}</p>}
              {org.role && <span className="inline-block mt-2 rounded-full bg-indigo-500/20 px-2.5 py-0.5 text-xs font-medium text-indigo-400">{org.role}</span>}
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}
