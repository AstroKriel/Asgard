#!/usr/bin/env bash
set -euo pipefail

check_repo() {
    local path="$1"
    local branch
    branch=$(git -C "$path" branch --show-current 2>/dev/null)
    if [ -z "$branch" ]; then
        echo "  DETACHED: $path"
    fi
}

check_repo "."

git submodule foreach --recursive --quiet 'echo "$displaypath"' | while read -r submodule_path; do
    check_repo "$submodule_path"
done

echo "Done."
