"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { timeEntryRepository } from "@/features/time-entries/repository/time-entry-repository";
import type { TimeEntry } from "@/features/time-entries/models/types";
import { PageHeader } from "@/core/components/page-header";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { EmptyState } from "@/core/components/empty-state";

export default function TimeEntryListPage() {
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
      <PageHeader title="Time Entries" action={{ label: "New Entry", href: "/time-entries/new" }} />
      {entries.length === 0 ? (
        <EmptyState message="No time entries yet." />
      ) : (
        <div className="grid gap-3">
          {entries.map((entry) => (
            <Link key={entry.id} href={`/time-entries/${entry.id}/edit`} className="rounded-xl border border-slate-700 bg-slate-800 p-4 hover:border-indigo-500/50 transition-colors block">
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium text-slate-50">{entry.projectName}</p>
                  <p className="text-sm text-slate-400">{entry.description || "No description"}</p>
                  {entry.taskName && <p className="text-xs text-slate-500 mt-0.5">Task: {entry.taskName}</p>}
                </div>
                <div className="text-right">
                  <p className="font-medium text-slate-50">{entry.hours}h</p>
                  <p className="text-sm text-slate-400">{entry.date}</p>
                  <div className="flex gap-1.5 mt-1">
                    {entry.isBillable && <span className="text-xs text-green-400">Billable</span>}
                    {entry.isInvoiced && <span className="text-xs text-indigo-400">Invoiced</span>}
                  </div>
                </div>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
