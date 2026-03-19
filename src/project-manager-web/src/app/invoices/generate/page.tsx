"use client";

import { useEffect, useState, type FormEvent } from "react";
import { useRouter } from "next/navigation";
import { invoiceRepository } from "@/features/invoices/repository/invoice-repository";
import { clientRepository } from "@/features/clients/repository/client-repository";
import { projectRepository } from "@/features/projects/repository/project-repository";
import type { Client } from "@/features/clients/models/types";
import type { Project } from "@/features/projects/models/types";

export default function InvoiceGeneratePage() {
  const router = useRouter();
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [clients, setClients] = useState<Client[]>([]);
  const [projects, setProjects] = useState<Project[]>([]);
  const [clientId, setClientId] = useState("");
  const [projectId, setProjectId] = useState("");

  useEffect(() => {
    clientRepository.list().then(setClients).catch(() => {});
    projectRepository.list().then(setProjects).catch(() => {});
  }, []);

  const filteredProjects = clientId ? projects.filter((p) => p.clientId === clientId) : projects;

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      await invoiceRepository.generate({ clientId, projectId: projectId || undefined });
      router.push("/invoices");
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to generate invoice");
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="p-6 max-w-2xl">
      <h1 className="text-2xl font-bold text-slate-50 mb-6">Generate Invoice</h1>
      {error && <div className="mb-4 rounded-lg bg-red-500/10 border border-red-500/20 p-3 text-sm text-red-400">{error}</div>}
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Client</label>
          <select required value={clientId} onChange={(e) => setClientId(e.target.value)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none">
            <option value="">Select a client</option>
            {clients.map((c) => <option key={c.id} value={c.id}>{c.name}</option>)}
          </select>
        </div>
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Project (optional)</label>
          <select value={projectId} onChange={(e) => setProjectId(e.target.value)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none">
            <option value="">All projects</option>
            {filteredProjects.map((p) => <option key={p.id} value={p.id}>{p.name}</option>)}
          </select>
        </div>
        <div className="flex gap-3">
          <button type="submit" disabled={saving} className="rounded-lg bg-indigo-600 px-6 py-2.5 text-sm font-medium text-white hover:bg-indigo-500 disabled:opacity-50 transition-colors">{saving ? "Generating..." : "Generate Invoice"}</button>
          <button type="button" onClick={() => router.back()} className="rounded-lg border border-slate-600 px-6 py-2.5 text-sm text-slate-300 hover:bg-slate-700 transition-colors">Cancel</button>
        </div>
      </form>
    </div>
  );
}
