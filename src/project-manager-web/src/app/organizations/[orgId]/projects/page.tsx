"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { useParams } from "next/navigation";
import { projectRepository } from "@/features/projects/repository/project-repository";
import type { Project } from "@/features/projects/models/types";
import { PageHeader } from "@/core/components/page-header";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { EmptyState } from "@/core/components/empty-state";
import { StatusBadge } from "@/core/components/status-badge";
import { Card, CardContent } from "@/components/ui/card";

export default function ProjectListPage() {
  const params = useParams<{ orgId: string }>();
  const orgId = params.orgId;
  const [projects, setProjects] = useState<Project[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);

  async function load() {
    setLoading(true);
    try {
      setProjects(await projectRepository.list());
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load projects");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { load(); }, []);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorDisplay message={error} onRetry={load} />;

  return (
    <div className="p-6">
      <PageHeader title="Projects" action={{ label: "New Project", href: `/organizations/${orgId}/clients` }} />
      {projects.length === 0 ? (
        <EmptyState message="No projects yet." />
      ) : (
        <div className="grid gap-4">
          {projects.map((project) => (
            <Link key={project.id} href={`/organizations/${orgId}/clients/${project.clientId}/projects/${project.id}`} className="block transition-colors">
              <Card className="hover:ring-primary/50 transition-all">
                <CardContent>
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium text-foreground">{project.name}</p>
                      <p className="text-sm text-muted-foreground">{project.clientName}</p>
                    </div>
                    <div className="flex items-center gap-3">
                      {project.budgetAmount && <span className="text-sm text-muted-foreground">${project.budgetAmount.toLocaleString()}</span>}
                      <StatusBadge status={project.status} />
                    </div>
                  </div>
                </CardContent>
              </Card>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
