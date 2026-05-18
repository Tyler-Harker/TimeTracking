import { test, expect } from "@playwright/test";
import { apiContext, disposeApiContext } from "./helpers/api";
import { fetchDiscovery } from "./helpers/oidc";

test.afterAll(async () => {
  await disposeApiContext();
});

test.describe("OIDC discovery", () => {
  test("openid-configuration advertises required endpoints", async () => {
    const doc = await fetchDiscovery();

    expect(doc.issuer, "issuer").toBeTruthy();
    expect(doc.authorization_endpoint).toMatch(/\/connect\/authorize$/);
    expect(doc.token_endpoint).toMatch(/\/connect\/token$/);
    expect(doc.userinfo_endpoint).toMatch(/\/connect\/userinfo$/);
    expect(doc.jwks_uri).toMatch(/\/\.well-known\/jwks$/);
    expect(doc.end_session_endpoint).toMatch(/\/connect\/logout$/);
  });

  test("required PKCE and code flow capabilities are advertised", async () => {
    const doc = await fetchDiscovery();
    expect(doc.response_types_supported).toContain("code");
    expect(doc.grant_types_supported).toEqual(
      expect.arrayContaining(["authorization_code", "refresh_token", "client_credentials"]),
    );
    expect(doc.scopes_supported).toEqual(
      expect.arrayContaining(["openid", "profile", "email", "offline_access", "pm_api"]),
    );
    expect(doc.code_challenge_methods_supported).toContain("S256");
    expect(doc.id_token_signing_alg_values_supported).toContain("RS256");
  });

  test("JWKS endpoint returns at least one RS256 signing key", async () => {
    const doc = await fetchDiscovery();
    const ctx = await apiContext();
    const response = await ctx.get(new URL(doc.jwks_uri).pathname);
    expect(response.ok()).toBeTruthy();
    const body = (await response.json()) as { keys: Array<{ kty: string; alg?: string; use?: string; kid?: string }> };
    expect(body.keys.length).toBeGreaterThan(0);
    const rsa = body.keys.filter((k) => k.kty === "RSA");
    expect(rsa.length).toBeGreaterThan(0);
    // The signing key should be marked for sig use (or carry an alg of RS256).
    expect(rsa.some((k) => k.use === "sig" || k.alg === "RS256")).toBe(true);
    expect(rsa.every((k) => typeof k.kid === "string" && k.kid.length > 0)).toBe(true);
  });
});
