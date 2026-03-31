import { Card, CardContent } from "@/components/ui/card";

interface EmptyStateProps {
  message: string;
}

export function EmptyState({ message }: EmptyStateProps) {
  return (
    <Card>
      <CardContent className="flex items-center justify-center py-8">
        <p className="text-muted-foreground">{message}</p>
      </CardContent>
    </Card>
  );
}
