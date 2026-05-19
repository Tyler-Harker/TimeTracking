"use client";

import { ChevronLeftIcon, ChevronRightIcon } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "@/components/ui/select";
import type { CalendarView } from "./date-utils";
import { formatHeader, shiftAnchor, toIso } from "./date-utils";

interface CalendarHeaderProps {
  view: CalendarView;
  anchor: Date;
  onViewChange: (view: CalendarView) => void;
  onAnchorChange: (anchorIso: string) => void;
}

export function CalendarHeader({ view, anchor, onViewChange, onAnchorChange }: CalendarHeaderProps) {
  return (
    <div className="flex flex-wrap items-center justify-between gap-3">
      <div className="flex items-center gap-2">
        <Button
          variant="outline"
          size="icon-sm"
          onClick={() => onAnchorChange(toIso(shiftAnchor(view, anchor, -1)))}
          aria-label="Previous"
        >
          <ChevronLeftIcon />
        </Button>
        <Button
          variant="outline"
          size="sm"
          onClick={() => onAnchorChange(toIso(new Date()))}
        >
          Today
        </Button>
        <Button
          variant="outline"
          size="icon-sm"
          onClick={() => onAnchorChange(toIso(shiftAnchor(view, anchor, 1)))}
          aria-label="Next"
        >
          <ChevronRightIcon />
        </Button>
        <h2 className="ml-2 text-lg font-semibold text-foreground">
          {formatHeader(view, anchor)}
        </h2>
      </div>

      <Select value={view} onValueChange={(val) => onViewChange((val as CalendarView) ?? "month")}>
        <SelectTrigger className="w-32">
          <SelectValue />
        </SelectTrigger>
        <SelectContent>
          <SelectItem value="month">Month</SelectItem>
          <SelectItem value="week">Week</SelectItem>
          <SelectItem value="day">Day</SelectItem>
        </SelectContent>
      </Select>
    </div>
  );
}
