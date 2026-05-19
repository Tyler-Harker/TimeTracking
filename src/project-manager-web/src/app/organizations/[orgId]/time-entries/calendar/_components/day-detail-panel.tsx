"use client";

import Link from "next/link";
import { format } from "date-fns";
import type { TimeEntry } from "@/features/time-entries/models/types";
import { timeEntryRepository } from "@/features/time-entries/repository/time-entry-repository";
import {
  Dialog,
  DialogContent,
  DialogHeader,
  DialogTitle,
  DialogFooter,
  DialogClose,
} from "@/components/ui/dialog";
import { Badge } from "@/components/ui/badge";
import { Button } from "@/components/ui/button";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { useState } from "react";

interface DayDetailPanelProps {
  date: Date | null;
  entries: TimeEntry[];
  orgId: string;
  onClose: () => void;
  onMutated: () => void;
}

export function DayDetailPanel({ date, entries, orgId, onClose, onMutated }: DayDetailPanelProps) {
  const [deletingId, setDeletingId] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  const open = date !== null;
  const total = entries.reduce((sum, e) => sum + e.hours, 0);
  const iso = date ? format(date, "yyyy-MM-dd") : "";

  async function handleDelete(id: string) {
    setDeletingId(id);
    setError(null);
    try {
      await timeEntryRepository.delete(id);
      onMutated();
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to delete entry");
    } finally {
      setDeletingId(null);
    }
  }

  return (
    <Dialog open={open} onOpenChange={(o) => !o && onClose()}>
      <DialogContent className="sm:max-w-lg">
        {date && (
          <>
            <DialogHeader>
              <DialogTitle>{format(date, "EEEE, MMMM d, yyyy")}</DialogTitle>
              <p className="text-sm text-muted-foreground">
                {entries.length} {entries.length === 1 ? "entry" : "entries"} · {total} hrs total
              </p>
            </DialogHeader>

            {error && (
              <p className="text-sm text-destructive">{error}</p>
            )}

            {entries.length === 0 ? (
              <p className="py-6 text-center text-sm text-muted-foreground">
                No entries logged on this day.
              </p>
            ) : (
              <ScrollArea className="max-h-80 -mx-1">
                <div className="flex flex-col gap-2 px-1">
                  {entries.map((entry, i) => (
                    <div key={entry.id}>
                      {i > 0 && <Separator className="mb-2" />}
                      <div className="flex items-start justify-between gap-3">
                        <div className="min-w-0 flex-1">
                          <p className="font-medium text-foreground">{entry.projectName}</p>
                          {entry.taskName && (
                            <p className="text-xs text-muted-foreground">Task: {entry.taskName}</p>
                          )}
                          {entry.description && (
                            <p className="mt-1 text-sm text-muted-foreground">{entry.description}</p>
                          )}
                          <div className="mt-1 flex flex-wrap items-center gap-2 text-xs text-muted-foreground">
                            <span>{entry.userName}</span>
                            {entry.isBillable && (
                              <Badge variant="secondary" className="text-xs">Billable</Badge>
                            )}
                            {entry.isInvoiced && (
                              <Badge variant="default" className="text-xs">Invoiced</Badge>
                            )}
                          </div>
                        </div>
                        <div className="flex flex-col items-end gap-1">
                          <span className="font-semibold tabular-nums text-foreground">{entry.hours}h</span>
                          <div className="flex gap-1">
                            <Link href={`/organizations/${orgId}/time-entries/${entry.id}/edit`}>
                              <Button variant="ghost" size="sm">Edit</Button>
                            </Link>
                            <Button
                              variant="ghost"
                              size="sm"
                              disabled={deletingId === entry.id}
                              onClick={() => handleDelete(entry.id)}
                            >
                              {deletingId === entry.id ? "..." : "Delete"}
                            </Button>
                          </div>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </ScrollArea>
            )}

            <DialogFooter>
              <DialogClose render={<Button variant="outline" />}>Close</DialogClose>
              <Link href={`/organizations/${orgId}/time-entries/new?date=${iso}`}>
                <Button>Add entry on this date</Button>
              </Link>
            </DialogFooter>
          </>
        )}
      </DialogContent>
    </Dialog>
  );
}
