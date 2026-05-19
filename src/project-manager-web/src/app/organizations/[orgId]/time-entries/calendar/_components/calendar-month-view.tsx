"use client";

import { isSameMonth, isToday } from "date-fns";
import type { TimeEntry } from "@/features/time-entries/models/types";
import { CalendarDayCell } from "./calendar-day-cell";
import { WEEKDAY_LABELS, getMonthGrid, toIso } from "./date-utils";

interface CalendarMonthViewProps {
  anchor: Date;
  entriesByDate: Map<string, TimeEntry[]>;
  onSelectDate: (date: Date, entries: TimeEntry[]) => void;
}

export function CalendarMonthView({ anchor, entriesByDate, onSelectDate }: CalendarMonthViewProps) {
  const days = getMonthGrid(anchor);

  return (
    <div className="flex flex-col gap-2">
      <div className="grid grid-cols-7 gap-2 px-1 text-xs font-medium text-muted-foreground">
        {WEEKDAY_LABELS.map((label) => (
          <div key={label} className="px-1">{label}</div>
        ))}
      </div>
      <div className="grid grid-cols-7 gap-2">
        {days.map((day) => (
          <CalendarDayCell
            key={day.toISOString()}
            date={day}
            entries={entriesByDate.get(toIso(day)) ?? []}
            inCurrentMonth={isSameMonth(day, anchor)}
            isToday={isToday(day)}
            onClick={onSelectDate}
          />
        ))}
      </div>
    </div>
  );
}
