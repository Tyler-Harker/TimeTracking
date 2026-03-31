"use client";
import { useEffect, useState } from "react";
import { useParams, useRouter } from "next/navigation";
import Link from "next/link";
import { taskRepository } from "@/features/tasks/repository/task-repository";
import { timeEntryRepository } from "@/features/time-entries/repository/time-entry-repository";
import type { TaskDetail } from "@/features/tasks/models/types";
import type { TimeEntry } from "@/features/time-entries/models/types";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { StatusBadge } from "@/core/components/status-badge";
import { ConfirmDialog } from "@/core/components/confirm-dialog";
import { Card, CardContent } from "@/components/ui/card";
import { Button, buttonVariants } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import { Separator } from "@/components/ui/separator";
import { cn } from "@/lib/utils";

export default function TaskDetailPage() {
  const params = useParams<{ orgId: string; clientId: string; projectId: string; taskId: string }>();
  const { orgId, clientId, projectId, taskId } = params;
  const basePath = `/organizations/${orgId}/clients/${clientId}/projects/${projectId}/tasks/${taskId}`;
  const router = useRouter();
  const [task, setTask] = useState<TaskDetail | null>(null);
  const [timeEntries, setTimeEntries] = useState<TimeEntry[]>([]);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [showDelete, setShowDelete] = useState(false);

  async function load() {
    setLoading(true);
    try {
      const [t, entries] = await Promise.all([
        taskRepository.get(taskId),
        timeEntryRepository.list({ taskId }),
      ]);
      setTask(t);
      setTimeEntries(entries);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load task");
    } finally {
      setLoading(false);
    }
  }

  const totalHours = timeEntries.reduce((sum, e) => sum + e.hours, 0);

  useEffect(() => { load(); }, [taskId]);

  async function handleDelete() {
    try {
      await taskRepository.delete(taskId);
      router.push(`/organizations/${orgId}/clients/${clientId}/projects/${projectId}`);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to delete task");
      setShowDelete(false);
    }
  }

  if (loading) return <LoadingSpinner />;
  if (error && !task) return <ErrorDisplay message={error} onRetry={load} />;
  if (!task) return null;

  return (
    <div className="p-6 max-w-4xl">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold text-foreground">{task.name}</h1>
          <p className="text-sm text-muted-foreground">{task.projectName}</p>
        </div>
        <div className="flex items-center gap-2">
          <StatusBadge status={task.status} />
          <StatusBadge status={task.priority} />
          <Link href={`${basePath}/edit`} className={cn(buttonVariants({ variant: "outline" }))}>Edit</Link>
          <Button variant="destructive" onClick={() => setShowDelete(true)}>Delete</Button>
        </div>
      </div>

      <Card className="mb-6">
        <CardContent>
          {task.assigneeName && <p className="text-sm text-muted-foreground mb-1"><span className="text-foreground">Assignee:</span> {task.assigneeName}</p>}
          {task.dueDate && <p className="text-sm text-muted-foreground mb-1"><span className="text-foreground">Due:</span> {task.dueDate}</p>}
          {task.estimatedHours && <p className="text-sm text-muted-foreground mb-1"><span className="text-foreground">Estimated:</span> {task.estimatedHours}h</p>}
          {task.description && <p className="text-sm text-muted-foreground mt-2">{task.description}</p>}
        </CardContent>
      </Card>

      <Separator className="my-6" />

      <div className="flex items-center justify-between mb-4">
        <div>
          <h2 className="text-lg font-semibold text-foreground">Time Logged</h2>
          {timeEntries.length > 0 && (
            <p className="text-sm text-muted-foreground">{totalHours.toFixed(1)} hours total</p>
          )}
        </div>
        <Link href={`${basePath}/log-time`} className={cn(buttonVariants())}>
          Log Time
        </Link>
      </div>
      {timeEntries.length === 0 ? (
        <p className="text-sm text-muted-foreground">No time logged yet.</p>
      ) : (
        <div className="grid gap-3">
          {timeEntries.map((entry) => (
            <Card key={entry.id}>
              <CardContent>
                <div className="flex items-center justify-between">
                  <div>
                    <p className="font-medium text-foreground">{entry.hours}h</p>
                    <p className="text-sm text-muted-foreground">{entry.description || "No description"}</p>
                    <p className="text-xs text-muted-foreground/70 mt-0.5">{entry.userName}</p>
                  </div>
                  <div className="text-right">
                    <p className="text-sm text-muted-foreground">{entry.date}</p>
                    <div className="flex gap-1.5 mt-1 justify-end">
                      {entry.isBillable && <Badge variant="secondary" className="text-xs">Billable</Badge>}
                      {entry.isInvoiced && <Badge className="text-xs">Invoiced</Badge>}
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      <ConfirmDialog open={showDelete} title="Delete Task" message="Are you sure?" onConfirm={handleDelete} onCancel={() => setShowDelete(false)} />
    </div>
  );
}
