# E2E tests

24 tests covering health endpoints, the OIDC server (discovery, JWKS, auth-code+PKCE, userinfo, refresh, error cases), and the admin org management feature (both API-only and browser-driven).

## Prereqs (one-time)

```
cd src/project-manager-web
npm install
npx playwright install --with-deps chromium
```

## Running

Aspire now orchestrates everything — postgres, migrator, API, and the Next.js dev server.

**Terminal 1 — Aspire (everything):**
```
ASPIRE_ALLOW_UNSECURED_TRANSPORT=true \
  dotnet run --project src/ProjectManager.AppHost --launch-profile http
```

Wait for the dashboard to show all resources Running (api, web, postgres, migrator). The web is reached via Aspire's reverse proxy on `http://localhost:3000` (proxying to whatever target port Aspire assigns Next.js internally — set via `PORT` env).

**Terminal 2 — tests:**
```
cd src/project-manager-web
API_BASE_URL=http://localhost:5154 WEB_BASE_URL=http://localhost:3000 npm run test:e2e
```

## Configuration

All env vars are optional with sensible defaults:

| var                | default                        | when to set                                  |
|--------------------|--------------------------------|----------------------------------------------|
| `WEB_BASE_URL`     | `http://localhost:3000`        | web on a different port                      |
| `API_BASE_URL`     | `https://localhost:7026`       | when using `http` launch profile, override   |
| `ADMIN_USERNAME`   | `admin`                        | matches the dev defaults from `AppHost.cs`   |
| `ADMIN_PASSWORD`   | `admin-dev-password`           | matches the dev defaults from `AppHost.cs`   |

## What's covered

**Health** (`health.spec.ts`): web `/health`, api `/health` and `/alive`, openid-configuration shape.

**OIDC discovery** (`oidc-discovery.spec.ts`): all endpoints advertised, PKCE/code/refresh grant support, JWKS returns an RS256 signing key with a `kid`.

**OIDC auth-code + PKCE** (`oidc-auth-code.spec.ts`): full browser-driven flow (authorize → cookie login → callback code capture → token exchange → userinfo); JWT shape verification on the access token; unauthenticated authorize bounces to `/account/login`; rogue `redirect_uri` rejected; tampered PKCE verifier rejected.

**OIDC userinfo** (`oidc-userinfo.spec.ts`): 401 on no token / garbage token; valid bearer returns scope-filtered claims with the right `sub`/`email`/`name`/`org`.

**OIDC refresh** (`oidc-refresh.spec.ts`): exchange yields fresh access + rotated refresh; in-leeway reuse is allowed (documents OpenIddict 6 default); garbage refresh rejected with `invalid_grant`.

**Admin orgs** (`admin-orgs.spec.ts`): admin login, list orgs (verifies a freshly-created org shows up with owner info), ownership transfer (old → Admin, new → Owner), deactivate/reactivate (verifies deactivated org disappears from the user-facing list), non-admin token rejection, and a browser-driven login + navigation through the admin UI.

## Notes

- Each test registers fresh users (timestamped emails) so runs don't collide.
- Tests share one `APIRequestContext` per spec file and dispose it in `afterAll`.
- `runAuthCodeFlow` in `helpers/oidc.ts` is the reusable building block — drives the cookie-login form, captures the code, exchanges for tokens. The callback page navigation is `route.abort`-ed so the SPA doesn't race the test for the code.
