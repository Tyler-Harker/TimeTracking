"use client";
import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import Link from "next/link";
import { projectRepository } from "@/features/projects/repository/project-repository";
import type { ProjectDetail } from "@/features/projects/models/types";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { StatusBadge } from "@/core/components/status-badge";
import { ConfirmDialog } from "@/core/components/confirm-dialog";

export default function ProjectDetailPage() {
  const params = useParams<{ id: string }>();
  const router = useRouter();
  const [project, setProject] = useState<ProjectDetail | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [showDelete, setShowDelete] = useState(false);

  async function load() {
    setLoading(true);
    try {
      setProject(await projectRepository.get(params.id));
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load project");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { load(); }, [params.id]);

  async function handleDelete() {
    try {
      await projectRepository.delete(params.id);
      router.push("/projects");
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to delete");
    }
  }

  if (loading) return <LoadingSpinner />;
  if (error && !project) return <ErrorDisplay message={error} onRetry={load} />;
  if (!project) return null;

  return (
    <div className="p-6 max-w-4xl">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-slate-50">{project.name}</h1>
          <p className="text-sm text-slate-400">{project.clientName}</p>
        </div>
        <div className="flex items-center gap-2">
          <StatusBadge status={project.status} />
          <Link href={`/projects/${params.id}/edit`} className="rounded-lg border border-slate-600 px-4 py-2 text-sm text-slate-300 hover:bg-slate-700 transition-colors">Edit</Link>
          <button onClick={() => setShowDelete(true)} className="rounded-lg border border-red-500/30 px-4 py-2 text-sm text-red-400 hover:bg-red-500/10 transition-colors">Delete</button>
        </div>
      </div>

      <div className="rounded-xl border border-slate-700 bg-slate-800 p-4 mb-6">
        {project.budgetAmount && <p className="text-sm text-slate-400 mb-1"><span className="text-slate-300">Budget:</span> ${project.budgetAmount.toLocaleString()}</p>}
        {project.defaultBillableRate && <p className="text-sm text-slate-400 mb-1"><span className="text-slate-300">Rate:</span> ${project.defaultBillableRate}/hr</p>}
        {project.startDate && <p className="text-sm text-slate-400 mb-1"><span className="text-slate-300">Start:</span> {project.startDate}</p>}
        {project.endDate && <p className="text-sm text-slate-400"><span className="text-slate-300">End:</span> {project.endDate}</p>}
      </div>

      <div className="flex gap-3">
        <Link href={`/projects/${params.id}/teams`} className="rounded-lg border border-slate-600 px-4 py-2 text-sm text-slate-300 hover:bg-slate-700 transition-colors">Teams</Link>
        <Link href={`/projects/${params.id}/tasks/new`} className="rounded-lg border border-slate-600 px-4 py-2 text-sm text-slate-300 hover:bg-slate-700 transition-colors">New Task</Link>
        <Link href={`/projects/${params.id}/time-entries/new`} className="rounded-lg border border-slate-600 px-4 py-2 text-sm text-slate-300 hover:bg-slate-700 transition-colors">Log Time</Link>
      </div>

      <ConfirmDialog open={showDelete} title="Delete Project" message="Are you sure? This cannot be undone." onConfirm={handleDelete} onCancel={() => setShowDelete(false)} />
    </div>
  );
}
