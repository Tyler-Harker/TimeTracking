"use client";

import Link from "next/link";
import { format } from "date-fns";
import type { TimeEntry } from "@/features/time-entries/models/types";
import { Card, CardContent } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { toIso } from "./date-utils";

interface CalendarDayViewProps {
  anchor: Date;
  entriesByDate: Map<string, TimeEntry[]>;
  orgId: string;
}

export function CalendarDayView({ anchor, entriesByDate, orgId }: CalendarDayViewProps) {
  const iso = toIso(anchor);
  const entries = entriesByDate.get(iso) ?? [];
  const total = entries.reduce((sum, e) => sum + e.hours, 0);

  return (
    <div className="flex flex-col gap-3">
      <div className="flex items-center justify-between rounded-lg border border-border bg-card px-4 py-3">
        <div>
          <p className="text-sm text-muted-foreground">{format(anchor, "EEEE")}</p>
          <p className="text-lg font-semibold text-foreground">{format(anchor, "MMMM d, yyyy")}</p>
        </div>
        <div className="text-right">
          <p className="text-sm text-muted-foreground">Total</p>
          <p className="text-lg font-semibold tabular-nums text-foreground">{total} hrs</p>
        </div>
      </div>

      {entries.length === 0 ? (
        <Card>
          <CardContent className="flex flex-col items-center justify-center gap-3 py-10">
            <p className="text-muted-foreground">No time entries on this day.</p>
            <Link href={`/organizations/${orgId}/time-entries/new?date=${iso}`}>
              <Button>Log time for this day</Button>
            </Link>
          </CardContent>
        </Card>
      ) : (
        <div className="flex flex-col gap-2">
          {entries.map((entry) => (
            <Link
              key={entry.id}
              href={`/organizations/${orgId}/time-entries/${entry.id}/edit`}
              className="block"
            >
              <Card className="transition-all hover:ring-2 hover:ring-primary/40">
                <CardContent>
                  <div className="flex items-center justify-between gap-4">
                    <div className="min-w-0 flex-1">
                      <p className="font-medium text-foreground">{entry.projectName}</p>
                      <p className="truncate text-sm text-muted-foreground">
                        {entry.description || "No description"}
                      </p>
                      <div className="mt-1 flex flex-wrap items-center gap-2 text-xs text-muted-foreground">
                        <span>{entry.userName}</span>
                        {entry.taskName && <span>· {entry.taskName}</span>}
                      </div>
                    </div>
                    <div className="text-right">
                      <p className="font-semibold tabular-nums text-foreground">{entry.hours}h</p>
                      <div className="mt-1 flex justify-end gap-1.5">
                        {entry.isBillable && (
                          <Badge variant="secondary" className="text-xs">Billable</Badge>
                        )}
                        {entry.isInvoiced && (
                          <Badge variant="default" className="text-xs">Invoiced</Badge>
                        )}
                      </div>
                    </div>
                  </div>
                </CardContent>
              </Card>
            </Link>
          ))}
          <div className="pt-2">
            <Link href={`/organizations/${orgId}/time-entries/new?date=${iso}`}>
              <Button variant="outline">Log another entry</Button>
            </Link>
          </div>
        </div>
      )}
    </div>
  );
}
