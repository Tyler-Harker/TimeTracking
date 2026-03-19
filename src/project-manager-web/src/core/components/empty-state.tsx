interface EmptyStateProps {
  message: string;
}

export function EmptyState({ message }: EmptyStateProps) {
  return (
    <div className="flex items-center justify-center rounded-xl border border-slate-700 bg-slate-800 p-12">
      <p className="text-slate-400">{message}</p>
    </div>
  );
}
