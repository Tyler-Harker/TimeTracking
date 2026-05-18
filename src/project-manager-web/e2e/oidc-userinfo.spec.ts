import { test, expect } from "@playwright/test";
import { apiContext, createOrgAs, disposeApiContext, registerUser } from "./helpers/api";
import { runAuthCodeFlow } from "./helpers/oidc";

test.afterAll(async () => {
  await disposeApiContext();
});

test.describe("OIDC userinfo", () => {
  test("returns 401 with no Authorization header", async () => {
    const ctx = await apiContext();
    const response = await ctx.get("/connect/userinfo");
    expect(response.status()).toBe(401);
  });

  test("returns 401 with a syntactically invalid bearer token", async () => {
    const ctx = await apiContext();
    const response = await ctx.get("/connect/userinfo", {
      headers: { Authorization: "Bearer not-a-real-jwt" },
    });
    expect(response.status()).toBe(401);
  });

  test("returns scope-filtered claims with a valid bearer token", async ({ page }) => {
    const user = await registerUser("oidc-uinfo-claims");
    await createOrgAs(user);
    const { tokens } = await runAuthCodeFlow(page, { email: user.email, password: user.password });

    const ctx = await apiContext();
    const response = await ctx.get("/connect/userinfo", {
      headers: { Authorization: `Bearer ${tokens.access_token}` },
    });
    expect(response.ok()).toBeTruthy();
    const claims = (await response.json()) as Record<string, unknown>;

    expect(claims.sub).toBe(user.id);
    // email + profile scopes were granted, so these should be present.
    expect(claims.email).toBe(user.email);
    expect(claims.email_verified).toBeDefined();
    expect(claims.given_name).toBe(user.firstName);
    expect(claims.family_name).toBe(user.lastName);
    expect(claims.name).toBe(`${user.firstName} ${user.lastName}`);
    // org claim follows the orgId:Role string convention.
    const orgs = Array.isArray(claims.org) ? claims.org : claims.org ? [claims.org] : [];
    expect(orgs.length).toBeGreaterThanOrEqual(1);
    expect(typeof orgs[0]).toBe("string");
    expect(String(orgs[0])).toMatch(/^[0-9a-f-]+:(Owner|Admin|Member)$/i);
  });
});
