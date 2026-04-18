#!/usr/bin/env bash
set -euo pipefail

check_repo() {
    local path="$1"

    local remote_url
    remote_url=$(git -C "$path" remote get-url origin 2>/dev/null || echo "")
    local github_name
    github_name=$(echo "$remote_url" | sed 's|.*[:/]\([^/]*/[^/]*\)\.git|\1|')

    local branch
    branch=$(git -C "$path" branch --show-current 2>/dev/null)
    local commit
    commit=$(git -C "$path" rev-parse --short HEAD 2>/dev/null || echo "unknown")

    echo "$github_name"
    echo "  path: $path"
    if [ -z "$branch" ]; then
        echo "  DETACHED @ $commit"
    else
        echo "  branch: $branch @ $commit"
    fi
    echo ""
}

check_repo "."

git submodule foreach --recursive --quiet 'echo "$displaypath"' | while read -r submodule_path; do
    check_repo "$submodule_path"
done
