"use client";
import { useEffect, useState, type FormEvent } from "react";
import { useParams, useRouter } from "next/navigation";
import { clientRepository } from "@/features/clients/repository/client-repository";

export default function ClientEditPage() {
  const params = useParams<{ id: string }>();
  const router = useRouter();
  const [saving, setSaving] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [name, setName] = useState("");
  const [address, setAddress] = useState("");
  const [website, setWebsite] = useState("");
  const [rate, setRate] = useState("");

  useEffect(() => {
    (async () => {
      try {
        const client = await clientRepository.get(params.id);
        setName(client.name);
        setAddress(client.address ?? "");
        setWebsite(client.website ?? "");
        setRate(client.defaultBillableRate?.toString() ?? "");
      } catch (e) {
        setError(e instanceof Error ? e.message : "Failed to load client");
      } finally {
        setLoading(false);
      }
    })();
  }, [params.id]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      await clientRepository.update(params.id, {
        name,
        address: address || undefined,
        website: website || undefined,
        defaultBillableRate: rate ? parseFloat(rate) : undefined,
      });
      router.push(`/clients/${params.id}`);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to update client");
    } finally {
      setSaving(false);
    }
  }

  if (loading) return <div className="p-6"><div className="h-8 w-8 animate-spin rounded-full border-2 border-slate-600 border-t-indigo-500 mx-auto" /></div>;

  return (
    <div className="p-6 max-w-2xl">
      <h1 className="text-2xl font-bold text-slate-50 mb-6">Edit Client</h1>
      {error && <div className="mb-4 rounded-lg bg-red-500/10 border border-red-500/20 p-3 text-sm text-red-400">{error}</div>}
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Name</label>
          <input type="text" required value={name} onChange={(e) => setName(e.target.value)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none" />
        </div>
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Address</label>
          <textarea value={address} onChange={(e) => setAddress(e.target.value)} rows={2} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none" />
        </div>
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Website</label>
          <input type="url" value={website} onChange={(e) => setWebsite(e.target.value)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none" />
        </div>
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Default Billable Rate</label>
          <input type="number" step="0.01" value={rate} onChange={(e) => setRate(e.target.value)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none" />
        </div>
        <div className="flex gap-3">
          <button type="submit" disabled={saving} className="rounded-lg bg-indigo-600 px-6 py-2.5 text-sm font-medium text-white hover:bg-indigo-500 disabled:opacity-50 transition-colors">{saving ? "Saving..." : "Save Changes"}</button>
          <button type="button" onClick={() => router.back()} className="rounded-lg border border-slate-600 px-6 py-2.5 text-sm text-slate-300 hover:bg-slate-700 transition-colors">Cancel</button>
        </div>
      </form>
    </div>
  );
}
