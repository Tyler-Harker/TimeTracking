import { test, expect } from "@playwright/test";
import { apiContext, createOrgAs, disposeApiContext, registerUser } from "./helpers/api";
import {
  DEFAULT_SCOPES,
  PM_WEB_CLIENT_ID,
  WEB_REDIRECT_URI,
  fetchDiscovery,
  generatePkce,
  randomState,
  runAuthCodeFlow,
} from "./helpers/oidc";
import { API_BASE_URL } from "../playwright.config";

test.afterAll(async () => {
  await disposeApiContext();
});

test.describe("OIDC authorization-code + PKCE", () => {
  test("full flow: authorize → cookie login → callback code → token exchange → userinfo", async ({ page }) => {
    const user = await registerUser("oidc-full");
    // Make sure they have a real org so the org claim is non-empty.
    await createOrgAs(user);

    const { tokens } = await runAuthCodeFlow(page, { email: user.email, password: user.password });

    expect(tokens.access_token, "access token issued").toBeTruthy();
    expect(tokens.refresh_token, "refresh token issued (offline_access)").toBeTruthy();
    expect(tokens.id_token, "id_token issued (openid)").toBeTruthy();
    expect(tokens.token_type.toLowerCase()).toBe("bearer");
    expect(tokens.expires_in).toBeGreaterThan(0);

    // Bearer token unlocks userinfo
    const ctx = await apiContext();
    const userinfo = await ctx.get("/connect/userinfo", {
      headers: { Authorization: `Bearer ${tokens.access_token}` },
    });
    expect(userinfo.ok(), `userinfo ${userinfo.status()}: ${await userinfo.text()}`).toBeTruthy();
    const claims = await userinfo.json();
    expect(claims.sub).toBeTruthy();
    expect(claims.email).toBe(user.email);
    expect(claims.given_name).toBe(user.firstName);
    expect(claims.family_name).toBe(user.lastName);
    expect(claims.org, "org claim populated").toBeTruthy();
  });

  test("access token from the auth-code flow is a JWT with the expected shape", async ({ page }) => {
    const user = await registerUser("oidc-jwt-shape");
    await createOrgAs(user);
    const { tokens } = await runAuthCodeFlow(page, { email: user.email, password: user.password });

    const [, payloadB64] = tokens.access_token.split(".");
    const payload = JSON.parse(Buffer.from(payloadB64, "base64url").toString("utf8"));
    expect(payload.iss).toBeTruthy();
    expect(payload.exp).toBeGreaterThan(Math.floor(Date.now() / 1000));
    expect(payload.sub).toBeTruthy();
    expect(payload.scope ?? "").toMatch(/openid/);
    // Audience should include the API resource. May be a string or an array of strings.
    const audClaim: string | string[] = payload.aud;
    const audList = Array.isArray(audClaim) ? audClaim : [audClaim];
    expect(audList).toContain("pm-api");
  });

  test("authorize without an Identity cookie bounces to /account/login", async ({ page }) => {
    const { challenge } = generatePkce();
    const state = randomState();
    const url = new URL(`${API_BASE_URL}/connect/authorize`);
    url.searchParams.set("client_id", PM_WEB_CLIENT_ID);
    url.searchParams.set("response_type", "code");
    url.searchParams.set("redirect_uri", WEB_REDIRECT_URI);
    url.searchParams.set("scope", DEFAULT_SCOPES);
    url.searchParams.set("state", state);
    url.searchParams.set("code_challenge", challenge);
    url.searchParams.set("code_challenge_method", "S256");

    await page.goto(url.toString());
    // Land on the cookie sign-in form.
    await expect(page).toHaveURL(/\/account\/login/);
    await expect(page.getByRole("heading", { name: /sign in/i })).toBeVisible();
  });

  test("authorize with a non-registered redirect_uri is rejected", async ({ request }) => {
    const doc = await fetchDiscovery();
    const { challenge } = generatePkce();
    const url = new URL(doc.authorization_endpoint);
    url.searchParams.set("client_id", PM_WEB_CLIENT_ID);
    url.searchParams.set("response_type", "code");
    url.searchParams.set("redirect_uri", "https://malicious.example.com/cb");
    url.searchParams.set("scope", "openid");
    url.searchParams.set("state", "x");
    url.searchParams.set("code_challenge", challenge);
    url.searchParams.set("code_challenge_method", "S256");

    const response = await request.get(url.toString(), { maxRedirects: 0 });
    // OpenIddict refuses unknown redirects; either a 4xx body with invalid_request,
    // or it renders an error page. Either way, no Set-Cookie issuance.
    expect(response.status()).toBeGreaterThanOrEqual(400);
    expect(response.status()).toBeLessThan(500);
  });

  test("token endpoint rejects mismatched PKCE verifier", async ({ page }) => {
    const user = await registerUser("oidc-pkce-mismatch");
    await createOrgAs(user);

    // Run the flow but capture the code instead of letting runAuthCodeFlow consume it.
    const { challenge, verifier: realVerifier } = generatePkce();
    const state = randomState();
    const authorizeUrl = new URL(`${API_BASE_URL}/connect/authorize`);
    authorizeUrl.searchParams.set("client_id", PM_WEB_CLIENT_ID);
    authorizeUrl.searchParams.set("response_type", "code");
    authorizeUrl.searchParams.set("redirect_uri", WEB_REDIRECT_URI);
    authorizeUrl.searchParams.set("scope", DEFAULT_SCOPES);
    authorizeUrl.searchParams.set("state", state);
    authorizeUrl.searchParams.set("code_challenge", challenge);
    authorizeUrl.searchParams.set("code_challenge_method", "S256");

    await page.route(`${WEB_REDIRECT_URI}**`, (r) => r.abort("aborted"));
    const callbackPromise = page.waitForURL((u) => u.toString().startsWith(WEB_REDIRECT_URI));
    await page.goto(authorizeUrl.toString()).catch(() => {});
    await page.getByLabel("Email").fill(user.email);
    await page.getByLabel("Password").fill(user.password);
    await page.getByRole("button", { name: /sign in/i }).click();
    await callbackPromise;

    const code = new URL(page.url()).searchParams.get("code");
    expect(code).toBeTruthy();

    // Close the page now — we've got everything we need. Avoids teardown stalls on
    // the in-flight aborted callback request, which can hang when the redirect
    // target is fronted by Aspire's reverse proxy.
    await page.close();

    // Send a different verifier — server must reject.
    const ctx = await apiContext();
    const bad = await ctx.post("/connect/token", {
      form: {
        grant_type: "authorization_code",
        code: code!,
        redirect_uri: WEB_REDIRECT_URI,
        client_id: PM_WEB_CLIENT_ID,
        code_verifier: realVerifier + "tampered",
      },
    });
    expect(bad.status()).toBe(400);
    const err = await bad.json();
    expect(err.error).toBe("invalid_grant");
  });
});
