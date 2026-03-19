"use client";
import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import Link from "next/link";
import { clientRepository } from "@/features/clients/repository/client-repository";
import type { ClientDetail, ClientContact } from "@/features/clients/models/types";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { ConfirmDialog } from "@/core/components/confirm-dialog";

export default function ClientDetailPage() {
  const params = useParams<{ id: string }>();
  const router = useRouter();
  const [client, setClient] = useState<ClientDetail | null>(null);
  const [contacts, setContacts] = useState<ClientContact[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [showDelete, setShowDelete] = useState(false);

  async function load() {
    setLoading(true);
    try {
      const [c, ct] = await Promise.all([
        clientRepository.get(params.id),
        clientRepository.listContacts(params.id),
      ]);
      setClient(c);
      setContacts(ct);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load client");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { load(); }, [params.id]);

  async function handleDelete() {
    try {
      await clientRepository.delete(params.id);
      router.push("/clients");
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to delete client");
    }
  }

  if (loading) return <LoadingSpinner />;
  if (error && !client) return <ErrorDisplay message={error} onRetry={load} />;
  if (!client) return null;

  return (
    <div className="p-6 max-w-4xl">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-slate-50">{client.name}</h1>
          <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium mt-1 ${client.isActive ? "bg-green-500/20 text-green-400" : "bg-slate-500/20 text-slate-400"}`}>
            {client.isActive ? "Active" : "Inactive"}
          </span>
        </div>
        <div className="flex gap-2">
          <Link href={`/clients/${params.id}/edit`} className="rounded-lg border border-slate-600 px-4 py-2 text-sm text-slate-300 hover:bg-slate-700 transition-colors">Edit</Link>
          <button onClick={() => setShowDelete(true)} className="rounded-lg border border-red-500/30 px-4 py-2 text-sm text-red-400 hover:bg-red-500/10 transition-colors">Delete</button>
        </div>
      </div>

      <div className="grid gap-4 mb-8">
        <div className="rounded-xl border border-slate-700 bg-slate-800 p-4">
          {client.address && <p className="text-sm text-slate-400 mb-1"><span className="text-slate-300">Address:</span> {client.address}</p>}
          {client.website && <p className="text-sm text-slate-400 mb-1"><span className="text-slate-300">Website:</span> {client.website}</p>}
          {client.defaultBillableRate && <p className="text-sm text-slate-400"><span className="text-slate-300">Rate:</span> ${client.defaultBillableRate}/hr</p>}
        </div>
      </div>

      <div className="flex items-center justify-between mb-4">
        <h2 className="text-lg font-semibold text-slate-50">Contacts</h2>
        <Link href={`/clients/${params.id}/contacts/new`} className="rounded-lg bg-indigo-600 px-3 py-1.5 text-sm font-medium text-white hover:bg-indigo-500 transition-colors">Add Contact</Link>
      </div>
      {contacts.length === 0 ? (
        <p className="text-sm text-slate-400">No contacts yet.</p>
      ) : (
        <div className="grid gap-3">
          {contacts.map((contact) => (
            <div key={contact.id} className="rounded-xl border border-slate-700 bg-slate-800 p-4 flex items-center justify-between">
              <div>
                <p className="font-medium text-slate-50">{contact.name}</p>
                {contact.email && <p className="text-sm text-slate-400">{contact.email}</p>}
                {contact.phone && <p className="text-sm text-slate-400">{contact.phone}</p>}
              </div>
              <Link href={`/clients/${params.id}/contacts/${contact.id}/edit`} className="text-sm text-indigo-400 hover:text-indigo-300">Edit</Link>
            </div>
          ))}
        </div>
      )}

      <ConfirmDialog open={showDelete} title="Delete Client" message="Are you sure? This cannot be undone." onConfirm={handleDelete} onCancel={() => setShowDelete(false)} />
    </div>
  );
}
