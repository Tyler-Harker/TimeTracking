"use client";

import Link from "next/link";
import { buttonVariants } from "@/components/ui/button";
import { cn } from "@/lib/utils";

interface PageHeaderAction {
  label: string;
  href: string;
}

interface PageHeaderProps {
  title: string;
  action?: PageHeaderAction;
  secondaryAction?: PageHeaderAction;
}

export function PageHeader({ title, action, secondaryAction }: PageHeaderProps) {
  return (
    <div className="flex items-center justify-between mb-6">
      <h1 className="text-2xl font-bold text-foreground">{title}</h1>
      {(action || secondaryAction) && (
        <div className="flex items-center gap-2">
          {secondaryAction && (
            <Link href={secondaryAction.href} className={cn(buttonVariants({ variant: "outline" }))}>
              {secondaryAction.label}
            </Link>
          )}
          {action && (
            <Link href={action.href} className={cn(buttonVariants())}>
              {action.label}
            </Link>
          )}
        </div>
      )}
    </div>
  );
}
