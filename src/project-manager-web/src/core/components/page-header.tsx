"use client";

import Link from "next/link";

interface PageHeaderProps {
  title: string;
  action?: { label: string; href: string };
}

export function PageHeader({ title, action }: PageHeaderProps) {
  return (
    <div className="flex items-center justify-between mb-6">
      <h1 className="text-2xl font-bold text-slate-50">{title}</h1>
      {action && (
        <Link
          href={action.href}
          className="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white hover:bg-indigo-500 transition-colors"
        >
          {action.label}
        </Link>
      )}
    </div>
  );
}
