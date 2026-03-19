"use client";

import { useEffect, useState, type FormEvent } from "react";
import { useRouter } from "next/navigation";
import { timeEntryRepository } from "@/features/time-entries/repository/time-entry-repository";
import { projectRepository } from "@/features/projects/repository/project-repository";
import type { Project } from "@/features/projects/models/types";

export default function TimeEntryNewPage() {
  const router = useRouter();
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [projects, setProjects] = useState<Project[]>([]);
  const [projectId, setProjectId] = useState("");
  const [date, setDate] = useState(new Date().toISOString().split("T")[0]);
  const [hours, setHours] = useState("");
  const [description, setDescription] = useState("");
  const [isBillable, setIsBillable] = useState(true);

  useEffect(() => {
    projectRepository.list().then(setProjects).catch(() => {});
  }, []);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      await timeEntryRepository.create({ projectId, date, hours: parseFloat(hours), description: description || undefined, isBillable });
      router.push("/time-entries");
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to create");
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="p-6 max-w-2xl">
      <h1 className="text-2xl font-bold text-slate-50 mb-6">New Time Entry</h1>
      {error && <div className="mb-4 rounded-lg bg-red-500/10 border border-red-500/20 p-3 text-sm text-red-400">{error}</div>}
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Project</label>
          <select required value={projectId} onChange={(e) => setProjectId(e.target.value)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none">
            <option value="">Select a project</option>
            {projects.map((p) => <option key={p.id} value={p.id}>{p.name}</option>)}
          </select>
        </div>
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Date</label>
          <input type="date" required value={date} onChange={(e) => setDate(e.target.value)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none" />
        </div>
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Hours</label>
          <input type="number" step="0.25" min="0.25" required value={hours} onChange={(e) => setHours(e.target.value)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none" />
        </div>
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Description</label>
          <textarea value={description} onChange={(e) => setDescription(e.target.value)} rows={3} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none" />
        </div>
        <label className="flex items-center gap-2 text-sm text-slate-300">
          <input type="checkbox" checked={isBillable} onChange={(e) => setIsBillable(e.target.checked)} className="rounded border-slate-600 bg-slate-800 text-indigo-500" />
          Billable
        </label>
        <div className="flex gap-3">
          <button type="submit" disabled={saving} className="rounded-lg bg-indigo-600 px-6 py-2.5 text-sm font-medium text-white hover:bg-indigo-500 disabled:opacity-50 transition-colors">{saving ? "Creating..." : "Log Time"}</button>
          <button type="button" onClick={() => router.back()} className="rounded-lg border border-slate-600 px-6 py-2.5 text-sm text-slate-300 hover:bg-slate-700 transition-colors">Cancel</button>
        </div>
      </form>
    </div>
  );
}
