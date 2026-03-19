"use client";
import { useEffect, useState, type FormEvent } from "react";
import { useParams, useRouter } from "next/navigation";
import { organizationRepository } from "@/features/organizations/repository/organization-repository";
import type { OrganizationDetail } from "@/features/organizations/models/types";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";

export default function OrganizationSettingsPage() {
  const params = useParams<{ id: string }>();
  const router = useRouter();
  const [org, setOrg] = useState<OrganizationDetail | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [defaultBillableRate, setDefaultBillableRate] = useState("");

  useEffect(() => {
    (async () => {
      try {
        const data = await organizationRepository.get(params.id);
        setOrg(data);
        setName(data.name);
        setDescription(data.description ?? "");
        setDefaultBillableRate(data.defaultBillableRate?.toString() ?? "");
      } catch (e) {
        setError(e instanceof Error ? e.message : "Failed to load organization");
      } finally {
        setLoading(false);
      }
    })();
  }, [params.id]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      await organizationRepository.update(params.id, {
        name,
        description: description || undefined,
        defaultBillableRate: defaultBillableRate ? parseFloat(defaultBillableRate) : undefined,
      });
      router.push("/dashboard");
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to update");
    } finally {
      setSaving(false);
    }
  }

  if (loading) return <LoadingSpinner />;
  if (error && !org) return <ErrorDisplay message={error} />;

  return (
    <div className="p-6 max-w-2xl">
      <h1 className="text-2xl font-bold text-slate-50 mb-6">Organization Settings</h1>
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Name</label>
          <input type="text" required value={name} onChange={(e) => setName(e.target.value)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none" />
        </div>
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Description</label>
          <textarea value={description} onChange={(e) => setDescription(e.target.value)} rows={3} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none" />
        </div>
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Default Billable Rate</label>
          <input type="number" step="0.01" value={defaultBillableRate} onChange={(e) => setDefaultBillableRate(e.target.value)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none" />
        </div>
        {error && <p className="text-sm text-red-400">{error}</p>}
        <button type="submit" disabled={saving} className="rounded-lg bg-indigo-600 px-6 py-2.5 text-sm font-medium text-white hover:bg-indigo-500 disabled:opacity-50 transition-colors">
          {saving ? "Saving..." : "Save Changes"}
        </button>
      </form>
    </div>
  );
}
