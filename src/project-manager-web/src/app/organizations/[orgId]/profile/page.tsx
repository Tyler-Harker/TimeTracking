"use client";

import { useEffect, useState, type FormEvent } from "react";
import { useParams } from "next/navigation";
import { userRepository } from "@/features/user/repository/user-repository";
import type { UserProfile } from "@/features/user/models/types";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { Card, CardHeader, CardTitle, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Button } from "@/components/ui/button";
import { Alert, AlertDescription } from "@/components/ui/alert";

export default function ProfilePage() {
  const params = useParams<{ orgId: string }>();
  const orgId = params.orgId;
  const [user, setUser] = useState<UserProfile | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");

  async function load() {
    setLoading(true);
    try {
      const u = await userRepository.getCurrentUser();
      setUser(u);
      setFirstName(u.firstName);
      setLastName(u.lastName);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load profile");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { load(); }, []);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      await userRepository.updateUser({ firstName, lastName });
      load();
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to update profile");
    } finally {
      setSaving(false);
    }
  }

  if (loading) return <LoadingSpinner />;
  if (error && !user) return <ErrorDisplay message={error} onRetry={load} />;
  if (!user) return null;

  return (
    <div className="p-6 max-w-2xl">
      <h1 className="text-2xl font-bold text-foreground mb-6">Profile</h1>

      <Card className="mb-6">
        <CardContent className="pt-1">
          <p className="text-sm text-muted-foreground"><span className="text-foreground">Email:</span> {user.email}</p>
          <p className="text-sm text-muted-foreground mt-1"><span className="text-foreground">Member since:</span> {new Date(user.createdAt).toLocaleDateString()}</p>
        </CardContent>
      </Card>

      {error && (
        <Alert variant="destructive" className="mb-4">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      )}

      <Card>
        <CardHeader>
          <CardTitle>Edit Profile</CardTitle>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div className="space-y-1.5">
              <Label>First Name</Label>
              <Input type="text" required value={firstName} onChange={(e) => setFirstName(e.target.value)} />
            </div>
            <div className="space-y-1.5">
              <Label>Last Name</Label>
              <Input type="text" required value={lastName} onChange={(e) => setLastName(e.target.value)} />
            </div>
            <Button type="submit" disabled={saving} size="lg">
              {saving ? "Saving..." : "Update Profile"}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  );
}
