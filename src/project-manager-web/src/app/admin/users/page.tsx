"use client";

import { useCallback, useEffect, useState, type FormEvent } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { Input } from "@/components/ui/input";
import { Label } from "@/components/ui/label";
import { Badge } from "@/components/ui/badge";
import { Alert, AlertDescription } from "@/components/ui/alert";
import {
  Table,
  TableHeader,
  TableRow,
  TableHead,
  TableBody,
  TableCell,
} from "@/components/ui/table";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogDescription,
  DialogFooter,
} from "@/components/ui/dialog";
import {
  adminRepository,
  type AdminUser,
} from "@/features/admin/repository/admin-repository";
import { adminTokenStorage } from "@/features/admin/storage/admin-token-storage";

const PAGE_SIZE = 50;

export default function AdminUsersPage() {
  const router = useRouter();
  const [search, setSearch] = useState("");
  const [appliedSearch, setAppliedSearch] = useState("");
  const [page, setPage] = useState(1);
  const [users, setUsers] = useState<AdminUser[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [info, setInfo] = useState<string | null>(null);

  const [passwordTarget, setPasswordTarget] = useState<AdminUser | null>(null);
  const [newPassword, setNewPassword] = useState("");
  const [confirmPassword, setConfirmPassword] = useState("");
  const [passwordError, setPasswordError] = useState<string | null>(null);
  const [passwordSaving, setPasswordSaving] = useState(false);

  const [activeTarget, setActiveTarget] = useState<AdminUser | null>(null);
  const [activeSaving, setActiveSaving] = useState(false);

  const loadUsers = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await adminRepository.listUsers({
        search: appliedSearch || undefined,
        page,
        pageSize: PAGE_SIZE,
      });
      setUsers(response.items);
      setTotal(response.total);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load users");
    } finally {
      setLoading(false);
    }
  }, [appliedSearch, page]);

  useEffect(() => {
    if (!adminTokenStorage.hasValid()) {
      router.replace("/admin");
      return;
    }
    loadUsers();
  }, [loadUsers, router]);

  function handleSearch(e: FormEvent) {
    e.preventDefault();
    setPage(1);
    setAppliedSearch(search.trim());
  }

  function handleSignOut() {
    adminTokenStorage.clear();
    router.replace("/admin");
  }

  function openPasswordDialog(user: AdminUser) {
    setPasswordTarget(user);
    setNewPassword("");
    setConfirmPassword("");
    setPasswordError(null);
  }

  async function submitPassword(e: FormEvent) {
    e.preventDefault();
    if (!passwordTarget) return;
    if (newPassword !== confirmPassword) {
      setPasswordError("Passwords do not match");
      return;
    }
    setPasswordSaving(true);
    setPasswordError(null);
    try {
      await adminRepository.resetPassword(passwordTarget.id, newPassword);
      setInfo(`Password reset for ${passwordTarget.email}`);
      setPasswordTarget(null);
    } catch (e) {
      setPasswordError(e instanceof Error ? e.message : "Failed to reset password");
    } finally {
      setPasswordSaving(false);
    }
  }

  async function confirmToggleActive() {
    if (!activeTarget) return;
    setActiveSaving(true);
    try {
      const next = !activeTarget.isActive;
      const updated = await adminRepository.setActive(activeTarget.id, next);
      setUsers((prev) =>
        prev.map((u) => (u.id === updated.id ? { ...u, isActive: updated.isActive } : u))
      );
      setInfo(`${updated.email} ${updated.isActive ? "activated" : "deactivated"}`);
      setActiveTarget(null);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to update user");
    } finally {
      setActiveSaving(false);
    }
  }

  const totalPages = Math.max(1, Math.ceil(total / PAGE_SIZE));

  return (
    <div className="min-h-screen bg-background p-4 md:p-8">
      <div className="mx-auto max-w-6xl space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-2xl font-bold">User Administration</h1>
            <p className="text-sm text-muted-foreground">
              Manage user passwords and account status across all organizations.
            </p>
          </div>
          <div className="flex gap-2">
            <Link
              href="/admin/organizations"
              className="text-sm text-muted-foreground underline-offset-4 hover:underline self-center"
            >
              Organizations
            </Link>
            <Button variant="outline" onClick={handleSignOut}>
              Sign Out
            </Button>
          </div>
        </div>

        {error && (
          <Alert variant="destructive">
            <AlertDescription>{error}</AlertDescription>
          </Alert>
        )}
        {info && (
          <Alert>
            <AlertDescription>{info}</AlertDescription>
          </Alert>
        )}

        <Card>
          <CardHeader>
            <CardTitle>Users ({total})</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <form onSubmit={handleSearch} className="flex gap-2">
              <Input
                placeholder="Search by email or name"
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                className="max-w-sm"
              />
              <Button type="submit" variant="secondary">
                Search
              </Button>
              {appliedSearch && (
                <Button
                  type="button"
                  variant="ghost"
                  onClick={() => {
                    setSearch("");
                    setAppliedSearch("");
                    setPage(1);
                  }}
                >
                  Clear
                </Button>
              )}
            </form>

            <div className="overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Email</TableHead>
                    <TableHead>Name</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead>Created</TableHead>
                    <TableHead className="text-right">Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {loading && (
                    <TableRow>
                      <TableCell colSpan={5} className="text-center text-muted-foreground">
                        Loading...
                      </TableCell>
                    </TableRow>
                  )}
                  {!loading && users.length === 0 && (
                    <TableRow>
                      <TableCell colSpan={5} className="text-center text-muted-foreground">
                        No users found
                      </TableCell>
                    </TableRow>
                  )}
                  {!loading &&
                    users.map((user) => (
                      <TableRow key={user.id}>
                        <TableCell className="font-medium">{user.email}</TableCell>
                        <TableCell>
                          {user.firstName} {user.lastName}
                        </TableCell>
                        <TableCell>
                          {user.isActive ? (
                            <Badge>Active</Badge>
                          ) : (
                            <Badge variant="destructive">Deactivated</Badge>
                          )}
                        </TableCell>
                        <TableCell>{new Date(user.createdAt).toLocaleDateString()}</TableCell>
                        <TableCell className="text-right space-x-2">
                          <Button size="sm" variant="outline" onClick={() => openPasswordDialog(user)}>
                            Reset Password
                          </Button>
                          <Button
                            size="sm"
                            variant={user.isActive ? "destructive" : "secondary"}
                            onClick={() => setActiveTarget(user)}
                          >
                            {user.isActive ? "Deactivate" : "Activate"}
                          </Button>
                        </TableCell>
                      </TableRow>
                    ))}
                </TableBody>
              </Table>
            </div>

            <div className="flex items-center justify-between">
              <span className="text-sm text-muted-foreground">
                Page {page} of {totalPages}
              </span>
              <div className="flex gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  disabled={page <= 1 || loading}
                  onClick={() => setPage((p) => Math.max(1, p - 1))}
                >
                  Previous
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  disabled={page >= totalPages || loading}
                  onClick={() => setPage((p) => p + 1)}
                >
                  Next
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      <Dialog open={passwordTarget !== null} onOpenChange={(open) => !open && setPasswordTarget(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>Reset password</DialogTitle>
            <DialogDescription>
              Set a new password for {passwordTarget?.email}. The user will be signed out of all sessions.
            </DialogDescription>
          </DialogHeader>
          <form onSubmit={submitPassword} className="space-y-4">
            {passwordError && (
              <Alert variant="destructive">
                <AlertDescription>{passwordError}</AlertDescription>
              </Alert>
            )}
            <div className="space-y-1.5">
              <Label htmlFor="new-password">New password</Label>
              <Input
                id="new-password"
                type="password"
                value={newPassword}
                onChange={(e) => setNewPassword(e.target.value)}
                required
                minLength={8}
              />
              <p className="text-xs text-muted-foreground">
                At least 8 characters, with upper, lower, and a digit.
              </p>
            </div>
            <div className="space-y-1.5">
              <Label htmlFor="confirm-password">Confirm password</Label>
              <Input
                id="confirm-password"
                type="password"
                value={confirmPassword}
                onChange={(e) => setConfirmPassword(e.target.value)}
                required
                minLength={8}
              />
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setPasswordTarget(null)}>
                Cancel
              </Button>
              <Button type="submit" disabled={passwordSaving}>
                {passwordSaving ? "Saving..." : "Set password"}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      <Dialog open={activeTarget !== null} onOpenChange={(open) => !open && setActiveTarget(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {activeTarget?.isActive ? "Deactivate user" : "Activate user"}
            </DialogTitle>
            <DialogDescription>
              {activeTarget?.isActive
                ? `${activeTarget?.email} will be unable to sign in and all of their sessions will be revoked.`
                : `${activeTarget?.email} will be able to sign in again.`}
            </DialogDescription>
          </DialogHeader>
          <DialogFooter>
            <Button variant="outline" onClick={() => setActiveTarget(null)}>
              Cancel
            </Button>
            <Button
              variant={activeTarget?.isActive ? "destructive" : "default"}
              onClick={confirmToggleActive}
              disabled={activeSaving}
            >
              {activeSaving
                ? "Saving..."
                : activeTarget?.isActive
                ? "Deactivate"
                : "Activate"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
