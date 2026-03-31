"use client";
import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import Link from "next/link";
import { clientRepository } from "@/features/clients/repository/client-repository";
import { projectRepository } from "@/features/projects/repository/project-repository";
import type { ClientDetail, ClientContact } from "@/features/clients/models/types";
import type { Project } from "@/features/projects/models/types";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { ConfirmDialog } from "@/core/components/confirm-dialog";
import { StatusBadge } from "@/core/components/status-badge";
import { Card, CardContent } from "@/components/ui/card";
import { Button, buttonVariants } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { cn } from "@/lib/utils";
import { Separator } from "@/components/ui/separator";

export default function ClientDetailPage() {
  const params = useParams<{ orgId: string; clientId: string }>();
  const orgId = params.orgId;
  const clientId = params.clientId;
  const router = useRouter();
  const [client, setClient] = useState<ClientDetail | null>(null);
  const [contacts, setContacts] = useState<ClientContact[]>([]);
  const [projects, setProjects] = useState<Project[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [showDelete, setShowDelete] = useState(false);
  const [projectPage, setProjectPage] = useState(1);
  const projectsPerPage = 5;

  async function load() {
    setLoading(true);
    try {
      const [c, ct, p] = await Promise.all([
        clientRepository.get(clientId),
        clientRepository.listContacts(clientId),
        projectRepository.list(clientId),
      ]);
      setClient(c);
      setContacts(ct);
      setProjects(p);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load client");
    } finally {
      setLoading(false);
    }
  }

  const totalProjectPages = Math.max(1, Math.ceil(projects.length / projectsPerPage));
  const paginatedProjects = projects.slice(
    (projectPage - 1) * projectsPerPage,
    projectPage * projectsPerPage
  );

  useEffect(() => { load(); }, [clientId]);

  async function handleDelete() {
    try {
      await clientRepository.delete(clientId);
      router.push(`/organizations/${orgId}/clients`);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to delete client");
    }
  }

  if (loading) return <LoadingSpinner />;
  if (error && !client) return <ErrorDisplay message={error} onRetry={load} />;
  if (!client) return null;

  return (
    <div className="p-6 max-w-4xl">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-foreground">{client.name}</h1>
          <Badge variant={client.isActive ? "default" : "secondary"} className="mt-1">
            {client.isActive ? "Active" : "Inactive"}
          </Badge>
        </div>
        <div className="flex gap-2">
          <Link href={`/organizations/${orgId}/clients/${clientId}/edit`} className={cn(buttonVariants({ variant: "outline" }))}>Edit</Link>
          <Button variant="destructive" onClick={() => setShowDelete(true)}>Delete</Button>
        </div>
      </div>

      <div className="grid gap-4 mb-8">
        <Card>
          <CardContent>
            {client.address && <p className="text-sm text-muted-foreground mb-1"><span className="text-foreground">Address:</span> {client.address}</p>}
            {client.website && <p className="text-sm text-muted-foreground mb-1"><span className="text-foreground">Website:</span> {client.website}</p>}
            {client.defaultBillableRate && <p className="text-sm text-muted-foreground"><span className="text-foreground">Rate:</span> ${client.defaultBillableRate}/hr</p>}
          </CardContent>
        </Card>
      </div>

      <div className="flex items-center justify-between mb-4">
        <h2 className="text-lg font-semibold text-foreground">Projects</h2>
        <Link href={`/organizations/${orgId}/clients/${clientId}/projects/new`} className={cn(buttonVariants())}>New Project</Link>
      </div>
      {projects.length === 0 ? (
        <p className="text-sm text-muted-foreground mb-8">No projects yet.</p>
      ) : (
        <div className="mb-8">
          <div className="grid gap-3">
            {paginatedProjects.map((project) => (
              <Link key={project.id} href={`/organizations/${orgId}/clients/${clientId}/projects/${project.id}`} className="block">
                <Card className="hover:ring-2 hover:ring-primary/50 transition-all">
                  <CardContent>
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium text-foreground">{project.name}</p>
                        {project.budgetAmount != null && (
                          <p className="text-sm text-muted-foreground">${project.budgetAmount.toLocaleString()} budget</p>
                        )}
                      </div>
                      <StatusBadge status={project.status} />
                    </div>
                  </CardContent>
                </Card>
              </Link>
            ))}
          </div>
          {totalProjectPages > 1 && (
            <div className="flex items-center justify-between mt-4">
              <p className="text-sm text-muted-foreground">
                Page {projectPage} of {totalProjectPages} ({projects.length} projects)
              </p>
              <div className="flex gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  disabled={projectPage <= 1}
                  onClick={() => setProjectPage((p) => p - 1)}
                >
                  Previous
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  disabled={projectPage >= totalProjectPages}
                  onClick={() => setProjectPage((p) => p + 1)}
                >
                  Next
                </Button>
              </div>
            </div>
          )}
        </div>
      )}

      <Separator className="my-6" />

      <div className="flex items-center justify-between mb-4">
        <h2 className="text-lg font-semibold text-foreground">Contacts</h2>
        <Link href={`/organizations/${orgId}/clients/${clientId}/contacts/new`} className={cn(buttonVariants())}>Add Contact</Link>
      </div>
      {contacts.length === 0 ? (
        <p className="text-sm text-muted-foreground">No contacts yet.</p>
      ) : (
        <div className="grid gap-3">
          {contacts.map((contact) => (
            <Card key={contact.id}>
              <CardContent>
                <div className="flex items-center justify-between">
                  <div>
                    <p className="font-medium text-foreground">{contact.name}</p>
                    {contact.email && <p className="text-sm text-muted-foreground">{contact.email}</p>}
                    {contact.phone && <p className="text-sm text-muted-foreground">{contact.phone}</p>}
                    {(contact.isStakeHolder || contact.isInvoicing) && (
                      <div className="flex gap-1.5 mt-2">
                        {contact.isStakeHolder && <Badge variant="secondary">Stakeholder</Badge>}
                        {contact.isInvoicing && <Badge>Invoicing</Badge>}
                      </div>
                    )}
                  </div>
                  <Link href={`/organizations/${orgId}/clients/${clientId}/contacts/${contact.id}/edit`} className={cn(buttonVariants({ variant: "link" }))}>Edit</Link>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      <ConfirmDialog open={showDelete} title="Delete Client" message="Are you sure? This cannot be undone." onConfirm={handleDelete} onCancel={() => setShowDelete(false)} />
    </div>
  );
}
