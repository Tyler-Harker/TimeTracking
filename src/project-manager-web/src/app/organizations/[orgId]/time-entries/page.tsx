"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useParams } from "next/navigation";
import { timeEntryRepository } from "@/features/time-entries/repository/time-entry-repository";
import type { TimeEntry } from "@/features/time-entries/models/types";
import { PageHeader } from "@/core/components/page-header";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { EmptyState } from "@/core/components/empty-state";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";

export default function TimeEntryListPage() {
  const params = useParams<{ orgId: string }>();
  const orgId = params.orgId;
  const [entries, setEntries] = useState<TimeEntry[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  async function load() {
    setLoading(true);
    try {
      setEntries(await timeEntryRepository.list());
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load time entries");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { load(); }, []);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorDisplay message={error} onRetry={load} />;

  return (
    <div className="p-6">
      <PageHeader title="Time Entries" action={{ label: "New Entry", href: `/organizations/${orgId}/time-entries/new` }} />
      {entries.length === 0 ? (
        <EmptyState message="No time entries yet." />
      ) : (
        <div className="grid gap-3">
          {entries.map((entry) => (
            <Link key={entry.id} href={`/organizations/${orgId}/time-entries/${entry.id}/edit`} className="block">
              <Card className="hover:ring-2 hover:ring-primary/50 transition-all">
                <CardContent>
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium text-foreground">{entry.projectName}</p>
                      <p className="text-sm text-muted-foreground">{entry.description || "No description"}</p>
                      {entry.taskName && <p className="text-xs text-muted-foreground/70 mt-0.5">Task: {entry.taskName}</p>}
                    </div>
                    <div className="text-right">
                      <p className="font-medium text-foreground">{entry.hours}h</p>
                      <p className="text-sm text-muted-foreground">{entry.date}</p>
                      <div className="flex gap-1.5 mt-1 justify-end">
                        {entry.isBillable && <Badge variant="secondary" className="text-xs">Billable</Badge>}
                        {entry.isInvoiced && <Badge variant="default" className="text-xs">Invoiced</Badge>}
                      </div>
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
