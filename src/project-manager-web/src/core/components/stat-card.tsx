"use client";

interface StatCardProps {
  label: string;
  value: string;
  icon: React.ReactNode;
  iconColor?: string;
}

export function StatCard({ label, value, icon, iconColor }: StatCardProps) {
  return (
    <div className="rounded-xl border border-slate-700 bg-slate-800 p-4 flex items-center gap-4">
      <div
        className="flex h-10 w-10 items-center justify-center rounded-lg"
        style={{ backgroundColor: iconColor ? `${iconColor}20` : undefined, color: iconColor }}
      >
        {icon}
      </div>
      <div>
        <p className="text-sm text-slate-400">{label}</p>
        <p className="text-xl font-bold text-slate-50">{value}</p>
      </div>
    </div>
  );
}
