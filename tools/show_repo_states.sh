#!/usr/bin/env bash
set -euo pipefail

##
## === FUNCTIONS
##

report_repo_state() {
    local repo_path="$1"

    ## extract the org/repo portion from the remote URL (works for both ssh and https remotes)
    local remote_url
    remote_url=$(git -C "$repo_path" remote get-url origin 2>/dev/null || echo "")
    local remote_repo_name
    remote_repo_name=$(echo "$remote_url" | sed 's|.*[:/]\([^/]*/[^/]*\)\.git|\1|')

    local current_branch
    current_branch=$(git -C "$repo_path" branch --show-current 2>/dev/null)
    local current_commit
    current_commit=$(git -C "$repo_path" rev-parse --short HEAD 2>/dev/null || echo "unknown")

    echo "$remote_repo_name"
    echo "  path: $repo_path"
    if [ -z "$current_branch" ]; then
        echo "  DETACHED @ $current_commit"
    else
        local ahead_behind
        ahead_behind=$(git -C "$repo_path" rev-list --left-right --count HEAD...@{upstream} 2>/dev/null || echo "")
        if [ -n "$ahead_behind" ]; then
            local ahead behind
            ahead=$(echo "$ahead_behind" | awk '{print $1}')
            behind=$(echo "$ahead_behind" | awk '{print $2}')
            echo "  branch: $current_branch @ $current_commit (+${ahead} / -${behind})"
        else
            echo "  branch: $current_branch @ $current_commit"
        fi
    fi
    echo ""
}

##
## === MAIN ROUTINE
##

root_dir="$(realpath "${1:-.}")"

report_repo_state "$root_dir"

git -C "$root_dir" submodule foreach --recursive --quiet 'echo "$displaypath"' | while read -r submodule_path; do
    report_repo_state "$root_dir/$submodule_path"
done
