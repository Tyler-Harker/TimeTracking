"use client";

import { useEffect, useState, type FormEvent } from "react";
import { useParams, useRouter } from "next/navigation";
import { invoiceRepository } from "@/features/invoices/repository/invoice-repository";
import { clientRepository } from "@/features/clients/repository/client-repository";
import { projectRepository } from "@/features/projects/repository/project-repository";
import type { Client } from "@/features/clients/models/types";
import type { Project } from "@/features/projects/models/types";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import { Select, SelectTrigger, SelectValue, SelectContent, SelectItem } from "@/components/ui/select";
import { Alert, AlertDescription } from "@/components/ui/alert";

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

  useEffect(() => {
    clientRepository.list().then(setClients).catch((e) => {
      setError(e instanceof Error ? e.message : "Failed to load clients");
    });
    projectRepository.list().then(setProjects).catch((e) => {
      setError(e instanceof Error ? e.message : "Failed to load projects");
    });
  }, []);

  const filteredProjects = clientId ? projects.filter((p) => p.clientId === clientId) : projects;

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
        taxRate: parseFloat(taxRate),
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
    <div className="p-6 max-w-2xl">
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
              <Button type="submit" disabled={saving}>{saving ? "Generating..." : "Generate Invoice"}</Button>
              <Button type="button" variant="outline" onClick={() => router.back()}>Cancel</Button>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
