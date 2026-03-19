"use client";
import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import Link from "next/link";
import { taskRepository } from "@/features/tasks/repository/task-repository";
import type { TaskDetail } from "@/features/tasks/models/types";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { StatusBadge } from "@/core/components/status-badge";
import { ConfirmDialog } from "@/core/components/confirm-dialog";

export default function TaskDetailPage() {
  const params = useParams<{ id: string }>();
  const router = useRouter();
  const [task, setTask] = useState<TaskDetail | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [showDelete, setShowDelete] = useState(false);

  async function load() {
    setLoading(true);
    try {
      setTask(await taskRepository.get(params.id));
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load task");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { load(); }, [params.id]);

  async function handleDelete() {
    await taskRepository.delete(params.id);
    router.back();
  }

  if (loading) return <LoadingSpinner />;
  if (error && !task) return <ErrorDisplay message={error} onRetry={load} />;
  if (!task) return null;

  return (
    <div className="p-6 max-w-4xl">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-slate-50">{task.name}</h1>
          <p className="text-sm text-slate-400">{task.projectName}</p>
        </div>
        <div className="flex items-center gap-2">
          <StatusBadge status={task.status} />
          <StatusBadge status={task.priority} />
          <Link href={`/tasks/${params.id}/edit`} className="rounded-lg border border-slate-600 px-4 py-2 text-sm text-slate-300 hover:bg-slate-700 transition-colors">Edit</Link>
          <button onClick={() => setShowDelete(true)} className="rounded-lg border border-red-500/30 px-4 py-2 text-sm text-red-400 hover:bg-red-500/10 transition-colors">Delete</button>
        </div>
      </div>

      <div className="rounded-xl border border-slate-700 bg-slate-800 p-4 mb-6">
        {task.assigneeName && <p className="text-sm text-slate-400 mb-1"><span className="text-slate-300">Assignee:</span> {task.assigneeName}</p>}
        {task.dueDate && <p className="text-sm text-slate-400 mb-1"><span className="text-slate-300">Due:</span> {task.dueDate}</p>}
        {task.estimatedHours && <p className="text-sm text-slate-400 mb-1"><span className="text-slate-300">Estimated:</span> {task.estimatedHours}h</p>}
        {task.description && <p className="text-sm text-slate-400 mt-2">{task.description}</p>}
      </div>

      <Link href={`/tasks/${params.id}/log-time?projectId=${task.projectId}`} className="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white hover:bg-indigo-500 transition-colors">
        Log Time
      </Link>

      <ConfirmDialog open={showDelete} title="Delete Task" message="Are you sure?" onConfirm={handleDelete} onCancel={() => setShowDelete(false)} />
    </div>
  );
}
