"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useParams } from "next/navigation";
import { clientRepository } from "@/features/clients/repository/client-repository";
import type { Client } from "@/features/clients/models/types";
import { PageHeader } from "@/core/components/page-header";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { EmptyState } from "@/core/components/empty-state";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";

export default function ClientListPage() {
  const { orgId } = useParams<{ orgId: string }>();
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
      <PageHeader title="Clients" action={{ label: "New Client", href: `/organizations/${orgId}/clients/new` }} />
      {clients.length === 0 ? (
        <EmptyState message="No clients yet. Create your first client to get started." />
      ) : (
        <div className="grid gap-4">
          {clients.map((client) => (
            <Link key={client.id} href={`/organizations/${orgId}/clients/${client.id}`} className="block">
              <Card className="hover:ring-primary/50 transition-colors">
                <CardContent>
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium text-foreground">{client.name}</p>
                      <p className="text-sm text-muted-foreground">{client.contactCount} contacts</p>
                    </div>
                    <div className="flex items-center gap-3">
                      {client.defaultBillableRate && <span className="text-sm text-muted-foreground">${client.defaultBillableRate}/hr</span>}
                      <Badge variant={client.isActive ? "default" : "secondary"}>
                        {client.isActive ? "Active" : "Inactive"}
                      </Badge>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
