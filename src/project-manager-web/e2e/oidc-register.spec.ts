import { test, expect } from "@playwright/test";
import { apiContext, disposeApiContext } from "./helpers/api";
import {
  DEFAULT_SCOPES,
  PM_WEB_CLIENT_ID,
  WEB_REDIRECT_URI,
  generatePkce,
  randomState,
} from "./helpers/oidc";
import { API_BASE_URL } from "../playwright.config";

test.afterAll(async () => {
  await disposeApiContext();
});

const TEST_PASSWORD = "TestPass123";

function uniqueEmail(prefix: string): string {
  const r = Math.random().toString(36).slice(2, 8);
  return `${prefix}-${Date.now()}-${r}@e2e.local`;
}

test.describe("OIDC sign-up via /account/register", () => {
  test("register form is reachable from the login page", async ({ page }) => {
    await page.goto(`${API_BASE_URL}/account/login?returnUrl=%2F`);
    await page.getByRole("link", { name: /create an account/i }).click();
    await expect(page).toHaveURL(/\/account\/register/);
    await expect(page.getByRole("heading", { name: /create your account/i })).toBeVisible();
    await expect(page.getByLabel("First name")).toBeVisible();
    await expect(page.getByLabel("Last name")).toBeVisible();
    await expect(page.getByLabel("Email")).toBeVisible();
    await expect(page.getByLabel("Password")).toBeVisible();
  });

  test("registering a new account inside the OIDC flow completes the auth-code exchange", async ({ page }) => {
    const email = uniqueEmail("oidc-reg-flow");
    const { verifier, challenge } = generatePkce();
    const state = randomState();

    // Block the final redirect to the SPA callback so we can read the code off the URL.
    await page.route(`${WEB_REDIRECT_URI}**`, (route) => route.abort("aborted"));

    const authorizeUrl = new URL(`${API_BASE_URL}/connect/authorize`);
    authorizeUrl.searchParams.set("client_id", PM_WEB_CLIENT_ID);
    authorizeUrl.searchParams.set("response_type", "code");
    authorizeUrl.searchParams.set("redirect_uri", WEB_REDIRECT_URI);
    authorizeUrl.searchParams.set("scope", DEFAULT_SCOPES);
    authorizeUrl.searchParams.set("state", state);
    authorizeUrl.searchParams.set("code_challenge", challenge);
    authorizeUrl.searchParams.set("code_challenge_method", "S256");

    const callbackPromise = page.waitForURL((u) => u.toString().startsWith(WEB_REDIRECT_URI));

    // Authorize without a cookie → /account/login (preserving returnUrl).
    await page.goto(authorizeUrl.toString()).catch(() => {/* expected */});
    await expect(page).toHaveURL(/\/account\/login/);

    // Switch to the register form. The link carries returnUrl through.
    await page.getByRole("link", { name: /create an account/i }).click();
    await expect(page).toHaveURL(/\/account\/register/);

    // Submit registration → user created → cookie set → redirect back into /connect/authorize → callback.
    await page.getByLabel("First name").fill("OIDC");
    await page.getByLabel("Last name").fill("Reg");
    await page.getByLabel("Email").fill(email);
    await page.getByLabel("Password").fill(TEST_PASSWORD);
    await page.getByRole("button", { name: /create account/i }).click();

    await callbackPromise;
    const cb = new URL(page.url());
    const code = cb.searchParams.get("code");
    const returnedState = cb.searchParams.get("state");
    expect(code, "callback received an authorization code").toBeTruthy();
    expect(returnedState).toBe(state);

    await page.close();

    // Exchange the code for tokens to prove the issued account+session is valid end-to-end.
    const ctx = await apiContext();
    const tokenResponse = await ctx.post("/connect/token", {
      form: {
        grant_type: "authorization_code",
        code: code!,
        redirect_uri: WEB_REDIRECT_URI,
        client_id: PM_WEB_CLIENT_ID,
        code_verifier: verifier,
      },
    });
    expect(tokenResponse.ok(), `token exchange ${tokenResponse.status()}: ${await tokenResponse.text()}`).toBeTruthy();
    const tokens = await tokenResponse.json();
    expect(tokens.access_token).toBeTruthy();
    expect(tokens.refresh_token).toBeTruthy();

    // userinfo confirms the newly-registered user's claims came through.
    const info = await ctx.get("/connect/userinfo", {
      headers: { Authorization: `Bearer ${tokens.access_token}` },
    });
    expect(info.ok()).toBeTruthy();
    const claims = await info.json();
    expect(claims.email).toBe(email);
    expect(claims.given_name).toBe("OIDC");
    expect(claims.family_name).toBe("Reg");
  });

  test("registering with a duplicate email is rejected", async ({ page }) => {
    const email = uniqueEmail("oidc-reg-dupe");
    const ctx = await apiContext();

    // Seed the user via the JSON API first.
    const seed = await ctx.post("/api/auth/register", {
      data: { email, password: TEST_PASSWORD, firstName: "Seed", lastName: "User" },
    });
    expect(seed.ok()).toBeTruthy();

    await page.goto(`${API_BASE_URL}/account/register?returnUrl=%2F`);
    await page.getByLabel("First name").fill("Dup");
    await page.getByLabel("Last name").fill("Attempt");
    await page.getByLabel("Email").fill(email);
    await page.getByLabel("Password").fill(TEST_PASSWORD);
    await page.getByRole("button", { name: /create account/i }).click();

    // The form re-renders inline; the error text is shown and we're still on /account/register.
    await expect(page).toHaveURL(/\/account\/register/);
    await expect(page.getByText(/already exists/i)).toBeVisible();
    // Field values should be preserved so the user doesn't have to re-type.
    await expect(page.getByLabel("Email")).toHaveValue(email);
  });

  test("registering with a too-short password surfaces the Identity error inline", async ({ page }) => {
    const email = uniqueEmail("oidc-reg-shortpw");
    await page.goto(`${API_BASE_URL}/account/register?returnUrl=%2F`);
    await page.getByLabel("First name").fill("Short");
    await page.getByLabel("Last name").fill("Pass");
    await page.getByLabel("Email").fill(email);
    // 7 chars: below the 8-char Identity minimum configured in Program.cs.
    // The browser's HTML5 minlength=8 attribute blocks submit, so we evaluate by clearing the attribute.
    await page.evaluate(() => {
      const pw = document.getElementById("password") as HTMLInputElement | null;
      if (pw) pw.removeAttribute("minlength");
    });
    await page.getByLabel("Password").fill("Short1A");
    await page.getByRole("button", { name: /create account/i }).click();

    await expect(page).toHaveURL(/\/account\/register/);
    // The exact Identity message is "Passwords must be at least 8 characters."
    await expect(page.getByText(/at least 8 characters/i)).toBeVisible();
  });
});
