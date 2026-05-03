"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";
import { useAuthStore } from "@/features/auth/store/auth-store";
import { clientRepository } from "@/features/clients/repository/client-repository";
import { projectRepository } from "@/features/projects/repository/project-repository";
import { taskRepository } from "@/features/tasks/repository/task-repository";
import { cn } from "@/lib/utils";

interface Crumb {
  label: string;
  href: string;
}

const nameCache = new Map<string, string>();

async function resolveEntityName(type: string, id: string): Promise<string> {
  const key = `${type}:${id}`;
  if (nameCache.has(key)) return nameCache.get(key)!;
  try {
    let name = id.slice(0, 8);
    if (type === "client") {
      name = (await clientRepository.get(id)).name;
    } else if (type === "project") {
      name = (await projectRepository.get(id)).name;
    } else if (type === "task") {
      name = (await taskRepository.get(id)).name;
    }
    nameCache.set(key, name);
    return name;
  } catch {
    return id.slice(0, 8);
  }
}

function isUuid(s: string): boolean {
  return /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(s);
}

// Action segments that are leaf pages (not navigable collections)
const ACTION_LABELS: Record<string, string> = {
  new: "New",
  edit: "Edit",
  generate: "Generate",
  "log-time": "Log Time",
};

// Segments that are collections between entities in the hierarchy
// These should NOT get their own breadcrumb — they're just URL scaffolding
const NESTED_COLLECTIONS = new Set([
  "projects", "tasks", "contacts", "teams", "time-entries",
]);

export function Breadcrumbs() {
  const pathname = usePathname();
  const { activeOrganizationId } = useAuthStore();
  const [crumbs, setCrumbs] = useState<Crumb[]>([]);

  useEffect(() => {
    const segments = pathname.split("/").filter(Boolean);

    async function buildCrumbs() {
      const result: Crumb[] = [];
      const orgBase = activeOrganizationId
        ? `/organizations/${activeOrganizationId}`
        : "";

      // Always start with Dashboard as home
      result.push({ label: "Dashboard", href: `${orgBase}/dashboard` });

      // Parse the URL to extract meaningful crumbs
      // Skip "organizations" and the orgId
      let i = 0;
      // Skip past /organizations/{orgId}
      while (i < segments.length) {
        if (segments[i] === "organizations") { i++; continue; }
        if (i > 0 && segments[i - 1] === "organizations" && isUuid(segments[i])) { i++; continue; }
        break;
      }

      // Now process the remaining segments
      let path = orgBase;
      while (i < segments.length) {
        const segment = segments[i];

        // Top-level org pages
        if (segment === "dashboard") {
          // Already added as home
          i++;
          continue;
        }

        // Top-level nav sections that have their own page
        if (segment === "clients" && (i + 1 >= segments.length || !isUuid(segments[i + 1]))) {
          // /clients is a list page — but only if it's the last segment or followed by "new"
          path += "/clients";
          result.push({ label: "Clients", href: path });
          i++;
          continue;
        }

        if (segment === "clients" && i + 1 < segments.length && isUuid(segments[i + 1])) {
          // /clients/{id} — add Clients link to list, then resolve client name
          path += "/clients";
          result.push({ label: "Clients", href: `${orgBase}/clients` });
          i++;
          const clientId = segments[i];
          path += `/${clientId}`;
          const name = await resolveEntityName("client", clientId);
          result.push({ label: name, href: path });
          i++;
          continue;
        }

        // Nested collection under an entity (projects, tasks, contacts, teams, time-entries)
        if (NESTED_COLLECTIONS.has(segment)) {
          const nextSegment = segments[i + 1];
          path += `/${segment}`;

          if (nextSegment && isUuid(nextSegment)) {
            // Collection + entity ID: skip collection crumb, add entity
            i++;
            const entityId = segments[i];
            path += `/${entityId}`;

            let entityType: string | null = null;
            if (segment === "projects") entityType = "project";
            else if (segment === "tasks") entityType = "task";

            if (entityType) {
              const name = await resolveEntityName(entityType, entityId);
              result.push({ label: name, href: path });
            } else {
              result.push({ label: entityId.slice(0, 8) + "…", href: path });
            }
            i++;
            continue;
          }

          // Collection as leaf (e.g. /teams at end, or /time-entries list)
          // Only add if it's a top-level org page with its own route
          if (segment === "time-entries" || segment === "invoices" || segment === "teams") {
            result.push({ label: segment === "time-entries" ? "Time Entries" : segment === "invoices" ? "Invoices" : "Teams", href: path });
          }
          i++;
          continue;
        }

        // Top-level org nav sections (invoices, time-entries, settings, profile, projects list)
        if (["invoices", "time-entries", "settings", "profile", "projects", "sync"].includes(segment)) {
          path += `/${segment}`;
          const labels: Record<string, string> = {
            invoices: "Invoices",
            "time-entries": "Time Entries",
            settings: "Settings",
            profile: "Profile",
            projects: "Projects",
            sync: "Sync",
          };
          result.push({ label: labels[segment] ?? segment, href: path });

          // If next segment is a UUID (e.g. /invoices/{id}), resolve it
          if (i + 1 < segments.length && isUuid(segments[i + 1])) {
            i++;
            const entityId = segments[i];
            path += `/${entityId}`;
            result.push({ label: entityId.slice(0, 8) + "…", href: path });
          }
          i++;
          continue;
        }

        // Action segments (new, edit, generate, log-time)
        if (ACTION_LABELS[segment]) {
          result.push({ label: ACTION_LABELS[segment], href: path + `/${segment}` });
          i++;
          continue;
        }

        // Fallback: skip unknown segments
        path += `/${segment}`;
        i++;
      }

      setCrumbs(result);
    }

    buildCrumbs();
  }, [pathname, activeOrganizationId]);

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
