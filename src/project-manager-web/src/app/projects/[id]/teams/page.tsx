"use client";
import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import Link from "next/link";
import { teamRepository } from "@/features/teams/repository/team-repository";
import type { Team } from "@/features/teams/models/types";
import { PageHeader } from "@/core/components/page-header";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { EmptyState } from "@/core/components/empty-state";

export default function ProjectTeamsPage() {
  const params = useParams<{ id: string }>();
  const [teams, setTeams] = useState<Team[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  async function load() {
    setLoading(true);
    try {
      setTeams(await teamRepository.list(params.id));
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load teams");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { load(); }, [params.id]);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorDisplay message={error} onRetry={load} />;

  return (
    <div className="p-6">
      <PageHeader title="Project Teams" action={{ label: "New Team", href: `/teams/new?projectId=${params.id}` }} />
      {teams.length === 0 ? (
        <EmptyState message="No teams for this project yet." />
      ) : (
        <div className="grid gap-4">
          {teams.map((team) => (
            <Link key={team.id} href={`/teams/${team.id}`} className="rounded-xl border border-slate-700 bg-slate-800 p-4 hover:border-indigo-500/50 transition-colors block">
              <p className="font-medium text-slate-50">{team.name}</p>
              {team.description && <p className="text-sm text-slate-400 mt-1">{team.description}</p>}
              <p className="text-sm text-slate-400 mt-1">{team.memberCount} members</p>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
