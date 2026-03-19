"use client";
import { useEffect, useState, type FormEvent } from "react";
import { useParams, useRouter } from "next/navigation";
import { timeEntryRepository } from "@/features/time-entries/repository/time-entry-repository";
import { ConfirmDialog } from "@/core/components/confirm-dialog";

export default function TimeEntryEditPage() {
  const params = useParams<{ id: string }>();
  const router = useRouter();
  const [saving, setSaving] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [showDelete, setShowDelete] = useState(false);
  const [date, setDate] = useState("");
  const [hours, setHours] = useState("");
  const [description, setDescription] = useState("");
  const [isBillable, setIsBillable] = useState(true);

  useEffect(() => {
    (async () => {
      try {
        const entry = await timeEntryRepository.get(params.id);
        setDate(entry.date);
        setHours(entry.hours.toString());
        setDescription(entry.description ?? "");
        setIsBillable(entry.isBillable);
      } catch (e) {
        setError(e instanceof Error ? e.message : "Failed to load");
      } finally {
        setLoading(false);
      }
    })();
  }, [params.id]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      await timeEntryRepository.update(params.id, { date, hours: parseFloat(hours), description: description || undefined, isBillable });
      router.push("/time-entries");
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to update");
    } finally {
      setSaving(false);
    }
  }

  async function handleDelete() {
    await timeEntryRepository.delete(params.id);
    router.push("/time-entries");
  }

  if (loading) return <div className="p-6"><div className="h-8 w-8 animate-spin rounded-full border-2 border-slate-600 border-t-indigo-500 mx-auto" /></div>;

  return (
    <div className="p-6 max-w-2xl">
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold text-slate-50">Edit Time Entry</h1>
        <button onClick={() => setShowDelete(true)} className="rounded-lg border border-red-500/30 px-4 py-2 text-sm text-red-400 hover:bg-red-500/10 transition-colors">Delete</button>
      </div>
      {error && <div className="mb-4 rounded-lg bg-red-500/10 border border-red-500/20 p-3 text-sm text-red-400">{error}</div>}
      <form onSubmit={handleSubmit} className="space-y-4">
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
          <button type="submit" disabled={saving} className="rounded-lg bg-indigo-600 px-6 py-2.5 text-sm font-medium text-white hover:bg-indigo-500 disabled:opacity-50 transition-colors">{saving ? "Saving..." : "Save Changes"}</button>
          <button type="button" onClick={() => router.back()} className="rounded-lg border border-slate-600 px-6 py-2.5 text-sm text-slate-300 hover:bg-slate-700 transition-colors">Cancel</button>
        </div>
      </form>
      <ConfirmDialog open={showDelete} title="Delete Time Entry" message="Are you sure?" onConfirm={handleDelete} onCancel={() => setShowDelete(false)} />
    </div>
  );
}
