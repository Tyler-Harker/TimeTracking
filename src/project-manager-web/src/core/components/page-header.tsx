"use client";

import Link from "next/link";
import { buttonVariants } from "@/components/ui/button";
import { cn } from "@/lib/utils";

interface PageHeaderProps {
  title: string;
  action?: { label: string; href: string };
}

export function PageHeader({ title, action }: PageHeaderProps) {
  return (
    <div className="flex items-center justify-between mb-6">
      <h1 className="text-2xl font-bold text-foreground">{title}</h1>
      {action && (
        <Link href={action.href} className={cn(buttonVariants())}>
          {action.label}
        </Link>
      )}
    </div>
  );
}
