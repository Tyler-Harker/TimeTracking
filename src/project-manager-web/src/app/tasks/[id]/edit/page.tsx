"use client";
import { useEffect, useState, type FormEvent } from "react";
import { useParams, useRouter } from "next/navigation";
import { taskRepository } from "@/features/tasks/repository/task-repository";
import type { TaskStatus, TaskPriority } from "@/features/tasks/models/types";

export default function TaskEditPage() {
  const params = useParams<{ id: string }>();
  const router = useRouter();
  const [saving, setSaving] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [name, setName] = useState("");
  const [status, setStatus] = useState<TaskStatus>("Open");
  const [priority, setPriority] = useState<TaskPriority>("Medium");
  const [dueDate, setDueDate] = useState("");
  const [estimatedHours, setEstimatedHours] = useState("");

  useEffect(() => {
    (async () => {
      try {
        const t = await taskRepository.get(params.id);
        setName(t.name);
        setStatus(t.status);
        setPriority(t.priority);
        setDueDate(t.dueDate ?? "");
        setEstimatedHours(t.estimatedHours?.toString() ?? "");
      } catch (e) {
        setError(e instanceof Error ? e.message : "Failed to load task");
      } finally {
        setLoading(false);
      }
    })();
  }, [params.id]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      await taskRepository.update(params.id, {
        name,
        status,
        priority,
        dueDate: dueDate || undefined,
        estimatedHours: estimatedHours ? parseFloat(estimatedHours) : undefined,
      });
      router.push(`/tasks/${params.id}`);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to update");
    } finally {
      setSaving(false);
    }
  }

  if (loading) return <div className="p-6"><div className="h-8 w-8 animate-spin rounded-full border-2 border-slate-600 border-t-indigo-500 mx-auto" /></div>;

  return (
    <div className="p-6 max-w-2xl">
      <h1 className="text-2xl font-bold text-slate-50 mb-6">Edit Task</h1>
      {error && <div className="mb-4 rounded-lg bg-red-500/10 border border-red-500/20 p-3 text-sm text-red-400">{error}</div>}
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Name</label>
          <input type="text" required value={name} onChange={(e) => setName(e.target.value)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none" />
        </div>
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Status</label>
          <select value={status} onChange={(e) => setStatus(e.target.value as TaskStatus)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none">
            {["Open", "InProgress", "Completed"].map((s) => <option key={s} value={s}>{s}</option>)}
          </select>
        </div>
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Priority</label>
          <select value={priority} onChange={(e) => setPriority(e.target.value as TaskPriority)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none">
            {["Low", "Medium", "High", "Urgent"].map((p) => <option key={p} value={p}>{p}</option>)}
          </select>
        </div>
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Due Date</label>
          <input type="date" value={dueDate} onChange={(e) => setDueDate(e.target.value)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none" />
        </div>
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Estimated Hours</label>
          <input type="number" step="0.5" value={estimatedHours} onChange={(e) => setEstimatedHours(e.target.value)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none" />
        </div>
        <div className="flex gap-3">
          <button type="submit" disabled={saving} className="rounded-lg bg-indigo-600 px-6 py-2.5 text-sm font-medium text-white hover:bg-indigo-500 disabled:opacity-50 transition-colors">{saving ? "Saving..." : "Save Changes"}</button>
          <button type="button" onClick={() => router.back()} className="rounded-lg border border-slate-600 px-6 py-2.5 text-sm text-slate-300 hover:bg-slate-700 transition-colors">Cancel</button>
        </div>
      </form>
    </div>
  );
}
