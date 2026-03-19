"use client";

interface ErrorDisplayProps {
  message: string;
  onRetry?: () => void;
}

export function ErrorDisplay({ message, onRetry }: ErrorDisplayProps) {
  return (
    <div className="flex flex-col items-center justify-center py-12 gap-4">
      <p className="text-error text-sm">{message}</p>
      {onRetry && (
        <button
          onClick={onRetry}
          className="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white hover:bg-indigo-500 transition-colors"
        >
          Retry
        </button>
      )}
    </div>
  );
}
