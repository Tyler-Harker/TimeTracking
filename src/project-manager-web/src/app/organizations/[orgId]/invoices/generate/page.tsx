"use client";

import { useEffect, useMemo, useState, type FormEvent } from "react";
import { useParams, useRouter } from "next/navigation";
import { invoiceRepository } from "@/features/invoices/repository/invoice-repository";
import { clientRepository } from "@/features/clients/repository/client-repository";
import { projectRepository } from "@/features/projects/repository/project-repository";
import type { Client } from "@/features/clients/models/types";
import type { Project } from "@/features/projects/models/types";
import type { InvoicePreview } from "@/features/invoices/models/types";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import { Select, SelectTrigger, SelectValue, SelectContent, SelectItem } from "@/components/ui/select";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Table, TableBody, TableCell, TableFooter, TableHead, TableHeader, TableRow } from "@/components/ui/table";

const currency = new Intl.NumberFormat("en-US", { style: "currency", currency: "USD" });

export default function InvoiceGeneratePage() {
  const params = useParams<{ orgId: string }>();
  const router = useRouter();
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [clients, setClients] = useState<Client[]>([]);
  const [projects, setProjects] = useState<Project[]>([]);
  const [clientId, setClientId] = useState("");
  const [projectId, setProjectId] = useState("");
  const [taxRate, setTaxRate] = useState("0");
  const [dueDate, setDueDate] = useState(() => {
    const d = new Date();
    d.setDate(d.getDate() + 30);
    return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, "0")}-${String(d.getDate()).padStart(2, "0")}`;
  });
  const [notes, setNotes] = useState("");

  const [preview, setPreview] = useState<InvoicePreview | null>(null);
  const [previewLoading, setPreviewLoading] = useState(false);
  const [previewError, setPreviewError] = useState<string | null>(null);

  useEffect(() => {
    clientRepository.list().then(setClients).catch((e) => {
      setError(e instanceof Error ? e.message : "Failed to load clients");
    });
    projectRepository.list().then(setProjects).catch((e) => {
      setError(e instanceof Error ? e.message : "Failed to load projects");
    });
  }, []);

  const filteredProjects = clientId ? projects.filter((p) => p.clientId === clientId) : projects;

  useEffect(() => {
    if (!clientId && !projectId) {
      setPreview(null);
      setPreviewError(null);
      return;
    }
    let cancelled = false;
    setPreviewLoading(true);
    setPreviewError(null);
    invoiceRepository
      .preview({ clientId: clientId || undefined, projectId: projectId || undefined })
      .then((p) => {
        if (!cancelled) setPreview(p);
      })
      .catch((e) => {
        if (!cancelled) {
          setPreview(null);
          setPreviewError(e instanceof Error ? e.message : "Failed to load preview");
        }
      })
      .finally(() => {
        if (!cancelled) setPreviewLoading(false);
      });
    return () => {
      cancelled = true;
    };
  }, [clientId, projectId]);

  const parsedTaxRate = useMemo(() => {
    const n = parseFloat(taxRate);
    return Number.isNaN(n) ? 0 : n;
  }, [taxRate]);

  const taxAmount = preview ? preview.subtotal * (parsedTaxRate / 100) : 0;
  const total = preview ? preview.subtotal + taxAmount : 0;

  const hasFilters = Boolean(clientId || projectId);
  const hasEntries = preview != null && preview.entryCount > 0;
  const canGenerate = hasFilters && hasEntries && !saving;

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    if (!clientId && !projectId) {
      setError("Either a client or project must be selected");
      return;
    }
    setSaving(true);
    setError(null);
    try {
      await invoiceRepository.generate({
        clientId: clientId || undefined,
        projectId: projectId || undefined,
        taxRate: parsedTaxRate,
        dueDate,
        notes: notes || undefined,
      });
      router.push(`/organizations/${params.orgId}/invoices`);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to generate invoice");
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="grid gap-6 p-6 lg:grid-cols-[minmax(0,1fr)_minmax(0,1.2fr)]">
      <Card>
        <CardHeader>
          <CardTitle className="text-2xl">Generate Invoice</CardTitle>
        </CardHeader>
        <CardContent>
          {error && (
            <Alert variant="destructive" className="mb-4">
              <AlertDescription>{error}</AlertDescription>
            </Alert>
          )}
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label>Client</Label>
              <Select value={clientId} onValueChange={(val) => setClientId(val ?? "")}>
                <SelectTrigger className="w-full">
                  <SelectValue placeholder="Select a client" />
                </SelectTrigger>
                <SelectContent>
                  {clients.map((c) => <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label>Project (optional)</Label>
              <Select value={projectId} onValueChange={(val) => setProjectId(val ?? "")}>
                <SelectTrigger className="w-full">
                  <SelectValue placeholder="All projects" />
                </SelectTrigger>
                <SelectContent>
                  {filteredProjects.map((p) => <SelectItem key={p.id} value={p.id}>{p.name}</SelectItem>)}
                </SelectContent>
              </Select>
            </div>
            <div className="space-y-2">
              <Label htmlFor="taxRate">Tax Rate (%)</Label>
              <Input
                id="taxRate"
                type="number"
                step="0.01"
                min="0"
                max="100"
                required
                value={taxRate}
                onChange={(e) => setTaxRate(e.target.value)}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="dueDate">Due Date</Label>
              <Input
                id="dueDate"
                type="date"
                required
                value={dueDate}
                onChange={(e) => setDueDate(e.target.value)}
              />
            </div>
            <div className="space-y-2">
              <Label htmlFor="notes">Notes (optional)</Label>
              <Textarea
                id="notes"
                value={notes}
                onChange={(e) => setNotes(e.target.value)}
                rows={3}
                placeholder="Payment terms, additional info..."
              />
            </div>
            <div className="flex gap-3">
              <Button type="submit" disabled={!canGenerate}>{saving ? "Generating..." : "Generate Invoice"}</Button>
              <Button type="button" variant="outline" onClick={() => router.back()}>Cancel</Button>
            </div>
          </form>
        </CardContent>
      </Card>

      <Card>
        <CardHeader className="flex flex-row items-baseline justify-between">
          <CardTitle className="text-2xl">Preview</CardTitle>
          {preview && (
            <span className="text-sm text-muted-foreground">
              {preview.entryCount} time {preview.entryCount === 1 ? "entry" : "entries"}
            </span>
          )}
        </CardHeader>
        <CardContent>
          {!hasFilters ? (
            <p className="py-6 text-center text-sm text-muted-foreground">
              Select a client or project to see a preview.
            </p>
          ) : previewError ? (
            <Alert variant="destructive">
              <AlertDescription>{previewError}</AlertDescription>
            </Alert>
          ) : previewLoading && !preview ? (
            <p className="py-6 text-center text-sm text-muted-foreground">Loading preview…</p>
          ) : !preview || preview.lineItems.length === 0 ? (
            <p className="py-6 text-center text-sm text-muted-foreground">
              No unbilled time entries match these filters.
            </p>
          ) : (
            <>
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Description</TableHead>
                    <TableHead className="text-right">Hours</TableHead>
                    <TableHead className="text-right">Rate</TableHead>
                    <TableHead className="text-right">Amount</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {preview.lineItems.map((li) => (
                    <TableRow key={li.projectId}>
                      <TableCell className="whitespace-normal">
                        <div className="font-medium text-foreground">{li.projectName}</div>
                        <div className="text-xs text-muted-foreground">{li.description}</div>
                      </TableCell>
                      <TableCell className="text-right tabular-nums">{li.quantity.toFixed(2)}</TableCell>
                      <TableCell className="text-right tabular-nums">{currency.format(li.unitPrice)}</TableCell>
                      <TableCell className="text-right tabular-nums">{currency.format(li.amount)}</TableCell>
                    </TableRow>
                  ))}
                </TableBody>
                <TableFooter>
                  <TableRow>
                    <TableCell colSpan={3} className="text-right">Subtotal</TableCell>
                    <TableCell className="text-right tabular-nums">{currency.format(preview.subtotal)}</TableCell>
                  </TableRow>
                  <TableRow>
                    <TableCell colSpan={3} className="text-right">Tax ({parsedTaxRate}%)</TableCell>
                    <TableCell className="text-right tabular-nums">{currency.format(taxAmount)}</TableCell>
                  </TableRow>
                  <TableRow>
                    <TableCell colSpan={3} className="text-right text-base font-semibold">Total</TableCell>
                    <TableCell className="text-right text-base font-semibold tabular-nums">{currency.format(total)}</TableCell>
                  </TableRow>
                </TableFooter>
              </Table>
              {previewLoading && (
                <p className="mt-2 text-right text-xs text-muted-foreground">Refreshing…</p>
              )}
            </>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
