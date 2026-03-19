"use client";

import { useEffect, useState } from "react";
import Link from "next/link";
import { projectRepository } from "@/features/projects/repository/project-repository";
import type { Project } from "@/features/projects/models/types";
import { PageHeader } from "@/core/components/page-header";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { EmptyState } from "@/core/components/empty-state";
import { StatusBadge } from "@/core/components/status-badge";

export default function ProjectListPage() {
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
      <PageHeader title="Projects" action={{ label: "New Project", href: "/projects/new" }} />
      {projects.length === 0 ? (
        <EmptyState message="No projects yet." />
      ) : (
        <div className="grid gap-4">
          {projects.map((project) => (
            <Link key={project.id} href={`/projects/${project.id}`} className="rounded-xl border border-slate-700 bg-slate-800 p-4 hover:border-indigo-500/50 transition-colors block">
              <div className="flex items-center justify-between">
                <div>
                  <p className="font-medium text-slate-50">{project.name}</p>
                  <p className="text-sm text-slate-400">{project.clientName}</p>
                </div>
                <div className="flex items-center gap-3">
                  {project.budgetAmount && <span className="text-sm text-slate-400">${project.budgetAmount.toLocaleString()}</span>}
                  <StatusBadge status={project.status} />
                </div>
              </div>
            </Link>
          ))}
        </div>
      )}
    </div>
  );
}
