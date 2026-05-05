"use client";

import { useState, type FormEvent } from "react";
import { useRouter } from "next/navigation";
import { organizationRepository } from "@/features/organizations/repository/organization-repository";
import { useAuthStore } from "@/features/auth/store/auth-store";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import { Alert, AlertDescription } from "@/components/ui/alert";

export default function OrganizationNewPage() {
  const router = useRouter();
  const { setActiveOrganization } = useAuthStore();
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [name, setName] = useState("");
  const [description, setDescription] = useState("");
  const [defaultBillableRate, setDefaultBillableRate] = useState("");

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSaving(true);
    setError(null);
    try {
      const created = await organizationRepository.create({
        name,
        description: description || undefined,
        defaultBillableRate: defaultBillableRate ? parseFloat(defaultBillableRate) : undefined,
      });
      setActiveOrganization(created.id);
      router.push(`/organizations/${created.id}/dashboard`);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to create organization");
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-background p-4">
      <div className="w-full max-w-lg">
        <Card>
          <CardHeader>
            <CardTitle className="text-2xl">New Organization</CardTitle>
          </CardHeader>
          <CardContent>
            {error && (
              <Alert variant="destructive" className="mb-4">
                <AlertDescription>{error}</AlertDescription>
              </Alert>
            )}
            <form onSubmit={handleSubmit} className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="name">Name</Label>
                <Input id="name" type="text" required value={name} onChange={(e) => setName(e.target.value)} />
              </div>
              <div className="space-y-2">
                <Label htmlFor="description">Description</Label>
                <Textarea id="description" value={description} onChange={(e) => setDescription(e.target.value)} rows={3} />
              </div>
              <div className="space-y-2">
                <Label htmlFor="rate">Default Billable Rate</Label>
                <Input id="rate" type="number" step="0.01" value={defaultBillableRate} onChange={(e) => setDefaultBillableRate(e.target.value)} />
              </div>
              <div className="flex gap-3">
                <Button type="submit" disabled={saving}>
                  {saving ? "Creating..." : "Create Organization"}
                </Button>
                <Button type="button" variant="outline" onClick={() => router.back()}>
                  Cancel
                </Button>
              </div>
            </form>
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
