"use client";
import { useState, type FormEvent } from "react";
import { useParams, useRouter } from "next/navigation";
import { clientRepository } from "@/features/clients/repository/client-repository";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { Checkbox } from "@/components/ui/checkbox";
import { Alert, AlertDescription } from "@/components/ui/alert";

export default function ContactNewPage() {
  const params = useParams<{ orgId: string; clientId: string }>();
  const router = useRouter();
  const [saving, setSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [name, setName] = useState("");
  const [email, setEmail] = useState("");
  const [phone, setPhone] = useState("");
  const [isStakeHolder, setIsStakeHolder] = useState(false);
  const [isInvoicing, setIsInvoicing] = useState(false);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      await clientRepository.addContact(params.clientId, {
        name,
        email: email || undefined,
        phone: phone || undefined,
        isStakeHolder,
        isInvoicing,
      });
      router.push(`/organizations/${params.orgId}/clients/${params.clientId}`);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to add contact");
    } finally {
      setSaving(false);
    }
  }

  return (
    <div className="p-6 max-w-2xl">
      <Card>
        <CardHeader>
          <CardTitle className="text-2xl">New Contact</CardTitle>
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
              <Label htmlFor="email">Email</Label>
              <Input id="email" type="email" value={email} onChange={(e) => setEmail(e.target.value)} />
            </div>
            <div className="space-y-2">
              <Label htmlFor="phone">Phone</Label>
              <Input id="phone" type="tel" value={phone} onChange={(e) => setPhone(e.target.value)} />
            </div>
            <div className="flex items-center gap-2">
              <Checkbox checked={isStakeHolder} onCheckedChange={(checked) => setIsStakeHolder(checked as boolean)} />
              <Label className="cursor-pointer">Stakeholder</Label>
            </div>
            <div className="flex items-center gap-2">
              <Checkbox checked={isInvoicing} onCheckedChange={(checked) => setIsInvoicing(checked as boolean)} />
              <Label className="cursor-pointer">Invoicing Contact</Label>
            </div>
            <div className="flex gap-3">
              <Button type="submit" disabled={saving}>
                {saving ? "Adding..." : "Add Contact"}
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
