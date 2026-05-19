"use client";

import { format, isToday } from "date-fns";
import type { TimeEntry } from "@/features/time-entries/models/types";
import { CalendarDayCell } from "./calendar-day-cell";
import { WEEKDAY_LABELS, getWeekDays, toIso } from "./date-utils";

interface CalendarWeekViewProps {
  anchor: Date;
  entriesByDate: Map<string, TimeEntry[]>;
  onSelectDate: (date: Date, entries: TimeEntry[]) => void;
}

export function CalendarWeekView({ anchor, entriesByDate, onSelectDate }: CalendarWeekViewProps) {
  const days = getWeekDays(anchor);

  return (
    <div className="flex flex-col gap-2">
      <div className="grid grid-cols-7 gap-2 px-1 text-xs font-medium text-muted-foreground">
        {days.map((day, i) => (
          <div key={day.toISOString()} className="flex items-baseline gap-1.5 px-1">
            <span>{WEEKDAY_LABELS[i]}</span>
            <span className="text-foreground/70">{format(day, "MMM d")}</span>
          </div>
        ))}
      </div>
      <div className="grid grid-cols-7 gap-2">
        {days.map((day) => (
          <CalendarDayCell
            key={day.toISOString()}
            date={day}
            entries={entriesByDate.get(toIso(day)) ?? []}
            inCurrentMonth={true}
            isToday={isToday(day)}
            size="tall"
            onClick={onSelectDate}
          />
        ))}
      </div>
    </div>
  );
}
