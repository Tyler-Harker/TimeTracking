import { API_BASE_URL, OIDC_CLIENT_ID, OIDC_REDIRECT_PATH, OIDC_SCOPES, OidcEndpoints } from "../api/constants";
import { tokenStorage } from "./token-storage";

const PKCE_VERIFIER_KEY = "oidc:code_verifier";
const PKCE_STATE_KEY = "oidc:state";
const PKCE_RETURN_KEY = "oidc:return_to";

export interface TokenResponse {
  access_token: string;
  refresh_token?: string;
  id_token?: string;
  token_type: string;
  expires_in: number;
}

export interface OidcUserInfo {
  sub: string;
  email?: string;
  given_name?: string;
  family_name?: string;
  name?: string;
  picture?: string;
  // Single-value claims arrive as strings, multi-value as arrays.
  org?: string[] | string;
}

function getRedirectUri(): string {
  if (typeof window === "undefined") return "";
  return `${window.location.origin}${OIDC_REDIRECT_PATH}`;
}

function base64UrlEncode(bytes: Uint8Array): string {
  let binary = "";
  for (const byte of bytes) binary += String.fromCharCode(byte);
  return btoa(binary).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

async function sha256(input: string): Promise<Uint8Array> {
  const data = new TextEncoder().encode(input);
  const digest = await crypto.subtle.digest("SHA-256", data);
  return new Uint8Array(digest);
}

function randomString(byteLength = 32): string {
  const bytes = new Uint8Array(byteLength);
  crypto.getRandomValues(bytes);
  return base64UrlEncode(bytes);
}

export async function beginOidcLogin(returnTo?: string): Promise<void> {
  if (typeof window === "undefined") return;

  const verifier = randomString(48);
  const challenge = base64UrlEncode(await sha256(verifier));
  const state = randomString(16);

  sessionStorage.setItem(PKCE_VERIFIER_KEY, verifier);
  sessionStorage.setItem(PKCE_STATE_KEY, state);
  if (returnTo) sessionStorage.setItem(PKCE_RETURN_KEY, returnTo);

  const params = new URLSearchParams({
    client_id: OIDC_CLIENT_ID,
    response_type: "code",
    redirect_uri: getRedirectUri(),
    scope: OIDC_SCOPES,
    state,
    code_challenge: challenge,
    code_challenge_method: "S256",
  });

  window.location.assign(`${API_BASE_URL}${OidcEndpoints.authorize}?${params}`);
}

export interface CompleteOidcResult {
  tokens: TokenResponse;
  userInfo: OidcUserInfo;
  returnTo: string | null;
}

export async function completeOidcLogin(code: string, state: string): Promise<CompleteOidcResult> {
  const expectedState = sessionStorage.getItem(PKCE_STATE_KEY);
  const verifier = sessionStorage.getItem(PKCE_VERIFIER_KEY);
  const returnTo = sessionStorage.getItem(PKCE_RETURN_KEY);

  if (!expectedState || expectedState !== state) {
    throw new Error("OIDC state mismatch");
  }
  if (!verifier) {
    throw new Error("OIDC code verifier missing");
  }

  sessionStorage.removeItem(PKCE_VERIFIER_KEY);
  sessionStorage.removeItem(PKCE_STATE_KEY);
  sessionStorage.removeItem(PKCE_RETURN_KEY);

  const body = new URLSearchParams({
    grant_type: "authorization_code",
    code,
    redirect_uri: getRedirectUri(),
    client_id: OIDC_CLIENT_ID,
    code_verifier: verifier,
  });

  const tokens = await postForm<TokenResponse>(OidcEndpoints.token, body);
  saveTokens(tokens);

  const userInfo = await fetchUserInfo(tokens.access_token);
  return { tokens, userInfo, returnTo };
}

export async function refreshOidcTokens(): Promise<string | null> {
  const refresh = tokenStorage.getRefreshToken();
  if (!refresh) return null;

  const body = new URLSearchParams({
    grant_type: "refresh_token",
    refresh_token: refresh,
    client_id: OIDC_CLIENT_ID,
    scope: OIDC_SCOPES,
  });

  try {
    const tokens = await postForm<TokenResponse>(OidcEndpoints.token, body);
    saveTokens(tokens);
    return tokens.access_token;
  } catch {
    return null;
  }
}

export async function fetchUserInfo(accessToken: string): Promise<OidcUserInfo> {
  const response = await fetch(`${API_BASE_URL}${OidcEndpoints.userinfo}`, {
    headers: { Authorization: `Bearer ${accessToken}` },
  });
  if (!response.ok) throw new Error(`Failed to fetch userinfo: ${response.status}`);
  return response.json();
}

export function oidcLogoutUrl(postLogoutRedirect?: string): string {
  const target = postLogoutRedirect ?? (typeof window === "undefined" ? "/" : `${window.location.origin}/`);
  const params = new URLSearchParams({ post_logout_redirect_uri: target, client_id: OIDC_CLIENT_ID });
  return `${API_BASE_URL}${OidcEndpoints.logout}?${params}`;
}

async function postForm<T>(path: string, body: URLSearchParams): Promise<T> {
  const response = await fetch(`${API_BASE_URL}${path}`, {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: body.toString(),
  });
  if (!response.ok) {
    throw new Error(`OIDC ${path} failed: ${response.status} ${await response.text()}`);
  }
  return response.json() as Promise<T>;
}

function saveTokens(tokens: TokenResponse): void {
  const expiresAt = new Date(Date.now() + tokens.expires_in * 1000).toISOString();
  tokenStorage.saveTokens(tokens.access_token, tokens.refresh_token ?? "", expiresAt);
  if (tokens.id_token) localStorage.setItem("id_token", tokens.id_token);
}

export function parseOrgClaim(orgClaims: string[] | string | undefined): Array<{ organizationId: string; role: string }> {
  if (!orgClaims) return [];
  // OpenIddict serializes a single-value claim as a string and a multi-value claim as
  // an array. Normalise to an array so callers don't have to care.
  const values = Array.isArray(orgClaims) ? orgClaims : [orgClaims];
  return values
    .map((value) => {
      const [organizationId, role] = value.split(":");
      return organizationId && role ? { organizationId, role } : null;
    })
    .filter((m): m is { organizationId: string; role: string } => m !== null);
}
