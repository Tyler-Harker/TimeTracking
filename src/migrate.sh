#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
API_PROJECT="$SCRIPT_DIR/ProjectManager.Api"

echo "=== EF Core Migration Helper ==="
echo ""

# Check for pending model changes
echo "Checking for pending model changes..."
if dotnet ef migrations has-pending-model-changes --project "$API_PROJECT" 2>/dev/null; then
    echo "Pending model changes detected!"
    echo ""
    read -rp "Enter migration name: " migration_name

    if [[ -z "$migration_name" ]]; then
        echo "Error: Migration name cannot be empty."
        exit 1
    fi

    echo "Adding migration: $migration_name"
    dotnet ef migrations add "$migration_name" --project "$API_PROJECT"
    echo ""
    echo "Migration '$migration_name' created successfully."
else
    echo "No pending model changes."
fi

echo ""
echo "=== Current Migrations ==="
dotnet ef migrations list --project "$API_PROJECT"
