"use client";

import { usePathname } from "next/navigation";
import Link from "next/link";
import { useAuthStore } from "@/features/auth/store/auth-store";
import { Button, buttonVariants } from "@/components/ui/button";
import { Separator } from "@/components/ui/separator";
import { cn } from "@/lib/utils";

const NAV_ITEMS = [
  { label: "Dashboard", path: "/dashboard", icon: DashboardIcon },
  { label: "Clients", path: "/clients", icon: ClientsIcon },
  { label: "Projects", path: "/projects", icon: ProjectsIcon },
  { label: "Time", path: "/time-entries", icon: TimeIcon },
  { label: "Invoices", path: "/invoices", icon: InvoicesIcon },
];

export function AppShell({ children }: { children: React.ReactNode }) {
  const pathname = usePathname();
  const { logout, activeOrganizationId } = useAuthStore();
  const orgBase = `/organizations/${activeOrganizationId}`;

  function handleLogout() {
    // logout() clears local state and then does window.location.assign(oidcLogoutUrl())
    // which navigates the page away — no router push needed.
    logout();
  }

  return (
    <div className="flex min-h-screen">
      {/* Sidebar - desktop */}
      <aside className="hidden md:flex md:w-64 md:flex-col bg-card">
        <div className="flex h-14 items-center px-4">
          <span className="text-lg font-bold text-foreground">ProjectManager</span>
        </div>
        <Separator />
        <nav className="flex-1 px-2 py-4 space-y-1">
          {NAV_ITEMS.map((item) => {
            const href = `${orgBase}${item.path}`;
            const isActive = pathname.includes(item.path);
            return (
              <Link
                key={item.path}
                href={href}
                className={cn(
                  buttonVariants({ variant: isActive ? "secondary" : "ghost" }),
                  "w-full justify-start gap-3",
                  isActive && "bg-primary/10 text-primary"
                )}
              >
                <item.icon active={isActive} />
                {item.label}
              </Link>
            );
          })}
        </nav>
        <Separator />
        <div className="p-2 space-y-1">
          <Link href={`${orgBase}/profile`} className={cn(buttonVariants({ variant: "ghost" }), "w-full justify-start gap-3")}>
            <ProfileIcon />
            Profile
          </Link>
          <Link href={`${orgBase}/settings`} className={cn(buttonVariants({ variant: "ghost" }), "w-full justify-start gap-3")}>
            <SettingsIcon />
            Settings
          </Link>
          <Link href={`${orgBase}/sync`} className={cn(buttonVariants({ variant: "ghost" }), "w-full justify-start gap-3")}>
            <SyncIcon />
            Sync
          </Link>
          <Link href="/organizations" className={cn(buttonVariants({ variant: "ghost" }), "w-full justify-start gap-3")}>
            <OrgIcon />
            Switch Org
          </Link>
          <Button variant="ghost" className="w-full justify-start gap-3 text-muted-foreground" onClick={handleLogout}>
            <LogoutIcon />
            Sign Out
          </Button>
        </div>
      </aside>

      {/* Main content */}
      <div className="flex flex-1 flex-col">
        {/* Mobile header */}
        <header className="flex h-14 items-center justify-between bg-card px-4 md:hidden">
          <span className="text-lg font-bold text-foreground">PM</span>
          <div className="flex items-center gap-2">
            <Link href={`${orgBase}/profile`} className={cn(buttonVariants({ variant: "ghost", size: "icon" }))}>
              <ProfileIcon />
            </Link>
            <Button variant="ghost" size="icon" onClick={handleLogout}>
              <LogoutIcon />
            </Button>
          </div>
        </header>
        <Separator className="md:hidden" />

        {/* Page content */}
        <main className="flex-1 overflow-auto bg-background">{children}</main>

        {/* Mobile bottom nav */}
        <Separator className="md:hidden" />
        <nav className="flex bg-card md:hidden">
          {NAV_ITEMS.map((item) => {
            const href = `${orgBase}${item.path}`;
            const isActive = pathname.includes(item.path);
            return (
              <Link
                key={item.path}
                href={href}
                className={cn(
                  "flex flex-1 flex-col items-center gap-1 py-2 text-xs",
                  isActive ? "text-primary" : "text-muted-foreground"
                )}
              >
                <item.icon active={isActive} />
                {item.label}
              </Link>
            );
          })}
        </nav>
      </div>
    </div>
  );
}

function DashboardIcon({ active }: { active?: boolean }) {
  return (
    <svg className={cn("h-5 w-5", active && "text-primary")} fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6" />
    </svg>
  );
}

function ClientsIcon({ active }: { active?: boolean }) {
  return (
    <svg className={cn("h-5 w-5", active && "text-primary")} fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0z" />
    </svg>
  );
}

function ProjectsIcon({ active }: { active?: boolean }) {
  return (
    <svg className={cn("h-5 w-5", active && "text-primary")} fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
    </svg>
  );
}

function TimeIcon({ active }: { active?: boolean }) {
  return (
    <svg className={cn("h-5 w-5", active && "text-primary")} fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
    </svg>
  );
}

function InvoicesIcon({ active }: { active?: boolean }) {
  return (
    <svg className={cn("h-5 w-5", active && "text-primary")} fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M9 14l6-6m-5.5.5h.01m4.99 5h.01M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16l3.5-2 3.5 2 3.5-2 3.5 2z" />
    </svg>
  );
}

function ProfileIcon() {
  return (
    <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
    </svg>
  );
}

function SettingsIcon() {
  return (
    <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.066 2.573c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.573 1.066c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.066-2.573c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z" />
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
    </svg>
  );
}

function OrgIcon() {
  return (
    <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4" />
    </svg>
  );
}

function SyncIcon() {
  return (
    <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M4 4v5h5M20 20v-5h-5M5.5 9A7 7 0 0118.36 7M18.5 15A7 7 0 015.64 17" />
    </svg>
  );
}

function LogoutIcon() {
  return (
    <svg className="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1.5} d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1" />
    </svg>
  );
}
