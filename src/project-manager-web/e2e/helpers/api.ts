import { request as playwrightRequest, APIRequestContext } from "@playwright/test";
import { API_BASE_URL } from "../../playwright.config";

export interface RegisteredUser {
  id: string;
  email: string;
  password: string;
  firstName: string;
  lastName: string;
  accessToken: string;
}

let sharedContext: APIRequestContext | null = null;

export async function apiContext(): Promise<APIRequestContext> {
  if (sharedContext) return sharedContext;
  sharedContext = await playwrightRequest.newContext({
    baseURL: API_BASE_URL,
    ignoreHTTPSErrors: true,
  });
  return sharedContext;
}

export async function disposeApiContext(): Promise<void> {
  if (sharedContext) {
    await sharedContext.dispose();
    sharedContext = null;
  }
}

function uniqueEmail(prefix: string): string {
  // Add timestamp + random suffix so concurrent runs don't collide on
  // RequireUniqueEmail.
  const random = Math.random().toString(36).slice(2, 8);
  return `${prefix}-${Date.now()}-${random}@e2e.local`;
}

const TEST_PASSWORD = "TestPass123";

export async function registerUser(prefix: string = "user"): Promise<RegisteredUser> {
  const ctx = await apiContext();
  const email = uniqueEmail(prefix);
  const firstName = "Test";
  const lastName = prefix;

  const registerResponse = await ctx.post("/api/auth/register", {
    data: { email, password: TEST_PASSWORD, firstName, lastName },
  });
  if (!registerResponse.ok()) {
    throw new Error(`register failed: ${registerResponse.status()} ${await registerResponse.text()}`);
  }
  const { userId } = (await registerResponse.json()) as { userId: string };

  // Register returns { userId, email } — no tokens. Follow up with /api/auth/login
  // to get a legacy HS256 JWT we can use as Bearer for subsequent requests.
  const loginResponse = await ctx.post("/api/auth/login", {
    data: { email, password: TEST_PASSWORD },
  });
  if (!loginResponse.ok()) {
    throw new Error(`login failed after register: ${loginResponse.status()} ${await loginResponse.text()}`);
  }
  const { token } = (await loginResponse.json()) as { token: string };

  return { id: userId, email, password: TEST_PASSWORD, firstName, lastName, accessToken: token };
}

export interface CreatedOrg {
  id: string;
  name: string;
  slug: string;
}

export async function createOrgAs(user: RegisteredUser, name?: string): Promise<CreatedOrg> {
  const ctx = await apiContext();
  const orgName = name ?? `E2E Org ${Date.now()}`;

  const response = await ctx.post("/api/organizations", {
    headers: { Authorization: `Bearer ${user.accessToken}` },
    data: { name: orgName, description: "Created by Playwright", defaultBillableRate: 0 },
  });
  if (!response.ok()) {
    throw new Error(`create org failed: ${response.status()} ${await response.text()}`);
  }
  return await response.json();
}

export async function adminLogin(): Promise<string> {
  const ctx = await apiContext();
  const username = process.env.ADMIN_USERNAME ?? "admin";
  const password = process.env.ADMIN_PASSWORD ?? "admin-dev-password";
  const response = await ctx.post("/api/admin/login", {
    data: { username, password },
  });
  if (!response.ok()) {
    throw new Error(
      `admin login failed (${response.status()}): are Admin__Enabled/Username/Password set on the API? ${await response.text()}`,
    );
  }
  const body = await response.json();
  return body.token as string;
}
