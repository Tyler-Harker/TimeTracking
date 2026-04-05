"use client";
import { useEffect, useState } from "react";
import { useParams } from "next/navigation";
import { invoiceRepository } from "@/features/invoices/repository/invoice-repository";
import { clientRepository } from "@/features/clients/repository/client-repository";
import { organizationRepository } from "@/features/organizations/repository/organization-repository";
import type { InvoiceDetail, InvoiceStatus } from "@/features/invoices/models/types";
import type { ClientContact } from "@/features/clients/models/types";
import type { OrganizationDetail } from "@/features/organizations/models/types";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { StatusBadge } from "@/core/components/status-badge";
import { ConfirmDialog } from "@/core/components/confirm-dialog";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button, buttonVariants } from "@/components/ui/button";
import { Table, TableHeader, TableBody, TableRow, TableHead, TableCell } from "@/components/ui/table";
import { cn } from "@/lib/utils";

export default function InvoiceDetailPage() {
  const params = useParams<{ orgId: string; invoiceId: string }>();
  const [invoice, setInvoice] = useState<InvoiceDetail | null>(null);
  const [org, setOrg] = useState<OrganizationDetail | null>(null);
  const [invoicingContacts, setInvoicingContacts] = useState<ClientContact[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [copied, setCopied] = useState(false);
  const [showCancel, setShowCancel] = useState(false);

  async function load() {
    setLoading(true);
    try {
      const [inv, orgData] = await Promise.all([
        invoiceRepository.get(params.invoiceId),
        organizationRepository.get(params.orgId),
      ]);
      setInvoice(inv);
      setOrg(orgData);
      if (inv.clientId) {
        const contacts = await clientRepository.listContacts(inv.clientId);
        setInvoicingContacts(contacts.filter((c) => c.isInvoicing && c.email));
      }
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load invoice");
    } finally {
      setLoading(false);
    }
  }

  function buildInvoiceHtml() {
    if (!invoice) return "";
    const subtotal = (invoice.totalAmount - invoice.taxAmount).toFixed(2);
    const rows = invoice.lineItems
      .map(
        (li) =>
          `<tr>
            <td style="padding:8px 12px;border-bottom:1px solid #e2e8f0">${li.description}</td>
            <td style="padding:8px 12px;border-bottom:1px solid #e2e8f0;text-align:right">${li.quantity}</td>
            <td style="padding:8px 12px;border-bottom:1px solid #e2e8f0;text-align:right">$${li.unitPrice.toFixed(2)}</td>
            <td style="padding:8px 12px;border-bottom:1px solid #e2e8f0;text-align:right"><strong>$${li.amount.toFixed(2)}</strong></td>
          </tr>`
      )
      .join("");

    const hasOrgInfo = org?.name || org?.address || org?.phone || org?.email;

    return `
<div style="font-family:Arial,sans-serif;color:#1e293b;max-width:600px">
  ${hasOrgInfo ? `
  <div style="margin-bottom:24px;padding-bottom:16px;border-bottom:2px solid #4F46E5">
    <div style="font-size:20px;font-weight:700;color:#1e293b">${org?.name ?? ""}</div>
    ${org?.address ? `<div style="font-size:13px;color:#64748b;white-space:pre-line;margin-top:4px">${org.address}</div>` : ""}
    <div style="font-size:13px;color:#64748b;margin-top:2px">
      ${[org?.phone, org?.email].filter(Boolean).join(" &bull; ")}
    </div>
  </div>` : ""}

  <p>Hi,</p>
  <p>Please find details for invoice <strong>${invoice.invoiceNumber}</strong>.</p>

  <table style="width:100%;border-collapse:collapse;margin:16px 0">
    <tr>
      <td style="padding:4px 0;color:#64748b">Invoice Number</td>
      <td style="padding:4px 0"><strong>${invoice.invoiceNumber}</strong></td>
    </tr>
    <tr>
      <td style="padding:4px 0;color:#64748b">Issued</td>
      <td style="padding:4px 0">${invoice.issuedDate}</td>
    </tr>
    <tr>
      <td style="padding:4px 0;color:#64748b">Due</td>
      <td style="padding:4px 0">${invoice.dueDate}</td>
    </tr>
  </table>

  <table style="width:100%;border-collapse:collapse;margin:16px 0;border:1px solid #e2e8f0;border-radius:8px">
    <thead>
      <tr style="background:#f8fafc">
        <th style="padding:8px 12px;text-align:left;border-bottom:2px solid #e2e8f0;color:#64748b;font-weight:600">Description</th>
        <th style="padding:8px 12px;text-align:right;border-bottom:2px solid #e2e8f0;color:#64748b;font-weight:600">Qty</th>
        <th style="padding:8px 12px;text-align:right;border-bottom:2px solid #e2e8f0;color:#64748b;font-weight:600">Rate</th>
        <th style="padding:8px 12px;text-align:right;border-bottom:2px solid #e2e8f0;color:#64748b;font-weight:600">Amount</th>
      </tr>
    </thead>
    <tbody>${rows}</tbody>
    <tfoot>
      <tr>
        <td colspan="3" style="padding:8px 12px;text-align:right;color:#64748b">Subtotal</td>
        <td style="padding:8px 12px;text-align:right">$${subtotal}</td>
      </tr>
      <tr>
        <td colspan="3" style="padding:8px 12px;text-align:right;color:#64748b">Tax (${invoice.taxRate}%)</td>
        <td style="padding:8px 12px;text-align:right">$${invoice.taxAmount.toFixed(2)}</td>
      </tr>
      <tr style="background:#f8fafc">
        <td colspan="3" style="padding:8px 12px;text-align:right;font-weight:700;font-size:16px">Total</td>
        <td style="padding:8px 12px;text-align:right;font-weight:700;font-size:16px">$${invoice.totalAmount.toFixed(2)}</td>
      </tr>
    </tfoot>
  </table>

  ${invoice.notes ? `<p style="color:#64748b"><em>Notes: ${invoice.notes}</em></p>` : ""}

  ${org?.bankAccountNumber || org?.bankRoutingNumber ? `
  <hr style="border:none;border-top:1px solid #e2e8f0;margin:20px 0" />
  <table style="width:100%;border-collapse:collapse">
    <tr>
      <td colspan="2" style="padding:4px 0;font-weight:600;font-size:14px">Payment Information</td>
    </tr>
    ${org.bankRoutingNumber ? `<tr>
      <td style="padding:4px 0;color:#64748b;width:140px">Routing Number</td>
      <td style="padding:4px 0">${org.bankRoutingNumber}</td>
    </tr>` : ""}
    ${org.bankAccountNumber ? `<tr>
      <td style="padding:4px 0;color:#64748b;width:140px">Account Number</td>
      <td style="padding:4px 0">${org.bankAccountNumber}</td>
    </tr>` : ""}
  </table>` : ""}

  <p>Thank you.</p>
</div>`.trim();
  }

  async function handleDownloadPdf() {
    if (!invoice) return;
    const html2pdf = (await import("html2pdf.js")).default;
    const html = buildInvoiceHtml();
    const container = document.createElement("div");
    container.innerHTML = html;
    document.body.appendChild(container);

    await html2pdf()
      .set({
        margin: [15, 15, 20, 15],
        filename: `${invoice.invoiceNumber}.pdf`,
        image: { type: "jpeg", quality: 0.98 },
        html2canvas: { scale: 2 },
        jsPDF: { unit: "mm", format: "a4", orientation: "portrait" },
        pagebreak: { mode: "avoid-all" },
      })
      .from(container)
      .save();

    document.body.removeChild(container);
  }

  async function handleSendInvoice() {
    if (!invoice) return;
    const to = invoicingContacts.map((c) => c.email).join(";");
    const subject = `Invoice ${invoice.invoiceNumber} - $${invoice.totalAmount.toFixed(2)}`;
    const html = buildInvoiceHtml();

    // Copy HTML to clipboard so user can paste formatted content
    try {
      await navigator.clipboard.write([
        new ClipboardItem({
          "text/html": new Blob([html], { type: "text/html" }),
          "text/plain": new Blob([`Invoice ${invoice.invoiceNumber} - $${invoice.totalAmount.toFixed(2)}`], { type: "text/plain" }),
        }),
      ]);
      setCopied(true);
      setTimeout(() => setCopied(false), 3000);
    } catch { /* clipboard may not be available */ }

    const a = document.createElement("a");
    a.href = `mailto:${to}?subject=${subject}`;
    a.setAttribute("target", "_blank");
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
  }

  useEffect(() => { load(); }, [params.invoiceId]);

  async function updateStatus(status: InvoiceStatus) {
    try {
      await invoiceRepository.updateStatus(params.invoiceId, { status });
      load();
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to update status");
    }
  }

  if (loading) return <LoadingSpinner />;
  if (error && !invoice) return <ErrorDisplay message={error} onRetry={load} />;
  if (!invoice) return null;

  return (
    <div className="p-6 max-w-4xl space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-2xl font-bold text-foreground">{invoice.invoiceNumber}</h1>
          <p className="text-sm text-muted-foreground">{invoice.clientName}</p>
        </div>
        <StatusBadge status={invoice.status} />
      </div>

      <Card>
        <CardContent>
          <div className="grid grid-cols-2 gap-4">
            <p className="text-sm text-muted-foreground"><span className="text-foreground">Issued:</span> {invoice.issuedDate}</p>
            <p className="text-sm text-muted-foreground"><span className="text-foreground">Due:</span> {invoice.dueDate}</p>
            <p className="text-sm text-muted-foreground"><span className="text-foreground">Subtotal:</span> ${(invoice.totalAmount - invoice.taxAmount).toFixed(2)}</p>
            <p className="text-sm text-muted-foreground"><span className="text-foreground">Tax ({invoice.taxRate}%):</span> ${invoice.taxAmount.toFixed(2)}</p>
            <p className="text-lg font-bold text-foreground col-span-2">Total: ${invoice.totalAmount.toFixed(2)}</p>
            {invoice.paidDate && <p className="text-sm text-green-400 col-span-2">Paid on {invoice.paidDate}</p>}
          </div>
        </CardContent>
      </Card>

      <div className="flex gap-2">
        {invoice.status === "Draft" && <Button onClick={() => updateStatus("Sent")}>Mark Sent</Button>}
        {invoice.status === "Sent" && <Button onClick={() => updateStatus("Paid")} className="bg-green-600 hover:bg-green-500 text-white">Mark Paid</Button>}
        {invoice.status === "Overdue" && <Button onClick={() => updateStatus("Paid")} className="bg-green-600 hover:bg-green-500 text-white">Mark Paid</Button>}
        {["Draft", "Sent", "Overdue"].includes(invoice.status) && (
          <Button variant="destructive" onClick={() => setShowCancel(true)}>Cancel Invoice</Button>
        )}
        <Button
          variant="outline"
          disabled={invoicingContacts.length === 0}
          title={invoicingContacts.length === 0 ? "No invoicing contacts with email set for this client" : "Opens email with invoice body copied to clipboard"}
          onClick={handleSendInvoice}
        >
          {copied ? "Body copied — paste in email" : "Send Invoice"}
        </Button>
        <Button variant="outline" onClick={handleDownloadPdf}>
          Download PDF
        </Button>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Line Items</CardTitle>
        </CardHeader>
        <CardContent>
          {invoice.lineItems.length === 0 ? (
            <p className="text-sm text-muted-foreground">No line items.</p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>Description</TableHead>
                  <TableHead className="text-right">Qty</TableHead>
                  <TableHead className="text-right">Rate</TableHead>
                  <TableHead className="text-right">Amount</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {invoice.lineItems.map((item) => (
                  <TableRow key={item.id}>
                    <TableCell className="text-foreground">{item.description}</TableCell>
                    <TableCell className="text-right text-muted-foreground">{item.quantity}</TableCell>
                    <TableCell className="text-right text-muted-foreground">${item.unitPrice.toFixed(2)}</TableCell>
                    <TableCell className="text-right text-foreground">${item.amount.toFixed(2)}</TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          )}
        </CardContent>
      </Card>

      <ConfirmDialog
        open={showCancel}
        title="Cancel Invoice"
        message={`Are you sure you want to cancel ${invoice.invoiceNumber}? This will unmark all associated time entries as invoiced.`}
        onConfirm={async () => {
          await updateStatus("Cancelled");
          setShowCancel(false);
        }}
        onCancel={() => setShowCancel(false)}
      />
    </div>
  );
}
