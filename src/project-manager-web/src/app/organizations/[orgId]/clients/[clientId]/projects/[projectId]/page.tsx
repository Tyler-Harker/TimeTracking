"use client";
import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import Link from "next/link";
import { projectRepository } from "@/features/projects/repository/project-repository";
import { taskRepository } from "@/features/tasks/repository/task-repository";
import type { ProjectDetail } from "@/features/projects/models/types";
import type { TaskItem } from "@/features/tasks/models/types";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { StatusBadge } from "@/core/components/status-badge";
import { ConfirmDialog } from "@/core/components/confirm-dialog";
import { Card, CardContent } from "@/components/ui/card";
import { Button, buttonVariants } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { cn } from "@/lib/utils";

function timeAgo(dateStr: string): string {
  const now = Date.now();
  const then = new Date(dateStr).getTime();
  const seconds = Math.floor((now - then) / 1000);
  if (seconds < 60) return "just now";
  const minutes = Math.floor(seconds / 60);
  if (minutes < 60) return `${minutes}m ago`;
  const hours = Math.floor(minutes / 60);
  if (hours < 24) return `${hours}h ago`;
  const days = Math.floor(hours / 24);
  if (days < 30) return `${days}d ago`;
  return new Date(dateStr).toLocaleDateString();
}

export default function ProjectDetailPage() {
  const params = useParams<{ orgId: string; clientId: string; projectId: string }>();
  const { orgId, clientId, projectId } = params;
  const basePath = `/organizations/${orgId}/clients/${clientId}/projects/${projectId}`;
  const router = useRouter();
  const [project, setProject] = useState<ProjectDetail | null>(null);
  const [tasks, setTasks] = useState<TaskItem[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [showDelete, setShowDelete] = useState(false);
  const [taskPage, setTaskPage] = useState(1);
  const tasksPerPage = 5;

  async function load() {
    setLoading(true);
    try {
      const [p, t] = await Promise.all([
        projectRepository.get(projectId),
        taskRepository.list(projectId),
      ]);
      setProject(p);
      setTasks(t);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load project");
    } finally {
      setLoading(false);
    }
  }

  const totalTaskPages = Math.max(1, Math.ceil(tasks.length / tasksPerPage));
  const paginatedTasks = tasks.slice(
    (taskPage - 1) * tasksPerPage,
    taskPage * tasksPerPage
  );

  useEffect(() => { load(); }, [projectId]);

  async function handleDelete() {
    try {
      await projectRepository.delete(projectId);
      router.push(`/organizations/${orgId}/clients/${clientId}`);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to delete");
    }
  }

  if (loading) return <LoadingSpinner />;
  if (error && !project) return <ErrorDisplay message={error} onRetry={load} />;
  if (!project) return null;

  return (
    <div className="p-6 max-w-4xl">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-foreground">{project.name}</h1>
          <p className="text-sm text-muted-foreground">{project.clientName}</p>
        </div>
        <div className="flex items-center gap-2">
          <StatusBadge status={project.status} />
          <Link href={`${basePath}/edit`} className={cn(buttonVariants({ variant: "outline" }))}>Edit</Link>
          <Button variant="destructive" onClick={() => setShowDelete(true)}>Delete</Button>
        </div>
      </div>

      <Card className="mb-6">
        <CardContent>
          {project.budgetAmount && <p className="text-sm text-muted-foreground mb-1"><span className="text-foreground">Budget:</span> ${project.budgetAmount.toLocaleString()}</p>}
          {project.defaultBillableRate && <p className="text-sm text-muted-foreground mb-1"><span className="text-foreground">Rate:</span> ${project.defaultBillableRate}/hr</p>}
          {project.startDate && <p className="text-sm text-muted-foreground mb-1"><span className="text-foreground">Start:</span> {project.startDate}</p>}
          {project.endDate && <p className="text-sm text-muted-foreground"><span className="text-foreground">End:</span> {project.endDate}</p>}
        </CardContent>
      </Card>

      <div className="flex gap-3 mb-6">
        <Link href={`${basePath}/teams`} className={cn(buttonVariants({ variant: "outline" }))}>Teams</Link>
        <Link href={`${basePath}/time-entries/new`} className={cn(buttonVariants({ variant: "outline" }))}>Log Time</Link>
      </div>

      <Separator className="my-6" />

      <div className="flex items-center justify-between mb-4">
        <h2 className="text-lg font-semibold text-foreground">Tasks</h2>
        <Link href={`${basePath}/tasks/new`} className={cn(buttonVariants())}>New Task</Link>
      </div>
      {tasks.length === 0 ? (
        <p className="text-sm text-muted-foreground">No tasks yet.</p>
      ) : (
        <div>
          <div className="grid gap-3">
            {paginatedTasks.map((task) => (
              <Link key={task.id} href={`${basePath}/tasks/${task.id}`} className="block">
                <Card className="hover:ring-2 hover:ring-primary/50 transition-all">
                  <CardContent>
                    <div className="flex items-center justify-between">
                      <div>
                        <p className="font-medium text-foreground">{task.name}</p>
                        <div className="flex items-center gap-2 mt-1 flex-wrap">
                          {task.assigneeName && <span className="text-sm text-muted-foreground">{task.assigneeName}</span>}
                          {task.dueDate && <span className="text-sm text-muted-foreground">Due {task.dueDate}</span>}
                          {task.estimatedHours != null && <span className="text-sm text-muted-foreground">{task.estimatedHours}h est.</span>}
                          <span className="text-xs text-muted-foreground/70">Updated {timeAgo(task.lastActivity)}</span>
                        </div>
                      </div>
                      <div className="flex items-center gap-2">
                        <StatusBadge status={task.priority} />
                        <StatusBadge status={task.status} />
                      </div>
                    </div>
                  </CardContent>
                </Card>
              </Link>
            ))}
          </div>
          {totalTaskPages > 1 && (
            <div className="flex items-center justify-between mt-4">
              <p className="text-sm text-muted-foreground">
                Page {taskPage} of {totalTaskPages} ({tasks.length} tasks)
              </p>
              <div className="flex gap-2">
                <Button
                  variant="outline"
                  size="sm"
                  disabled={taskPage <= 1}
                  onClick={() => setTaskPage((p) => p - 1)}
                >
                  Previous
                </Button>
                <Button
                  variant="outline"
                  size="sm"
                  disabled={taskPage >= totalTaskPages}
                  onClick={() => setTaskPage((p) => p + 1)}
                >
                  Next
                </Button>
              </div>
            </div>
          )}
        </div>
      )}

      <ConfirmDialog open={showDelete} title="Delete Project" message="Are you sure? This cannot be undone." onConfirm={handleDelete} onCancel={() => setShowDelete(false)} />
    </div>
  );
}
