import { test, expect } from "@playwright/test";
import {
  adminLogin,
  apiContext,
  createOrgAs,
  disposeApiContext,
  registerUser,
} from "./helpers/api";

test.afterAll(async () => {
  await disposeApiContext();
});

test.describe("admin organization management", () => {
  test("admin can log in and list organizations including a freshly-created one", async () => {
    const ctx = await apiContext();
    const adminToken = await adminLogin();
    const creator = await registerUser("creator");
    const org = await createOrgAs(creator);

    const response = await ctx.get("/api/admin/organizations", {
      headers: { Authorization: `Bearer ${adminToken}` },
      params: { search: org.slug, page: 1, pageSize: 50 },
    });
    expect(response.ok()).toBeTruthy();
    const body = await response.json();

    const match = body.items.find((o: { id: string }) => o.id === org.id);
    expect(match, "newly-created org should appear in admin list").toBeDefined();
    expect(match.owners.length).toBe(1);
    expect(match.owners[0].email).toBe(creator.email);
    expect(match.memberCount).toBe(1);
    expect(match.isActive).toBe(true);
  });

  test("admin can transfer ownership: old owner becomes Admin, new user becomes Owner", async () => {
    const ctx = await apiContext();
    const adminToken = await adminLogin();
    const original = await registerUser("original");
    const successor = await registerUser("successor");
    const org = await createOrgAs(original);

    const transferResponse = await ctx.post(`/api/admin/organizations/${org.id}/owner`, {
      headers: { Authorization: `Bearer ${adminToken}` },
      data: { userId: successor.id },
    });
    expect(transferResponse.ok(), await transferResponse.text()).toBeTruthy();
    const transfer = await transferResponse.json();
    expect(transfer.ownerUserId).toBe(successor.id);
    expect(transfer.demotedOwnerUserIds).toContain(original.id);

    const membersResponse = await ctx.get(`/api/admin/organizations/${org.id}/members`, {
      headers: { Authorization: `Bearer ${adminToken}` },
    });
    expect(membersResponse.ok()).toBeTruthy();
    const members: Array<{ userId: string; role: string; email: string }> = (
      await membersResponse.json()
    ).members;

    const successorRow = members.find((m) => m.userId === successor.id);
    const originalRow = members.find((m) => m.userId === original.id);

    expect(successorRow, "successor should be in member list").toBeDefined();
    expect(originalRow, "original owner should still be in member list (demoted, not removed)").toBeDefined();
    expect(successorRow!.role).toBe("Owner");
    expect(originalRow!.role).toBe("Admin");
  });

  test("admin can deactivate and reactivate an organization", async () => {
    const ctx = await apiContext();
    const adminToken = await adminLogin();
    const user = await registerUser("toggle");
    const org = await createOrgAs(user);

    const deactivate = await ctx.post(`/api/admin/organizations/${org.id}/active`, {
      headers: { Authorization: `Bearer ${adminToken}` },
      data: { isActive: false },
    });
    expect(deactivate.ok()).toBeTruthy();
    expect((await deactivate.json()).isActive).toBe(false);

    // User-facing org list filters by IsActive, so the org should disappear there.
    const listAsUser = await ctx.get("/api/organizations", {
      headers: { Authorization: `Bearer ${user.accessToken}` },
    });
    expect(listAsUser.ok()).toBeTruthy();
    const userOrgs = (await listAsUser.json()) as Array<{ id: string }>;
    expect(userOrgs.find((o) => o.id === org.id)).toBeUndefined();

    const reactivate = await ctx.post(`/api/admin/organizations/${org.id}/active`, {
      headers: { Authorization: `Bearer ${adminToken}` },
      data: { isActive: true },
    });
    expect(reactivate.ok()).toBeTruthy();
    expect((await reactivate.json()).isActive).toBe(true);

    const listAgain = await ctx.get("/api/organizations", {
      headers: { Authorization: `Bearer ${user.accessToken}` },
    });
    const userOrgsAfter = (await listAgain.json()) as Array<{ id: string }>;
    expect(userOrgsAfter.find((o) => o.id === org.id)).toBeDefined();
  });

  test("admin endpoints reject requests without admin claim", async () => {
    const ctx = await apiContext();
    const regularUser = await registerUser("regular");

    const response = await ctx.get("/api/admin/organizations", {
      headers: { Authorization: `Bearer ${regularUser.accessToken}` },
    });
    expect([401, 403]).toContain(response.status());
  });
});

test.describe("admin organizations page (browser)", () => {
  test("can log in via the admin form and see the orgs table", async ({ page }) => {
    const username = process.env.ADMIN_USERNAME ?? "admin";
    const password = process.env.ADMIN_PASSWORD ?? "admin-dev-password";

    // Seed an org with a unique searchable name so we can find it on page 1 even
    // when other test runs have accumulated rows.
    const uniqueTag = `pageseed-${Date.now()}-${Math.random().toString(36).slice(2, 6)}`;
    const creator = await registerUser("pageseed");
    await createOrgAs(creator, uniqueTag);

    await page.goto("/admin");
    await page.getByLabel("Username").fill(username);
    await page.getByLabel("Password").fill(password);
    await page.getByRole("button", { name: /sign in/i }).click();

    await page.waitForURL(/\/admin\/users/);
    await page.getByRole("link", { name: "Organizations" }).click();
    await page.waitForURL(/\/admin\/organizations/);

    await expect(page.getByRole("heading", { name: /organization administration/i })).toBeVisible();

    // Narrow the table to just our seeded org so the owner email is guaranteed visible.
    await page.getByPlaceholder(/search by name or slug/i).fill(uniqueTag);
    await page.getByRole("button", { name: /search/i }).click();
    await expect(page.getByText(creator.email)).toBeVisible();
  });
});
