import type { Metadata } from "next";
import "./globals.css";
import { AuthGuard } from "@/core/components/auth-guard";
import { Geist } from "next/font/google";
import { cn } from "@/lib/utils";

const geist = Geist({subsets:['latin'],variable:'--font-sans'});

export const metadata: Metadata = {
  title: "ProjectManager",
  description: "Project management application",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" className={cn("dark", "font-sans", geist.variable)}>
      <body className="min-h-screen bg-background text-foreground antialiased">
        <AuthGuard>{children}</AuthGuard>
      </body>
    </html>
  );
}
