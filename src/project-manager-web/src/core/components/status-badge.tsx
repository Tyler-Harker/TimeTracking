const STATUS_STYLES: Record<string, string> = {
  Active: "bg-green-500/20 text-green-400",
  Planned: "bg-blue-500/20 text-blue-400",
  OnHold: "bg-yellow-500/20 text-yellow-400",
  Completed: "bg-slate-500/20 text-slate-400",
  Cancelled: "bg-red-500/20 text-red-400",
  Draft: "bg-slate-500/20 text-slate-400",
  Sent: "bg-blue-500/20 text-blue-400",
  Paid: "bg-green-500/20 text-green-400",
  Overdue: "bg-red-500/20 text-red-400",
  Open: "bg-blue-500/20 text-blue-400",
  InProgress: "bg-indigo-500/20 text-indigo-400",
  Low: "bg-slate-500/20 text-slate-400",
  Medium: "bg-yellow-500/20 text-yellow-400",
  High: "bg-orange-500/20 text-orange-400",
  Urgent: "bg-red-500/20 text-red-400",
};

interface StatusBadgeProps {
  status: string;
}

export function StatusBadge({ status }: StatusBadgeProps) {
  const style = STATUS_STYLES[status] ?? "bg-slate-500/20 text-slate-400";
  return (
    <span className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${style}`}>
      {status}
    </span>
  );
}
