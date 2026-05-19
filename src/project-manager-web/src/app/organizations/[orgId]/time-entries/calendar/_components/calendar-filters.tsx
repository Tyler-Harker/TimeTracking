"use client";

import { useEffect, useState } from "react";
import { Label } from "@/components/ui/label";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import { Button } from "@/components/ui/button";
import { projectRepository } from "@/features/projects/repository/project-repository";
import { clientRepository } from "@/features/clients/repository/client-repository";
import { taskRepository } from "@/features/tasks/repository/task-repository";
import { userRepository } from "@/features/user/repository/user-repository";
import type { Project } from "@/features/projects/models/types";
import type { Client } from "@/features/clients/models/types";
import type { TaskItem } from "@/features/tasks/models/types";
import type { OrganizationUser } from "@/features/user/models/types";

export const ALL_VALUE = "__all__";

export interface CalendarFilterValues {
  projectId?: string;
  clientId?: string;
  userId?: string;
  taskId?: string;
}

interface CalendarFiltersProps {
  values: CalendarFilterValues;
  onChange: (next: CalendarFilterValues) => void;
}

export function CalendarFilters({ values, onChange }: CalendarFiltersProps) {
  const [projects, setProjects] = useState<Project[]>([]);
  const [clients, setClients] = useState<Client[]>([]);
  const [users, setUsers] = useState<OrganizationUser[]>([]);
  const [tasks, setTasks] = useState<TaskItem[]>([]);
  const [loadingTasks, setLoadingTasks] = useState(false);

  useEffect(() => {
    projectRepository.list().then(setProjects).catch(() => setProjects([]));
    clientRepository.list().then(setClients).catch(() => setClients([]));
    userRepository.listOrganizationUsers().then(setUsers).catch(() => setUsers([]));
  }, []);

  useEffect(() => {
    if (!values.projectId) {
      setTasks([]);
      return;
    }
    setLoadingTasks(true);
    taskRepository.list(values.projectId)
      .then(setTasks)
      .catch(() => setTasks([]))
      .finally(() => setLoadingTasks(false));
  }, [values.projectId]);

  function set<K extends keyof CalendarFilterValues>(key: K, value: string) {
    const next: CalendarFilterValues = { ...values };
    if (value === ALL_VALUE || value === "") {
      delete next[key];
    } else {
      next[key] = value;
    }
    if (key === "projectId" && next.projectId !== values.projectId) {
      delete next.taskId;
    }
    onChange(next);
  }

  function clearAll() {
    onChange({});
  }

  const hasAny = Boolean(values.projectId || values.clientId || values.userId || values.taskId);

  return (
    <div className="flex flex-wrap items-end gap-3 rounded-lg border border-border bg-card p-3">
      <FilterField label="Project">
        <Select value={values.projectId ?? ALL_VALUE} onValueChange={(v) => set("projectId", v ?? ALL_VALUE)}>
          <SelectTrigger className="w-48">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value={ALL_VALUE}>All projects</SelectItem>
            {projects.map((p) => (
              <SelectItem key={p.id} value={p.id}>{p.name}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </FilterField>

      <FilterField label="Client">
        <Select value={values.clientId ?? ALL_VALUE} onValueChange={(v) => set("clientId", v ?? ALL_VALUE)}>
          <SelectTrigger className="w-48">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value={ALL_VALUE}>All clients</SelectItem>
            {clients.map((c) => (
              <SelectItem key={c.id} value={c.id}>{c.name}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </FilterField>

      <FilterField label="User">
        <Select value={values.userId ?? ALL_VALUE} onValueChange={(v) => set("userId", v ?? ALL_VALUE)}>
          <SelectTrigger className="w-48">
            <SelectValue />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value={ALL_VALUE}>All users</SelectItem>
            {users.map((u) => (
              <SelectItem key={u.id} value={u.id}>{u.name}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </FilterField>

      <FilterField label="Task">
        <Select
          value={values.taskId ?? ALL_VALUE}
          onValueChange={(v) => set("taskId", v ?? ALL_VALUE)}
          disabled={!values.projectId || loadingTasks}
        >
          <SelectTrigger className="w-48">
            <SelectValue placeholder={values.projectId ? (loadingTasks ? "Loading..." : "All tasks") : "Select project first"} />
          </SelectTrigger>
          <SelectContent>
            <SelectItem value={ALL_VALUE}>All tasks</SelectItem>
            {tasks.map((t) => (
              <SelectItem key={t.id} value={t.id}>{t.name}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </FilterField>

      {hasAny && (
        <Button variant="ghost" size="sm" onClick={clearAll}>
          Clear filters
        </Button>
      )}
    </div>
  );
}

function FilterField({ label, children }: { label: string; children: React.ReactNode }) {
  return (
    <div className="flex flex-col gap-1">
      <Label className="text-xs text-muted-foreground">{label}</Label>
      {children}
    </div>
  );
}
