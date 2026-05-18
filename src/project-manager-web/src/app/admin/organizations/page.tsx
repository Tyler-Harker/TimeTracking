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
  type AdminOrganization,
  type AdminOrganizationMember,
  type AdminUser,
} from "@/features/admin/repository/admin-repository";
import { adminTokenStorage } from "@/features/admin/storage/admin-token-storage";

const PAGE_SIZE = 50;

export default function AdminOrganizationsPage() {
  const router = useRouter();
  const [search, setSearch] = useState("");
  const [appliedSearch, setAppliedSearch] = useState("");
  const [page, setPage] = useState(1);
  const [orgs, setOrgs] = useState<AdminOrganization[]>([]);
  const [total, setTotal] = useState(0);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [info, setInfo] = useState<string | null>(null);

  const [membersTarget, setMembersTarget] = useState<AdminOrganization | null>(null);
  const [members, setMembers] = useState<AdminOrganizationMember[]>([]);
  const [membersLoading, setMembersLoading] = useState(false);

  const [ownerTarget, setOwnerTarget] = useState<AdminOrganization | null>(null);
  const [userSearch, setUserSearch] = useState("");
  const [userResults, setUserResults] = useState<AdminUser[]>([]);
  const [userSearchLoading, setUserSearchLoading] = useState(false);
  const [selectedUser, setSelectedUser] = useState<AdminUser | null>(null);
  const [ownerSaving, setOwnerSaving] = useState(false);
  const [ownerError, setOwnerError] = useState<string | null>(null);

  const [activeTarget, setActiveTarget] = useState<AdminOrganization | null>(null);
  const [activeSaving, setActiveSaving] = useState(false);

  const loadOrgs = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const response = await adminRepository.listOrganizations({
        search: appliedSearch || undefined,
        page,
        pageSize: PAGE_SIZE,
      });
      setOrgs(response.items);
      setTotal(response.total);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load organizations");
    } finally {
      setLoading(false);
    }
  }, [appliedSearch, page]);

  useEffect(() => {
    if (!adminTokenStorage.hasValid()) {
      router.replace("/admin");
      return;
    }
    loadOrgs();
  }, [loadOrgs, router]);

  function handleSearch(e: FormEvent) {
    e.preventDefault();
    setPage(1);
    setAppliedSearch(search.trim());
  }

  function handleSignOut() {
    adminTokenStorage.clear();
    router.replace("/admin");
  }

  async function openMembers(org: AdminOrganization) {
    setMembersTarget(org);
    setMembers([]);
    setMembersLoading(true);
    try {
      const response = await adminRepository.listOrganizationMembers(org.id);
      setMembers(response.members);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load members");
      setMembersTarget(null);
    } finally {
      setMembersLoading(false);
    }
  }

  function openOwner(org: AdminOrganization) {
    setOwnerTarget(org);
    setUserSearch("");
    setUserResults([]);
    setSelectedUser(null);
    setOwnerError(null);
  }

  async function runUserSearch(e: FormEvent) {
    e.preventDefault();
    const term = userSearch.trim();
    if (!term) {
      setUserResults([]);
      return;
    }
    setUserSearchLoading(true);
    try {
      const response = await adminRepository.listUsers({ search: term, page: 1, pageSize: 20 });
      setUserResults(response.items);
    } catch (e) {
      setOwnerError(e instanceof Error ? e.message : "User search failed");
    } finally {
      setUserSearchLoading(false);
    }
  }

  async function confirmSetOwner() {
    if (!ownerTarget || !selectedUser) return;
    setOwnerSaving(true);
    setOwnerError(null);
    try {
      await adminRepository.setOrganizationOwner(ownerTarget.id, selectedUser.id);
      setInfo(`${selectedUser.email} is now the Owner of ${ownerTarget.name}`);
      setOwnerTarget(null);
      await loadOrgs();
    } catch (e) {
      setOwnerError(e instanceof Error ? e.message : "Failed to set owner");
    } finally {
      setOwnerSaving(false);
    }
  }

  async function confirmToggleActive() {
    if (!activeTarget) return;
    setActiveSaving(true);
    try {
      const next = !activeTarget.isActive;
      const updated = await adminRepository.setOrganizationActive(activeTarget.id, next);
      setOrgs((prev) =>
        prev.map((o) => (o.id === updated.organizationId ? { ...o, isActive: updated.isActive } : o))
      );
      setInfo(`${updated.name} ${updated.isActive ? "activated" : "deactivated"}`);
      setActiveTarget(null);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to update organization");
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
            <h1 className="text-2xl font-bold">Organization Administration</h1>
            <p className="text-sm text-muted-foreground">
              View every organization, transfer ownership, and toggle activation status.
            </p>
          </div>
          <div className="flex gap-2">
            <Link href="/admin/users" className="text-sm text-muted-foreground underline-offset-4 hover:underline self-center">
              Users
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
            <CardTitle>Organizations ({total})</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            <form onSubmit={handleSearch} className="flex gap-2">
              <Input
                placeholder="Search by name or slug"
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
                    <TableHead>Name</TableHead>
                    <TableHead>Owner(s)</TableHead>
                    <TableHead>Members</TableHead>
                    <TableHead>Status</TableHead>
                    <TableHead>Created</TableHead>
                    <TableHead className="text-right">Actions</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {loading && (
                    <TableRow>
                      <TableCell colSpan={6} className="text-center text-muted-foreground">
                        Loading...
                      </TableCell>
                    </TableRow>
                  )}
                  {!loading && orgs.length === 0 && (
                    <TableRow>
                      <TableCell colSpan={6} className="text-center text-muted-foreground">
                        No organizations found
                      </TableCell>
                    </TableRow>
                  )}
                  {!loading &&
                    orgs.map((org) => (
                      <TableRow key={org.id}>
                        <TableCell>
                          <div className="font-medium">{org.name}</div>
                          <div className="text-xs text-muted-foreground">{org.slug}</div>
                        </TableCell>
                        <TableCell>
                          {org.owners.length === 0 ? (
                            <span className="text-muted-foreground italic">none</span>
                          ) : (
                            <div className="space-y-1">
                              {org.owners.map((o) => (
                                <div key={o.userId} className="text-sm">
                                  {o.email}
                                </div>
                              ))}
                            </div>
                          )}
                        </TableCell>
                        <TableCell>{org.memberCount}</TableCell>
                        <TableCell>
                          {org.isActive ? (
                            <Badge>Active</Badge>
                          ) : (
                            <Badge variant="destructive">Deactivated</Badge>
                          )}
                        </TableCell>
                        <TableCell>{new Date(org.createdAt).toLocaleDateString()}</TableCell>
                        <TableCell className="text-right space-x-2">
                          <Button size="sm" variant="outline" onClick={() => openMembers(org)}>
                            Members
                          </Button>
                          <Button size="sm" variant="outline" onClick={() => openOwner(org)}>
                            Change Owner
                          </Button>
                          <Button
                            size="sm"
                            variant={org.isActive ? "destructive" : "secondary"}
                            onClick={() => setActiveTarget(org)}
                          >
                            {org.isActive ? "Deactivate" : "Activate"}
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

      <Dialog open={membersTarget !== null} onOpenChange={(open) => !open && setMembersTarget(null)}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle>Members of {membersTarget?.name}</DialogTitle>
            <DialogDescription>Read-only view of every user that belongs to this organization.</DialogDescription>
          </DialogHeader>
          {membersLoading ? (
            <p className="text-sm text-muted-foreground">Loading...</p>
          ) : members.length === 0 ? (
            <p className="text-sm text-muted-foreground">No members.</p>
          ) : (
            <div className="overflow-x-auto">
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Email</TableHead>
                    <TableHead>Name</TableHead>
                    <TableHead>Role</TableHead>
                    <TableHead>Joined</TableHead>
                    <TableHead>User</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {members.map((m) => (
                    <TableRow key={m.userId}>
                      <TableCell className="font-medium">{m.email}</TableCell>
                      <TableCell>
                        {m.firstName} {m.lastName}
                      </TableCell>
                      <TableCell>
                        <Badge variant={m.role === "Owner" ? "default" : "secondary"}>{m.role}</Badge>
                      </TableCell>
                      <TableCell>{new Date(m.joinedAt).toLocaleDateString()}</TableCell>
                      <TableCell>
                        {m.isActive ? <Badge variant="secondary">Active</Badge> : <Badge variant="destructive">Disabled</Badge>}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            </div>
          )}
          <DialogFooter>
            <Button variant="outline" onClick={() => setMembersTarget(null)}>
              Close
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={ownerTarget !== null} onOpenChange={(open) => !open && setOwnerTarget(null)}>
        <DialogContent className="max-w-xl">
          <DialogHeader>
            <DialogTitle>Change owner of {ownerTarget?.name}</DialogTitle>
            <DialogDescription>
              The chosen user becomes the sole Owner. Any existing Owner(s) are demoted to Admin and remain in the organization.
            </DialogDescription>
          </DialogHeader>

          {ownerError && (
            <Alert variant="destructive">
              <AlertDescription>{ownerError}</AlertDescription>
            </Alert>
          )}

          <form onSubmit={runUserSearch} className="flex gap-2">
            <Input
              placeholder="Search users by email or name"
              value={userSearch}
              onChange={(e) => setUserSearch(e.target.value)}
            />
            <Button type="submit" variant="secondary" disabled={userSearchLoading}>
              {userSearchLoading ? "Searching..." : "Search"}
            </Button>
          </form>

          {userResults.length > 0 && (
            <div className="max-h-72 overflow-y-auto border rounded-md">
              {userResults.map((u) => (
                <button
                  key={u.id}
                  type="button"
                  onClick={() => setSelectedUser(u)}
                  className={`block w-full text-left px-3 py-2 text-sm hover:bg-accent ${
                    selectedUser?.id === u.id ? "bg-accent" : ""
                  }`}
                >
                  <div className="font-medium">{u.email}</div>
                  <div className="text-xs text-muted-foreground">
                    {u.firstName} {u.lastName}
                    {!u.isActive && " · deactivated"}
                  </div>
                </button>
              ))}
            </div>
          )}

          {selectedUser && (
            <div className="rounded-md border p-3 text-sm">
              <Label className="text-xs text-muted-foreground">Selected</Label>
              <div className="font-medium">{selectedUser.email}</div>
            </div>
          )}

          <DialogFooter>
            <Button type="button" variant="outline" onClick={() => setOwnerTarget(null)}>
              Cancel
            </Button>
            <Button
              type="button"
              onClick={confirmSetOwner}
              disabled={!selectedUser || ownerSaving || (selectedUser && !selectedUser.isActive)}
            >
              {ownerSaving ? "Saving..." : "Make Owner"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={activeTarget !== null} onOpenChange={(open) => !open && setActiveTarget(null)}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{activeTarget?.isActive ? "Deactivate organization" : "Activate organization"}</DialogTitle>
            <DialogDescription>
              {activeTarget?.isActive
                ? `${activeTarget?.name} will be hidden from regular users' org lists. Existing data is preserved and can be restored by reactivating.`
                : `${activeTarget?.name} will become visible again to its members.`}
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
              {activeSaving ? "Saving..." : activeTarget?.isActive ? "Deactivate" : "Activate"}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
}
