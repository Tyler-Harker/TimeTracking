"use client";

import { Card, CardContent } from "@/components/ui/card";
import { cn } from "@/lib/utils";

interface StatCardProps {
  label: string;
  value: string;
  icon: React.ReactNode;
  iconColor?: string;
}

export function StatCard({ label, value, icon, iconColor }: StatCardProps) {
  return (
    <Card className="py-0">
      <CardContent className={cn("flex items-center gap-4 py-4")}>
        <div
          className="flex h-10 w-10 items-center justify-center rounded-lg"
          style={{ backgroundColor: iconColor ? `${iconColor}20` : undefined, color: iconColor }}
        >
          {icon}
        </div>
        <div>
          <p className="text-sm text-muted-foreground">{label}</p>
          <p className="text-xl font-bold text-card-foreground">{value}</p>
        </div>
      </CardContent>
    </Card>
  );
}
