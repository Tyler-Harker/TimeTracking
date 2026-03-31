"use client";
import { useEffect, useState, type FormEvent } from "react";
import { useParams, useRouter } from "next/navigation";
import { clientRepository } from "@/features/clients/repository/client-repository";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Textarea } from "@/components/ui/textarea";
import { Button } from "@/components/ui/button";
import { Alert, AlertDescription } from "@/components/ui/alert";

export default function ClientEditPage() {
  const params = useParams<{ orgId: string; clientId: string }>();
  const router = useRouter();
  const [saving, setSaving] = useState(false);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [name, setName] = useState("");
  const [address, setAddress] = useState("");
  const [website, setWebsite] = useState("");
  const [rate, setRate] = useState("");

  useEffect(() => {
    (async () => {
      try {
        const client = await clientRepository.get(params.clientId);
        setName(client.name);
        setAddress(client.address ?? "");
        setWebsite(client.website ?? "");
        setRate(client.defaultBillableRate?.toString() ?? "");
      } catch (e) {
        setError(e instanceof Error ? e.message : "Failed to load client");
      } finally {
        setLoading(false);
      }
    })();
  }, [params.clientId]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      await clientRepository.update(params.clientId, {
        name,
        address: address || undefined,
        website: website || undefined,
        defaultBillableRate: rate ? parseFloat(rate) : undefined,
      });
      router.push(`/organizations/${params.orgId}/clients/${params.clientId}`);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to update client");
    } finally {
      setSaving(false);
    }
  }

  if (loading) return <LoadingSpinner />;

  return (
    <div className="p-6 max-w-2xl">
      <Card>
        <CardHeader>
          <CardTitle className="text-2xl">Edit Client</CardTitle>
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
              <Label htmlFor="address">Address</Label>
              <Textarea id="address" value={address} onChange={(e) => setAddress(e.target.value)} rows={2} />
            </div>
            <div className="space-y-2">
              <Label htmlFor="website">Website</Label>
              <Input id="website" type="url" value={website} onChange={(e) => setWebsite(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label htmlFor="rate">Default Billable Rate</Label>
              <Input id="rate" type="number" step="0.01" value={rate} onChange={(e) => setRate(e.target.value)} />
            </div>
            <div className="flex gap-3">
              <Button type="submit" disabled={saving}>
                {saving ? "Saving..." : "Save Changes"}
              </Button>
              <Button type="button" variant="outline" onClick={() => router.back()}>
                Cancel
              </Button>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
