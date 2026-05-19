"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import { useParams, useRouter, useSearchParams } from "next/navigation";
import { timeEntryRepository } from "@/features/time-entries/repository/time-entry-repository";
import type { TimeEntry } from "@/features/time-entries/models/types";
import { PageHeader } from "@/core/components/page-header";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";
import { CalendarHeader } from "./_components/calendar-header";
import { CalendarFilters, type CalendarFilterValues } from "./_components/calendar-filters";
import { CalendarMonthView } from "./_components/calendar-month-view";
import { CalendarWeekView } from "./_components/calendar-week-view";
import { CalendarDayView } from "./_components/calendar-day-view";
import { DayDetailPanel } from "./_components/day-detail-panel";
import {
  type CalendarView,
  getRange,
  isCalendarView,
  parseAnchor,
  toIso,
} from "./_components/date-utils";

export default function TimeEntryCalendarPage() {
  const params = useParams<{ orgId: string }>();
  const orgId = params.orgId;
  const router = useRouter();
  const searchParams = useSearchParams();
  const searchKey = searchParams.toString();

  const view: CalendarView = useMemo(() => {
    const v = searchParams.get("view");
    return isCalendarView(v) ? v : "month";
  }, [searchParams]);

  const anchor = useMemo(() => parseAnchor(searchParams.get("date")), [searchParams]);

  const filters: CalendarFilterValues = useMemo(() => ({
    projectId: searchParams.get("projectId") ?? undefined,
    clientId: searchParams.get("clientId") ?? undefined,
    userId: searchParams.get("userId") ?? undefined,
    taskId: searchParams.get("taskId") ?? undefined,
  }), [searchParams]);

  const [entries, setEntries] = useState<TimeEntry[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedDate, setSelectedDate] = useState<Date | null>(null);

  const range = useMemo(() => getRange(view, anchor), [view, anchor]);
  const rangeKey = `${toIso(range.start)}_${toIso(range.end)}`;

  const load = useCallback(async () => {
    setLoading(true);
    setError(null);
    try {
      const data = await timeEntryRepository.list({
        fromDate: toIso(range.start),
        toDate: toIso(range.end),
        projectId: filters.projectId,
        clientId: filters.clientId,
        userId: filters.userId,
        taskId: filters.taskId,
        unpaged: true,
      });
      setEntries(data);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load time entries");
    } finally {
      setLoading(false);
    }
  }, [rangeKey, filters.projectId, filters.clientId, filters.userId, filters.taskId]); // eslint-disable-line react-hooks/exhaustive-deps

  useEffect(() => {
    load();
  }, [load]);

  const entriesByDate = useMemo(() => {
    const map = new Map<string, TimeEntry[]>();
    for (const entry of entries) {
      const key = entry.date.slice(0, 10);
      const arr = map.get(key);
      if (arr) arr.push(entry);
      else map.set(key, [entry]);
    }
    return map;
  }, [entries]);

  const pushParams = useCallback((mutate: (params: URLSearchParams) => void) => {
    const next = new URLSearchParams(searchKey);
    mutate(next);
    const str = next.toString();
    router.replace(str ? `?${str}` : "?", { scroll: false });
  }, [router, searchKey]);

  const setView = useCallback((next: CalendarView) => {
    pushParams((p) => {
      if (next === "month") p.delete("view");
      else p.set("view", next);
    });
  }, [pushParams]);

  const setAnchor = useCallback((iso: string) => {
    pushParams((p) => p.set("date", iso));
  }, [pushParams]);

  const setFilters = useCallback((next: CalendarFilterValues) => {
    pushParams((p) => {
      for (const key of ["projectId", "clientId", "userId", "taskId"] as const) {
        const value = next[key];
        if (value) p.set(key, value);
        else p.delete(key);
      }
    });
  }, [pushParams]);

  const handleSelectDate = useCallback((date: Date, dayEntries: TimeEntry[]) => {
    if (dayEntries.length === 0) {
      router.push(`/organizations/${orgId}/time-entries/new?date=${toIso(date)}`);
      return;
    }
    setSelectedDate(date);
  }, [router, orgId]);

  const selectedEntries = useMemo(() => {
    if (!selectedDate) return [];
    return entriesByDate.get(toIso(selectedDate)) ?? [];
  }, [selectedDate, entriesByDate]);

  return (
    <div className="p-6">
      <PageHeader
        title="Time Entries Calendar"
        secondaryAction={{ label: "List view", href: `/organizations/${orgId}/time-entries` }}
        action={{ label: "New Entry", href: `/organizations/${orgId}/time-entries/new` }}
      />

      <div className="flex flex-col gap-4">
        <CalendarHeader
          view={view}
          anchor={anchor}
          onViewChange={setView}
          onAnchorChange={setAnchor}
        />

        <CalendarFilters values={filters} onChange={setFilters} />

        {loading ? (
          <LoadingSpinner />
        ) : error ? (
          <ErrorDisplay message={error} onRetry={load} />
        ) : (
          <>
            {view === "month" && (
              <CalendarMonthView
                anchor={anchor}
                entriesByDate={entriesByDate}
                onSelectDate={handleSelectDate}
              />
            )}
            {view === "week" && (
              <CalendarWeekView
                anchor={anchor}
                entriesByDate={entriesByDate}
                onSelectDate={handleSelectDate}
              />
            )}
            {view === "day" && (
              <CalendarDayView
                anchor={anchor}
                entriesByDate={entriesByDate}
                orgId={orgId}
              />
            )}

            {entries.length === 0 && view !== "day" && (
              <p className="px-1 text-sm text-muted-foreground">
                No entries in this range — click any day to log time.
              </p>
            )}
          </>
        )}
      </div>

      <DayDetailPanel
        date={selectedDate}
        entries={selectedEntries}
        orgId={orgId}
        onClose={() => setSelectedDate(null)}
        onMutated={() => {
          setSelectedDate(null);
          load();
        }}
      />
    </div>
  );
}
