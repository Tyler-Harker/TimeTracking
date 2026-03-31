"use client";
import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { teamRepository } from "@/features/teams/repository/team-repository";
import type { TeamDetail } from "@/features/teams/models/types";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { Card, CardContent } from "@/components/ui/card";
import { Button } from "@/components/ui/button";

export default function TeamDetailPage() {
  const params = useParams<{ orgId: string; teamId: string }>();
  const [team, setTeam] = useState<TeamDetail | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  async function load() {
    setLoading(true);
    try {
      setTeam(await teamRepository.get(params.teamId));
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load team");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { load(); }, [params.teamId]);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorDisplay message={error} onRetry={load} />;
  if (!team) return null;

  return (
    <div className="p-6 max-w-4xl">
      <h1 className="text-2xl font-bold text-foreground mb-1">{team.name}</h1>
      <p className="text-sm text-muted-foreground mb-6">{team.projectName}</p>
      {team.description && <p className="text-muted-foreground mb-6">{team.description}</p>}

      <h2 className="text-lg font-semibold text-foreground mb-4">Members ({team.members.length})</h2>
      {team.members.length === 0 ? (
        <p className="text-sm text-muted-foreground">No members yet.</p>
      ) : (
        <div className="grid gap-3">
          {team.members.map((member) => (
            <Card key={member.userId}>
              <CardContent>
                <div className="flex items-center justify-between">
                  <div>
                    <p className="font-medium text-foreground">{member.userName}</p>
                    <p className="text-sm text-muted-foreground">Joined {new Date(member.joinedAt).toLocaleDateString()}</p>
                  </div>
                  <Button
                    variant="destructive"
                    size="sm"
                    onClick={async () => {
                      try {
                        await teamRepository.removeMember(params.teamId, member.userId);
                        load();
                      } catch (e) {
                        setError(e instanceof Error ? e.message : "Failed to remove member");
                      }
                    }}
                  >
                    Remove
                  </Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
