#!/bin/sh
set -e

echo "[entrypoint] pwd=$(pwd)"
echo "[entrypoint] NEXT_PUBLIC_API_BASE_URL=${NEXT_PUBLIC_API_BASE_URL:-<unset>}"

if [ -z "${NEXT_PUBLIC_API_BASE_URL}" ]; then
    echo "[entrypoint] ERROR: NEXT_PUBLIC_API_BASE_URL is not set" >&2
    exit 1
fi

echo "[entrypoint] substituting placeholder across .next/**/*.js"
find .next -type f -name '*.js' -exec \
    sed -i "s|__NEXT_PUBLIC_API_BASE_URL__|${NEXT_PUBLIC_API_BASE_URL}|g" {} +

echo "[entrypoint] launching node server.js"
exec node server.js
