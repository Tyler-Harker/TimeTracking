import {
  addDays,
  addMonths,
  addWeeks,
  endOfMonth,
  endOfWeek,
  format,
  parseISO,
  startOfDay,
  startOfMonth,
  startOfWeek,
} from "date-fns";

export type CalendarView = "month" | "week" | "day";

export function isCalendarView(value: string | null | undefined): value is CalendarView {
  return value === "month" || value === "week" || value === "day";
}

export function parseAnchor(value: string | null | undefined): Date {
  if (value && /^\d{4}-\d{2}-\d{2}$/.test(value)) {
    return startOfDay(parseISO(value));
  }
  return startOfDay(new Date());
}

export function toIso(date: Date): string {
  return format(date, "yyyy-MM-dd");
}

export function getRange(view: CalendarView, anchor: Date): { start: Date; end: Date } {
  if (view === "day") {
    return { start: startOfDay(anchor), end: startOfDay(anchor) };
  }
  if (view === "week") {
    return { start: startOfWeek(anchor), end: endOfWeek(anchor) };
  }
  return {
    start: startOfWeek(startOfMonth(anchor)),
    end: endOfWeek(endOfMonth(anchor)),
  };
}

export function getMonthGrid(anchor: Date): Date[] {
  const start = startOfWeek(startOfMonth(anchor));
  return Array.from({ length: 42 }, (_, i) => addDays(start, i));
}

export function getWeekDays(anchor: Date): Date[] {
  const start = startOfWeek(anchor);
  return Array.from({ length: 7 }, (_, i) => addDays(start, i));
}

export function shiftAnchor(view: CalendarView, anchor: Date, direction: 1 | -1): Date {
  if (view === "day") return addDays(anchor, direction);
  if (view === "week") return addWeeks(anchor, direction);
  return addMonths(anchor, direction);
}

export function formatHeader(view: CalendarView, anchor: Date): string {
  if (view === "day") return format(anchor, "EEEE, MMMM d, yyyy");
  if (view === "week") {
    const start = startOfWeek(anchor);
    const end = endOfWeek(anchor);
    if (start.getMonth() === end.getMonth()) {
      return `${format(start, "MMM d")} – ${format(end, "d, yyyy")}`;
    }
    return `${format(start, "MMM d")} – ${format(end, "MMM d, yyyy")}`;
  }
  return format(anchor, "MMMM yyyy");
}

export const WEEKDAY_LABELS = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
