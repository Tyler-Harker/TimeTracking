"use client";

import { isSameDay } from "date-fns";
import type { TimeEntry } from "@/features/time-entries/models/types";
import { Badge } from "@/components/ui/badge";
import { cn } from "@/lib/utils";

interface CalendarDayCellProps {
  date: Date;
  entries: TimeEntry[];
  inCurrentMonth: boolean;
  isToday: boolean;
  size?: "default" | "tall";
  onClick: (date: Date, entries: TimeEntry[]) => void;
}

export function CalendarDayCell({
  date,
  entries,
  inCurrentMonth,
  isToday,
  size = "default",
  onClick,
}: CalendarDayCellProps) {
  const totalHours = entries.reduce((sum, e) => sum + e.hours, 0);
  const hasEntries = entries.length > 0;

  return (
    <button
      type="button"
      onClick={() => onClick(date, entries)}
      className={cn(
        "group flex flex-col gap-1 rounded-lg border border-border bg-card p-2 text-left transition-all",
        "hover:ring-2 hover:ring-primary/40 focus:outline-none focus-visible:ring-2 focus-visible:ring-primary",
        size === "default" ? "min-h-24" : "min-h-32",
        !inCurrentMonth && "bg-muted/30 opacity-70",
      )}
    >
      <div className="flex items-baseline justify-between">
        <span
          className={cn(
            "text-sm font-medium",
            !inCurrentMonth && "text-muted-foreground/60",
            isToday && "inline-flex h-6 min-w-6 items-center justify-center rounded-full bg-primary px-1.5 text-primary-foreground",
          )}
        >
          {date.getDate()}
        </span>
        {hasEntries && (
          <Badge variant="secondary" className="text-xs">
            {entries.length}
          </Badge>
        )}
      </div>
      {hasEntries && (
        <div className="mt-auto flex flex-col gap-0.5">
          <span className="text-base font-semibold tabular-nums text-foreground">
            {formatHours(totalHours)} hrs
          </span>
        </div>
      )}
    </button>
  );
}

function formatHours(hours: number): string {
  return Number.isInteger(hours) ? hours.toFixed(0) : hours.toFixed(2).replace(/\.?0+$/, "");
}

export function isSameDate(a: Date, b: Date): boolean {
  return isSameDay(a, b);
}
