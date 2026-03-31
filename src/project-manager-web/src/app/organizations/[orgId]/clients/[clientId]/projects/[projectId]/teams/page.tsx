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
import { Card, CardContent } from "@/components/ui/card";

export default function ProjectTeamsPage() {
  const params = useParams<{ orgId: string; clientId: string; projectId: string }>();
  const [teams, setTeams] = useState<Team[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  async function load() {
    setLoading(true);
    try {
      setTeams(await teamRepository.list(params.projectId));
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load teams");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { load(); }, [params.projectId]);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorDisplay message={error} onRetry={load} />;

  return (
    <div className="p-6">
      <PageHeader title="Project Teams" action={{ label: "New Team", href: `/organizations/${params.orgId}/teams/new?projectId=${params.projectId}` }} />
      {teams.length === 0 ? (
        <EmptyState message="No teams for this project yet." />
      ) : (
        <div className="grid gap-4">
          {teams.map((team) => (
            <Link key={team.id} href={`/organizations/${params.orgId}/teams/${team.id}`} className="block transition-colors">
              <Card className="hover:ring-primary/50 transition-all">
                <CardContent>
                  <p className="font-medium text-foreground">{team.name}</p>
                  {team.description && <p className="text-sm text-muted-foreground mt-1">{team.description}</p>}
                  <p className="text-sm text-muted-foreground mt-1">{team.memberCount} members</p>
                </CardContent>
              </Card>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
