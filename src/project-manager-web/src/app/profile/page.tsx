"use client";

import { useEffect, useState, type FormEvent } from "react";
import { userRepository } from "@/features/user/repository/user-repository";
import type { UserProfile } from "@/features/user/models/types";
import { LoadingSpinner } from "@/core/components/loading-spinner";
import { ErrorDisplay } from "@/core/components/error-display";

export default function ProfilePage() {
  const [user, setUser] = useState<UserProfile | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [saving, setSaving] = useState(false);
  const [firstName, setFirstName] = useState("");
  const [lastName, setLastName] = useState("");

  async function load() {
    setLoading(true);
    try {
      const u = await userRepository.getCurrentUser();
      setUser(u);
      setFirstName(u.firstName);
      setLastName(u.lastName);
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to load profile");
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => { load(); }, []);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSaving(true);
    try {
      await userRepository.updateUser({ firstName, lastName });
      load();
    } catch (e) {
      setError(e instanceof Error ? e.message : "Failed to update profile");
    } finally {
      setSaving(false);
    }
  }

  if (loading) return <LoadingSpinner />;
  if (error && !user) return <ErrorDisplay message={error} onRetry={load} />;
  if (!user) return null;

  return (
    <div className="p-6 max-w-2xl">
      <h1 className="text-2xl font-bold text-slate-50 mb-6">Profile</h1>
      <div className="rounded-xl border border-slate-700 bg-slate-800 p-4 mb-6">
        <p className="text-sm text-slate-400"><span className="text-slate-300">Email:</span> {user.email}</p>
        <p className="text-sm text-slate-400 mt-1"><span className="text-slate-300">Member since:</span> {new Date(user.createdAt).toLocaleDateString()}</p>
      </div>

      {error && <div className="mb-4 rounded-lg bg-red-500/10 border border-red-500/20 p-3 text-sm text-red-400">{error}</div>}
      <form onSubmit={handleSubmit} className="space-y-4">
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">First Name</label>
          <input type="text" required value={firstName} onChange={(e) => setFirstName(e.target.value)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none" />
        </div>
        <div>
          <label className="block text-sm font-medium text-slate-300 mb-1.5">Last Name</label>
          <input type="text" required value={lastName} onChange={(e) => setLastName(e.target.value)} className="w-full rounded-lg border border-slate-600 bg-slate-800 px-4 py-2.5 text-slate-50 focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 focus:outline-none" />
        </div>
        <button type="submit" disabled={saving} className="rounded-lg bg-indigo-600 px-6 py-2.5 text-sm font-medium text-white hover:bg-indigo-500 disabled:opacity-50 transition-colors">{saving ? "Saving..." : "Update Profile"}</button>
      </form>
    </div>
  );
}
