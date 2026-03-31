"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";
import { clientRepository } from "@/features/clients/repository/client-repository";
import { projectRepository } from "@/features/projects/repository/project-repository";
import { taskRepository } from "@/features/tasks/repository/task-repository";
import { cn } from "@/lib/utils";

interface Crumb {
  label: string;
  href: string;
}

// Resolves entity names from IDs for display in breadcrumbs
const nameCache = new Map<string, string>();

async function resolveEntityName(
  type: string,
  id: string
): Promise<string> {
  const key = `${type}:${id}`;
  if (nameCache.has(key)) return nameCache.get(key)!;

  try {
    let name = id.slice(0, 8);
    if (type === "client") {
      const entity = await clientRepository.get(id);
      name = entity.name;
    } else if (type === "project") {
      const entity = await projectRepository.get(id);
      name = entity.name;
    } else if (type === "task") {
      const entity = await taskRepository.get(id);
      name = entity.name;
    }
    nameCache.set(key, name);
    return name;
  } catch {
    return id.slice(0, 8);
  }
}

// Maps URL segments to breadcrumb config
const SEGMENT_LABELS: Record<string, string> = {
  organizations: "Organizations",
  dashboard: "Dashboard",
  settings: "Settings",
  profile: "Profile",
  clients: "Clients",
  projects: "Projects",
  tasks: "Tasks",
  teams: "Teams",
  "time-entries": "Time Entries",
  invoices: "Invoices",
  new: "New",
  edit: "Edit",
  generate: "Generate",
  "log-time": "Log Time",
  contacts: "Contacts",
};

// Segments that represent entity IDs (UUID-like)
function isEntityId(segment: string): boolean {
  return /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(segment);
}

// Determines entity type from preceding segment
function getEntityType(segments: string[], index: number): string | null {
  if (index === 0) return null;
  const prev = segments[index - 1];
  const typeMap: Record<string, string> = {
    organizations: "organization",
    clients: "client",
    projects: "project",
    tasks: "task",
    teams: "team",
    "time-entries": "timeEntry",
    invoices: "invoice",
    contacts: "contact",
  };
  return typeMap[prev] ?? null;
}

export function Breadcrumbs() {
  const pathname = usePathname();
  const [crumbs, setCrumbs] = useState<Crumb[]>([]);

  useEffect(() => {
    const segments = pathname.split("/").filter(Boolean);

    async function buildCrumbs() {
      const result: Crumb[] = [];
      let path = "";

      for (let i = 0; i < segments.length; i++) {
        const segment = segments[i];
        path += `/${segment}`;

        if (isEntityId(segment)) {
          const entityType = getEntityType(segments, i);
          if (entityType && ["client", "project", "task"].includes(entityType)) {
            const name = await resolveEntityName(entityType, segment);
            result.push({ label: name, href: path });
          }
          // Skip org ID, contact ID, timeEntry ID, invoice ID, team ID in breadcrumbs
          // (they either show as their parent label or aren't needed)
          else if (entityType === "organization") {
            // Don't add org ID as a crumb — it's implicit
            continue;
          } else {
            // For other entity IDs, just use a short ID
            result.push({ label: segment.slice(0, 8) + "…", href: path });
          }
        } else {
          const label = SEGMENT_LABELS[segment] ?? segment;
          // Skip "organizations" label since org is implicit
          if (segment === "organizations") continue;
          result.push({ label, href: path });
        }
      }

      setCrumbs(result);
    }

    buildCrumbs();
  }, [pathname]);

  if (crumbs.length <= 1) return null;

  return (
    <nav aria-label="Breadcrumb" className="flex items-center gap-1.5 text-sm text-muted-foreground px-6 py-3 border-b border-border bg-card/50">
      {crumbs.map((crumb, i) => (
        <span key={crumb.href} className="flex items-center gap-1.5">
          {i > 0 && (
            <svg className="h-3.5 w-3.5 text-muted-foreground/50" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M9 5l7 7-7 7" />
            </svg>
          )}
          {i === crumbs.length - 1 ? (
            <span className={cn("text-foreground font-medium")}>{crumb.label}</span>
          ) : (
            <Link href={crumb.href} className="hover:text-foreground transition-colors">
              {crumb.label}
            </Link>
          )}
        </span>
      ))}
    </nav>
  );
}
