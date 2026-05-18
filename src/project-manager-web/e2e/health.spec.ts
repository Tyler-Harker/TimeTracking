import { test, expect } from "@playwright/test";
import { API_BASE_URL, WEB_BASE_URL } from "../playwright.config";
import { apiContext, disposeApiContext } from "./helpers/api";

test.afterAll(async () => {
  await disposeApiContext();
});

test.describe("health endpoints", () => {
  test("web /health returns 200", async ({ request }) => {
    const response = await request.get(`${WEB_BASE_URL}/health`);
    expect(response.status()).toBe(200);
    expect(await response.json()).toEqual({ status: "ok" });
  });

  test("api /alive returns 200", async () => {
    const ctx = await apiContext();
    const response = await ctx.get("/alive");
    expect(response.status()).toBe(200);
  });

  test("api /health returns 200", async () => {
    const ctx = await apiContext();
    const response = await ctx.get("/health");
    expect(response.status()).toBe(200);
  });

  test("api advertises discovery document", async () => {
    const ctx = await apiContext();
    const response = await ctx.get("/.well-known/openid-configuration");
    expect(response.ok()).toBeTruthy();
    const body = await response.json();
    expect(body.issuer).toBeTruthy();
    expect(body.userinfo_endpoint).toMatch(/connect\/userinfo$/);
    expect(body.token_endpoint).toMatch(/connect\/token$/);
  });

  test("API_BASE_URL is reachable", () => {
    expect(API_BASE_URL).toMatch(/^https?:\/\//);
  });
});
