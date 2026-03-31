"use client";
import { useEffect, useState, type FormEvent } from "react";
import { useParams, useRouter } from "next/navigation";
import { organizationRepository } from "@/features/organizations/repository/organization-repository";
import type { OrganizationDetail } from "@/features/organizations/models/types";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import { Alert, AlertDescription } from "@/components/ui/alert";

export default function OrganizationSettingsPage() {
  const params = useParams<{ orgId: string }>();
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
        const data = await organizationRepository.get(params.orgId);
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
  }, [params.orgId]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      await organizationRepository.update(params.orgId, {
        name,
        description: description || undefined,
        defaultBillableRate: defaultBillableRate ? parseFloat(defaultBillableRate) : undefined,
      });
      router.push(`/organizations/${params.orgId}/dashboard`);
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
      <Card>
        <CardHeader>
          <CardTitle className="text-2xl font-bold">Organization Settings</CardTitle>
        </CardHeader>
        <CardContent>
          {error && (
            <Alert variant="destructive" className="mb-4">
              <AlertDescription>{error}</AlertDescription>
            </Alert>
          )}
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-1.5">
              <Label>Name</Label>
              <Input type="text" required value={name} onChange={(e) => setName(e.target.value)} />
            </div>
            <div className="space-y-1.5">
              <Label>Description</Label>
              <Textarea value={description} onChange={(e) => setDescription(e.target.value)} rows={3} />
            </div>
            <div className="space-y-1.5">
              <Label>Default Billable Rate</Label>
              <Input type="number" step="0.01" value={defaultBillableRate} onChange={(e) => setDefaultBillableRate(e.target.value)} />
            </div>
            <Button type="submit" disabled={saving} size="lg">
              {saving ? "Saving..." : "Save Changes"}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
