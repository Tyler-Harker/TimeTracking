# E2E tests

These run against a live Aspire stack — start it first:

```
dotnet run --project src/ProjectManager.AppHost
```

Aspire boots Postgres, the API (with dev admin creds wired up), and the Next.js web app on `:3000`. Wait until the dashboard shows all resources Running.

Then in another terminal:

```
cd src/project-manager-web
npm install                  # first time only
npx playwright install --with-deps chromium   # first time only
npm run test:e2e             # headless
npm run test:e2e:headed      # watch in a browser window
npm run test:e2e:ui          # full Playwright UI for debugging
```

## Configuration

If Aspire assigns different ports than the defaults, override with env vars:

```
WEB_BASE_URL=http://localhost:3000 \
API_BASE_URL=https://localhost:7026 \
ADMIN_USERNAME=admin \
ADMIN_PASSWORD=admin-dev-password \
npm run test:e2e
```

Defaults match the values AppHost.cs injects (`Admin__Username=admin`, `Admin__Password=admin-dev-password`) and the API's launchSettings HTTPS port (7026).
