"use client";

import { useRef, useState } from "react";
import { syncRepository } from "@/features/sync/repository/sync-repository";
import type { SyncImportSummary } from "@/features/sync/models/types";
import { ConfirmDialog } from "@/core/components/confirm-dialog";
import { Card, CardHeader, CardTitle, CardContent, CardDescription } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Alert, AlertDescription } from "@/components/ui/alert";
import { Separator } from "@/components/ui/separator";

export default function SyncPage() {
  const fileInputRef = useRef<HTMLInputElement | null>(null);

  const [exporting, setExporting] = useState(false);
  const [importing, setImporting] = useState(false);
  const [pendingFile, setPendingFile] = useState<File | null>(null);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [summary, setSummary] = useState<SyncImportSummary | null>(null);
  const [error, setError] = useState<string | null>(null);

  async function handleExport() {
    setExporting(true);
    setError(null);
    try {
      const { blob, filename } = await syncRepository.export();
      const url = URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = filename;
      document.body.appendChild(a);
      a.click();
      a.remove();
      URL.revokeObjectURL(url);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Export failed");
    } finally {
      setExporting(false);
    }
  }

  function handleFilePick(e: React.ChangeEvent<HTMLInputElement>) {
    const file = e.target.files?.[0];
    if (!file) return;
    setPendingFile(file);
    setSummary(null);
    setError(null);
    setConfirmOpen(true);
    e.target.value = "";
  }

  async function handleConfirmImport() {
    if (!pendingFile) return;
    setConfirmOpen(false);
    setImporting(true);
    setError(null);
    try {
      const text = await pendingFile.text();
      const payload = JSON.parse(text);
      const result = await syncRepository.import(payload);
      setSummary(result);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Import failed");
    } finally {
      setImporting(false);
      setPendingFile(null);
    }
  }

  // TODO: re-enable owner-only gate (currently open to all org members)
  return (
    <div className="p-6 max-w-2xl space-y-6">
      <Card>
        <CardHeader>
          <CardTitle className="text-2xl font-bold">Sync</CardTitle>
          <CardDescription>
            Export all data for this organization as JSON, or replace it from a previously exported file.
          </CardDescription>
        </CardHeader>
        <CardContent className="space-y-6">
          {error && (
            <Alert variant="destructive">
              <AlertDescription>{error}</AlertDescription>
            </Alert>
          )}

          <div className="space-y-2">
            <h3 className="text-base font-semibold">Export</h3>
            <p className="text-sm text-muted-foreground">
              Downloads a JSON file with every client, project, task, team, invoice, and time entry in this organization.
            </p>
            <Button onClick={handleExport} disabled={exporting} size="lg">
              {exporting ? "Exporting..." : "Download JSON"}
            </Button>
          </div>

          <Separator />

          <div className="space-y-2">
            <h3 className="text-base font-semibold text-destructive">Import (destructive)</h3>
            <p className="text-sm text-muted-foreground">
              Replaces all data in this organization with the contents of the selected file. Any data not present in the file is permanently deleted.
            </p>
            <input
              ref={fileInputRef}
              type="file"
              accept="application/json,.json"
              onChange={handleFilePick}
              className="hidden"
            />
            <Button
              variant="destructive"
              size="lg"
              disabled={importing}
              onClick={() => fileInputRef.current?.click()}
            >
              {importing ? "Importing..." : "Choose JSON to import"}
            </Button>
          </div>

          {summary && (
            <Alert>
              <AlertDescription>
                <div className="font-medium mb-2">Import succeeded.</div>
                <ul className="text-sm space-y-0.5">
                  <li>Clients: {summary.clients} ({summary.contacts} contacts)</li>
                  <li>Projects: {summary.projects}</li>
                  <li>Teams: {summary.teams} ({summary.teamMembers} members)</li>
                  <li>Tasks: {summary.tasks}</li>
                  <li>Invoices: {summary.invoices} ({summary.invoiceLineItems} line items)</li>
                  <li>Time entries: {summary.timeEntries}</li>
                </ul>
              </AlertDescription>
            </Alert>
          )}
        </CardContent>
      </Card>

      <ConfirmDialog
        open={confirmOpen}
        title="Replace all organization data?"
        message={`This will permanently delete every client, project, task, team, invoice, and time entry in this organization, then load the contents of "${pendingFile?.name ?? ""}". This cannot be undone.`}
        onConfirm={handleConfirmImport}
        onCancel={() => {
          setConfirmOpen(false);
          setPendingFile(null);
        }}
      />
    </div>
  );
}
