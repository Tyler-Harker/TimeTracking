"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { clientRepository } from "@/features/clients/repository/client-repository";
import type { Client } from "@/features/clients/models/types";
import { PageHeader } from "@/core/components/page-header";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { EmptyState } from "@/core/components/empty-state";

export default function ClientListPage() {
  const [clients, setClients] = useState<Client[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  async function load() {
    setLoading(true);
    try {
      setClients(await clientRepository.list());
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load clients");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { load(); }, []);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorDisplay message={error} onRetry={load} />;

  return (
    <div className="p-6">
      <PageHeader title="Clients" action={{ label: "New Client", href: "/clients/new" }} />
      {clients.length === 0 ? (
        <EmptyState message="No clients yet. Create your first client to get started." />
      ) : (
        <div className="grid gap-4">
          {clients.map((client) => (
            <Link key={client.id} href={`/clients/${client.id}`} className="rounded-xl border border-slate-700 bg-slate-800 p-4 hover:border-indigo-500/50 transition-colors block">
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium text-slate-50">{client.name}</p>
                  <p className="text-sm text-slate-400">{client.contactCount} contacts</p>
                </div>
                <div className="flex items-center gap-3">
                  {client.defaultBillableRate && <span className="text-sm text-slate-400">${client.defaultBillableRate}/hr</span>}
                  <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${client.isActive ? "bg-green-500/20 text-green-400" : "bg-slate-500/20 text-slate-400"}`}>
                    {client.isActive ? "Active" : "Inactive"}
                  </span>
                </div>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
