import { Badge } from "@/components/ui/badge";
import { cn } from "@/lib/utils";

const STATUS_STYLES: Record<string, string> = {
  Active: "bg-green-500/20 text-green-400 border-green-500/30",
  Planned: "bg-blue-500/20 text-blue-400 border-blue-500/30",
  OnHold: "bg-yellow-500/20 text-yellow-400 border-yellow-500/30",
  Completed: "bg-muted text-muted-foreground border-border",
  Cancelled: "bg-red-500/20 text-red-400 border-red-500/30",
  Draft: "bg-muted text-muted-foreground border-border",
  Sent: "bg-blue-500/20 text-blue-400 border-blue-500/30",
  Paid: "bg-green-500/20 text-green-400 border-green-500/30",
  Overdue: "bg-red-500/20 text-red-400 border-red-500/30",
  Open: "bg-blue-500/20 text-blue-400 border-blue-500/30",
  InProgress: "bg-primary/20 text-primary border-primary/30",
  Low: "bg-muted text-muted-foreground border-border",
  Medium: "bg-yellow-500/20 text-yellow-400 border-yellow-500/30",
  High: "bg-orange-500/20 text-orange-400 border-orange-500/30",
  Urgent: "bg-red-500/20 text-red-400 border-red-500/30",
};

interface StatusBadgeProps {
  status: string;
}

export function StatusBadge({ status }: StatusBadgeProps) {
  const style = STATUS_STYLES[status] ?? "bg-muted text-muted-foreground border-border";
  return (
    <Badge variant="outline" className={cn(style)}>
      {status}
    </Badge>
  );
}
