"use client";

import { Alert, AlertDescription } from "@/components/ui/alert";
import { Button } from "@/components/ui/button";
import { AlertCircle } from "lucide-react";

interface ErrorDisplayProps {
  message: string;
  onRetry?: () => void;
}

export function ErrorDisplay({ message, onRetry }: ErrorDisplayProps) {
  return (
    <div className="flex flex-col items-center justify-center py-12 gap-4">
      <Alert variant="destructive" className="max-w-md">
        <AlertCircle className="size-4" />
        <AlertDescription>{message}</AlertDescription>
      </Alert>
      {onRetry && (
        <Button onClick={onRetry} size="sm">
          Retry
        </Button>
      )}
    </div>
  );
}
