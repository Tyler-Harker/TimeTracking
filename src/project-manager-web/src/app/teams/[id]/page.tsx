"use client";
import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { teamRepository } from "@/features/teams/repository/team-repository";
import type { TeamDetail } from "@/features/teams/models/types";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";

export default function TeamDetailPage() {
  const params = useParams<{ id: string }>();
  const [team, setTeam] = useState<TeamDetail | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  async function load() {
    setLoading(true);
    try {
      setTeam(await teamRepository.get(params.id));
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load team");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { load(); }, [params.id]);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorDisplay message={error} onRetry={load} />;
  if (!team) return null;

  return (
    <div className="p-6 max-w-4xl">
      <h1 className="text-2xl font-bold text-slate-50 mb-1">{team.name}</h1>
      <p className="text-sm text-slate-400 mb-6">{team.projectName}</p>
      {team.description && <p className="text-slate-300 mb-6">{team.description}</p>}

      <h2 className="text-lg font-semibold text-slate-50 mb-4">Members ({team.members.length})</h2>
      {team.members.length === 0 ? (
        <p className="text-sm text-slate-400">No members yet.</p>
      ) : (
        <div className="grid gap-3">
          {team.members.map((member) => (
            <div key={member.userId} className="rounded-xl border border-slate-700 bg-slate-800 p-4 flex items-center justify-between">
              <div>
                <p className="font-medium text-slate-50">{member.userName}</p>
                <p className="text-sm text-slate-400">Joined {new Date(member.joinedAt).toLocaleDateString()}</p>
              </div>
              <button
                onClick={async () => {
                  await teamRepository.removeMember(params.id, member.userId);
                  load();
                }}
                className="text-sm text-red-400 hover:text-red-300"
              >
                Remove
              </button>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
