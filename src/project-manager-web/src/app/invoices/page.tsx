"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { invoiceRepository } from "@/features/invoices/repository/invoice-repository";
import type { Invoice } from "@/features/invoices/models/types";
import { PageHeader } from "@/core/components/page-header";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { EmptyState } from "@/core/components/empty-state";
import { StatusBadge } from "@/core/components/status-badge";

export default function InvoiceListPage() {
  const [invoices, setInvoices] = useState<Invoice[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  async function load() {
    setLoading(true);
    try {
      setInvoices(await invoiceRepository.list());
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load invoices");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { load(); }, []);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorDisplay message={error} onRetry={load} />;

  return (
    <div className="p-6">
      <PageHeader title="Invoices" action={{ label: "Generate Invoice", href: "/invoices/generate" }} />
      {invoices.length === 0 ? (
        <EmptyState message="No invoices yet." />
      ) : (
        <div className="grid gap-3">
          {invoices.map((inv) => (
            <Link key={inv.id} href={`/invoices/${inv.id}`} className="rounded-xl border border-slate-700 bg-slate-800 p-4 hover:border-indigo-500/50 transition-colors block">
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium text-slate-50">{inv.invoiceNumber}</p>
                  <p className="text-sm text-slate-400">Due {inv.dueDate}</p>
                </div>
                <div className="flex items-center gap-3">
                  <span className="font-medium text-slate-50">${inv.totalAmount.toLocaleString()}</span>
                  <StatusBadge status={inv.status} />
                </div>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
