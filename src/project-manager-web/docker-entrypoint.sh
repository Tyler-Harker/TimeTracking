#!/bin/sh
set -e

: "${NEXT_PUBLIC_API_BASE_URL:?NEXT_PUBLIC_API_BASE_URL must be set}"

find .next -type f -name '*.js' -exec \
    sed -i "s|__NEXT_PUBLIC_API_BASE_URL__|${NEXT_PUBLIC_API_BASE_URL}|g" {} +

exec node server.js
