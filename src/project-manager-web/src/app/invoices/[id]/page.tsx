"use client";
import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { invoiceRepository } from "@/features/invoices/repository/invoice-repository";
import type { InvoiceDetail, InvoiceStatus } from "@/features/invoices/models/types";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { StatusBadge } from "@/core/components/status-badge";

export default function InvoiceDetailPage() {
  const params = useParams<{ id: string }>();
  const [invoice, setInvoice] = useState<InvoiceDetail | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  async function load() {
    setLoading(true);
    try {
      setInvoice(await invoiceRepository.get(params.id));
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load invoice");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { load(); }, [params.id]);

  async function updateStatus(status: InvoiceStatus) {
    try {
      await invoiceRepository.updateStatus(params.id, { status });
      load();
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to update status");
    }
  }

  if (loading) return <LoadingSpinner />;
  if (error && !invoice) return <ErrorDisplay message={error} onRetry={load} />;
  if (!invoice) return null;

  return (
    <div className="p-6 max-w-4xl">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-slate-50">{invoice.invoiceNumber}</h1>
          <p className="text-sm text-slate-400">{invoice.clientName}</p>
        </div>
        <StatusBadge status={invoice.status} />
      </div>

      <div className="rounded-xl border border-slate-700 bg-slate-800 p-4 mb-6">
        <div className="grid grid-cols-2 gap-4">
          <p className="text-sm text-slate-400"><span className="text-slate-300">Issued:</span> {invoice.issuedDate}</p>
          <p className="text-sm text-slate-400"><span className="text-slate-300">Due:</span> {invoice.dueDate}</p>
          <p className="text-sm text-slate-400"><span className="text-slate-300">Subtotal:</span> ${(invoice.totalAmount - invoice.taxAmount).toFixed(2)}</p>
          <p className="text-sm text-slate-400"><span className="text-slate-300">Tax ({invoice.taxRate}%):</span> ${invoice.taxAmount.toFixed(2)}</p>
          <p className="text-lg font-bold text-slate-50 col-span-2">Total: ${invoice.totalAmount.toFixed(2)}</p>
          {invoice.paidDate && <p className="text-sm text-green-400 col-span-2">Paid on {invoice.paidDate}</p>}
        </div>
      </div>

      <div className="flex gap-2 mb-6">
        {invoice.status === "Draft" && <button onClick={() => updateStatus("Sent")} className="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white hover:bg-indigo-500 transition-colors">Mark Sent</button>}
        {invoice.status === "Sent" && <button onClick={() => updateStatus("Paid")} className="rounded-lg bg-green-600 px-4 py-2 text-sm font-medium text-white hover:bg-green-500 transition-colors">Mark Paid</button>}
      </div>

      <h2 className="text-lg font-semibold text-slate-50 mb-4">Line Items</h2>
      {invoice.lineItems.length === 0 ? (
        <p className="text-sm text-slate-400">No line items.</p>
      ) : (
        <div className="rounded-xl border border-slate-700 overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-slate-800">
              <tr className="text-left text-slate-400">
                <th className="px-4 py-3">Description</th>
                <th className="px-4 py-3 text-right">Qty</th>
                <th className="px-4 py-3 text-right">Rate</th>
                <th className="px-4 py-3 text-right">Amount</th>
              </tr>
            </thead>
            <tbody className="divide-y divide-slate-700">
              {invoice.lineItems.map((item) => (
                <tr key={item.id} className="bg-slate-800/50">
                  <td className="px-4 py-3 text-slate-50">{item.description}</td>
                  <td className="px-4 py-3 text-right text-slate-300">{item.quantity}</td>
                  <td className="px-4 py-3 text-right text-slate-300">${item.unitPrice.toFixed(2)}</td>
                  <td className="px-4 py-3 text-right text-slate-50">${item.amount.toFixed(2)}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}
