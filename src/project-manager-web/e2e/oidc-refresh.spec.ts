import { test, expect } from "@playwright/test";
import { apiContext, createOrgAs, disposeApiContext, registerUser } from "./helpers/api";
import { DEFAULT_SCOPES, PM_WEB_CLIENT_ID, runAuthCodeFlow } from "./helpers/oidc";

test.afterAll(async () => {
  await disposeApiContext();
});

test.describe("OIDC refresh token", () => {
  test("exchanging a refresh token yields a fresh access token", async ({ page }) => {
    const user = await registerUser("oidc-refresh");
    await createOrgAs(user);
    const { tokens: initial } = await runAuthCodeFlow(page, { email: user.email, password: user.password });
    expect(initial.refresh_token, "must be issued with offline_access").toBeTruthy();

    const ctx = await apiContext();
    const refreshed = await ctx.post("/connect/token", {
      form: {
        grant_type: "refresh_token",
        refresh_token: initial.refresh_token!,
        client_id: PM_WEB_CLIENT_ID,
        scope: DEFAULT_SCOPES,
      },
    });
    expect(refreshed.ok(), `${refreshed.status()}: ${await refreshed.text()}`).toBeTruthy();
    const next = await refreshed.json();

    expect(next.access_token).toBeTruthy();
    expect(next.access_token).not.toBe(initial.access_token);
    expect(next.token_type.toLowerCase()).toBe("bearer");
    // OpenIddict rotates refresh tokens by default.
    expect(next.refresh_token).toBeTruthy();
  });

  test("rotation issues a new refresh token AND the rotated-from token keeps working inside the leeway window", async ({ page }) => {
    const user = await registerUser("oidc-refresh-rotation");
    await createOrgAs(user);
    const { tokens: initial } = await runAuthCodeFlow(page, { email: user.email, password: user.password });
    const ctx = await apiContext();

    const first = await ctx.post("/connect/token", {
      form: {
        grant_type: "refresh_token",
        refresh_token: initial.refresh_token!,
        client_id: PM_WEB_CLIENT_ID,
        scope: DEFAULT_SCOPES,
      },
    });
    expect(first.ok()).toBeTruthy();
    const firstBody = await first.json();
    expect(firstBody.refresh_token, "rotation issues a new refresh token").toBeTruthy();
    expect(firstBody.refresh_token).not.toBe(initial.refresh_token);

    // OpenIddict 6 keeps the rotated-from refresh token usable inside a short reuse
    // leeway (default 15s). This is deliberate — protects against network race
    // conditions where the client never receives the rotated token. Verify the
    // behavior so a future config change to a stricter policy surfaces here.
    const reused = await ctx.post("/connect/token", {
      form: {
        grant_type: "refresh_token",
        refresh_token: initial.refresh_token!,
        client_id: PM_WEB_CLIENT_ID,
        scope: DEFAULT_SCOPES,
      },
    });
    expect(reused.ok(), "in-leeway reuse is allowed by default").toBeTruthy();
  });

  test("refresh with a garbage token fails", async () => {
    const ctx = await apiContext();
    const response = await ctx.post("/connect/token", {
      form: {
        grant_type: "refresh_token",
        refresh_token: "completely-bogus",
        client_id: PM_WEB_CLIENT_ID,
        scope: DEFAULT_SCOPES,
      },
    });
    expect(response.status()).toBe(400);
    const body = await response.json();
    expect(body.error).toBe("invalid_grant");
  });
});
