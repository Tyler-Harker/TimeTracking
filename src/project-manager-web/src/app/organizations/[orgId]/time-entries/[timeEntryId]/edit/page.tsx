"use client";
import { useEffect, useState, type FormEvent } from "react";
import { useParams, useRouter } from "next/navigation";
import { timeEntryRepository } from "@/features/time-entries/repository/time-entry-repository";
import { ConfirmDialog } from "@/core/components/confirm-dialog";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import { Alert, AlertDescription } from "@/components/ui/alert";

export default function TimeEntryEditPage() {
  const params = useParams<{ orgId: string; timeEntryId: string }>();
  const router = useRouter();
  const [saving, setSaving] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [showDelete, setShowDelete] = useState(false);
  const [date, setDate] = useState("");
  const [hours, setHours] = useState("");
  const [description, setDescription] = useState("");
  const [isBillable, setIsBillable] = useState(true);

  useEffect(() => {
    (async () => {
      try {
        const entry = await timeEntryRepository.get(params.timeEntryId);
        setDate(entry.date);
        setHours(entry.hours.toString());
        setDescription(entry.description ?? "");
        setIsBillable(entry.isBillable);
      } catch (e) {
        setError(e instanceof Error ? e.message : "Failed to load");
      } finally {
        setLoading(false);
      }
    })();
  }, [params.timeEntryId]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      await timeEntryRepository.update(params.timeEntryId, { date, hours: parseFloat(hours), description: description || undefined, isBillable });
      router.push(`/organizations/${params.orgId}/time-entries`);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to update");
    } finally {
      setSaving(false);
    }
  }

  async function handleDelete() {
    try {
      await timeEntryRepository.delete(params.timeEntryId);
      router.push(`/organizations/${params.orgId}/time-entries`);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to delete time entry");
      setShowDelete(false);
    }
  }

  if (loading) return <LoadingSpinner />;

  return (
    <div className="p-6 max-w-2xl">
      <Card>
        <CardHeader className="flex flex-row items-center justify-between">
          <CardTitle className="text-2xl">Edit Time Entry</CardTitle>
          <Button variant="destructive" onClick={() => setShowDelete(true)}>Delete</Button>
        </CardHeader>
        <CardContent>
          {error && (
            <Alert variant="destructive" className="mb-4">
              <AlertDescription>{error}</AlertDescription>
            </Alert>
          )}
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-2">
              <Label>Date</Label>
              <Input type="date" required value={date} onChange={(e) => setDate(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label>Hours</Label>
              <Input type="number" step="0.25" min="0.25" required value={hours} onChange={(e) => setHours(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label>Description</Label>
              <Textarea value={description} onChange={(e) => setDescription(e.target.value)} rows={3} />
            </div>
            <div className="flex items-center gap-2">
              <Checkbox checked={isBillable} onCheckedChange={(checked) => setIsBillable(checked as boolean)} />
              <Label className="cursor-pointer">Billable</Label>
            </div>
            <div className="flex gap-3">
              <Button type="submit" disabled={saving}>{saving ? "Saving..." : "Save Changes"}</Button>
              <Button type="button" variant="outline" onClick={() => router.back()}>Cancel</Button>
            </div>
          </form>
        </CardContent>
      </Card>
      <ConfirmDialog open={showDelete} title="Delete Time Entry" message="Are you sure?" onConfirm={handleDelete} onCancel={() => setShowDelete(false)} />
    </div>
  );
}
