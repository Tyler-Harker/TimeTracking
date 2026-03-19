import type { Metadata } from "next";
import "./globals.css";
import { AuthGuard } from "@/core/components/auth-guard";

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
    <html lang="en" className="dark">
      <body className="min-h-screen bg-slate-950 text-slate-50 antialiased">
        <AuthGuard>{children}</AuthGuard>
      </body>
    </html>
  );
}
