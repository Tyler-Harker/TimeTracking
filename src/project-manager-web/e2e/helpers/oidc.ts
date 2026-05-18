import { createHash, randomBytes } from "node:crypto";
import type { Page, APIRequestContext } from "@playwright/test";
import { apiContext } from "./api";
import { API_BASE_URL, WEB_BASE_URL } from "../../playwright.config";

export const PM_WEB_CLIENT_ID = "pm-web";
export const WEB_REDIRECT_URI = `${WEB_BASE_URL}/auth/callback`;
export const DEFAULT_SCOPES = "openid profile email offline_access pm_api";

export interface PkcePair {
  verifier: string;
  challenge: string;
}

function base64url(buf: Buffer): string {
  return buf.toString("base64").replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

export function generatePkce(): PkcePair {
  const verifier = base64url(randomBytes(48));
  const challenge = base64url(createHash("sha256").update(verifier).digest());
  return { verifier, challenge };
}

export function randomState(): string {
  return base64url(randomBytes(16));
}

export interface DiscoveryDoc {
  issuer: string;
  authorization_endpoint: string;
  token_endpoint: string;
  userinfo_endpoint: string;
  jwks_uri: string;
  end_session_endpoint?: string;
  response_types_supported: string[];
  grant_types_supported: string[];
  scopes_supported: string[];
  code_challenge_methods_supported: string[];
  subject_types_supported: string[];
  id_token_signing_alg_values_supported: string[];
}

export async function fetchDiscovery(ctx?: APIRequestContext): Promise<DiscoveryDoc> {
  const r = ctx ?? (await apiContext());
  const response = await r.get("/.well-known/openid-configuration");
  if (!response.ok()) throw new Error(`discovery ${response.status()}: ${await response.text()}`);
  return await response.json();
}

export interface TokenResponse {
  access_token: string;
  refresh_token?: string;
  id_token?: string;
  token_type: string;
  expires_in: number;
  scope?: string;
}

/**
 * Drives the full browser-based authorization-code + PKCE flow:
 *   1. Visit /connect/authorize → API redirects to /account/login.
 *   2. Fill the cookie-login form with the user's credentials.
 *   3. /account/login posts → cookie set → redirect back to /connect/authorize.
 *   4. /connect/authorize → redirect to redirect_uri with ?code=...&state=...
 *   5. Capture the code (we stop the browser before /auth/callback runs JS).
 *   6. POST /connect/token with grant_type=authorization_code + code_verifier.
 *
 * Returns the parsed token response. Use for round-tripping the real flow without
 * depending on the web app's callback page.
 */
export async function runAuthCodeFlow(
  page: Page,
  credentials: { email: string; password: string },
  options: { scope?: string; redirectUri?: string } = {},
): Promise<{ tokens: TokenResponse; code: string; state: string }> {
  const scope = options.scope ?? DEFAULT_SCOPES;
  const redirectUri = options.redirectUri ?? WEB_REDIRECT_URI;
  const { verifier, challenge } = generatePkce();
  const state = randomState();

  // Block the redirect to the SPA callback so we can read the code off the URL without
  // the page racing us to do its own /connect/token exchange.
  await page.route(`${redirectUri}**`, (route) => route.abort("aborted"));

  const authorizeUrl = new URL(`${API_BASE_URL}/connect/authorize`);
  authorizeUrl.searchParams.set("client_id", PM_WEB_CLIENT_ID);
  authorizeUrl.searchParams.set("response_type", "code");
  authorizeUrl.searchParams.set("redirect_uri", redirectUri);
  authorizeUrl.searchParams.set("scope", scope);
  authorizeUrl.searchParams.set("state", state);
  authorizeUrl.searchParams.set("code_challenge", challenge);
  authorizeUrl.searchParams.set("code_challenge_method", "S256");

  // navigate → eventually fails on the aborted callback. We wait for the URL to match
  // the redirect_uri pattern before that abort fires.
  const callbackPromise = page.waitForURL((url) => url.toString().startsWith(redirectUri));
  await page.goto(authorizeUrl.toString()).catch(() => {/* expected — login redirect chain */});

  // /account/login form
  await page.getByLabel("Email").fill(credentials.email);
  await page.getByLabel("Password").fill(credentials.password);
  await page.getByRole("button", { name: /sign in/i }).click();

  await callbackPromise;
  const cbUrl = new URL(page.url());
  const code = cbUrl.searchParams.get("code");
  const returnedState = cbUrl.searchParams.get("state");
  if (!code) throw new Error(`no code on callback: ${page.url()}`);
  if (returnedState !== state) throw new Error(`state mismatch: sent ${state}, got ${returnedState}`);

  await page.unroute(`${redirectUri}**`);

  // Exchange code → tokens
  const ctx = await apiContext();
  const tokenResponse = await ctx.post("/connect/token", {
    form: {
      grant_type: "authorization_code",
      code,
      redirect_uri: redirectUri,
      client_id: PM_WEB_CLIENT_ID,
      code_verifier: verifier,
    },
  });
  if (!tokenResponse.ok()) {
    throw new Error(`token exchange ${tokenResponse.status()}: ${await tokenResponse.text()}`);
  }
  const tokens = (await tokenResponse.json()) as TokenResponse;
  return { tokens, code, state };
}
