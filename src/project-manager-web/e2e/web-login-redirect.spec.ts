import { test, expect } from "@playwright/test";
import { disposeApiContext } from "./helpers/api";

const TEST_PASSWORD = "TestPass123";

function uniqueEmail(prefix: string): string {
  const r = Math.random().toString(36).slice(2, 8);
  return `${prefix}-${Date.now()}-${r}@e2e.local`;
}

test.afterAll(async () => {
  await disposeApiContext();
});

test.describe("post-login redirect (full browser flow)", () => {
  // Regression guard for the bug where the callback page stayed at /auth/callback
  // after a successful token exchange. Root cause was concurrent re-mounts of the
  // callback page calling completeOidcCallback repeatedly — each invocation reset
  // status to "loading", so the .then redirect saw the wrong state. Fix is module-
  // level dedup of in-flight (code, state) tuples in the auth store.
  test("after login, user is redirected off /auth/callback to a real page", async ({ page }) => {
    const email = uniqueEmail("redirect");

    // Land on the SPA root — AuthGuard bounces us to /connect/authorize → /account/login.
    await page.goto("/");
    await page.waitForURL(/\/account\/login/, { timeout: 15_000 });

    // Use the API register page to create the user inside the OIDC flow.
    await page.getByRole("link", { name: /create an account/i }).click();
    await page.waitForURL(/\/account\/register/);
    await page.getByLabel("First name").fill("Redirect");
    await page.getByLabel("Last name").fill("Test");
    await page.getByLabel("Email").fill(email);
    await page.getByLabel("Password").fill(TEST_PASSWORD);
    await page.getByRole("button", { name: /create account/i }).click();

    // Should pass through /auth/callback and land on /organizations (zero-org user).
    await page.waitForURL((u) => {
      const path = new URL(u).pathname;
      return path === "/organizations" || path.startsWith("/organizations/");
    }, { timeout: 15_000 });

    expect(new URL(page.url()).pathname).not.toMatch(/\/auth\/callback$/);
  });
});
