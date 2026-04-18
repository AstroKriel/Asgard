#!/usr/bin/env bash
set -euo pipefail

##
## === FUNCTIONS
##

checkout_default_branch() {
    local repo_path="$1"

    ## extract the org/repo portion from the remote URL (works for both ssh and https remotes)
    local remote_url
    remote_url=$(git -C "$repo_path" remote get-url origin 2>/dev/null || echo "")
    local remote_repo_name
    remote_repo_name=$(echo "$remote_url" | sed 's|.*[:/]\([^/]*/[^/]*\)\.git|\1|')

    ## query the remote to find its default branch rather than hardcoding 'main'
    local default_branch
    default_branch=$(git -C "$repo_path" remote show origin 2>/dev/null | grep 'HEAD branch' | awk '{print $NF}')

    echo "$remote_repo_name"
    echo "  path: $repo_path"
    if [ -z "$default_branch" ] || [ "$default_branch" = "(unknown)" ]; then
        echo "  checkout: SKIPPED (could not detect default branch)"
    else
        local checkout_output
        if checkout_output=$(git -C "$repo_path" checkout "$default_branch" 2>&1); then
            if echo "$checkout_output" | grep -q "^Switched to branch"; then
                echo "  checkout: switched to $default_branch"
            else
                echo "  checkout: already on $default_branch"
            fi
            ## show any remaining git notes (e.g. ahead/behind, modified files), strip boilerplate
            echo "$checkout_output" | grep -v "^Already on\|^Switched to branch\|^Your branch is up to date\|use.*git push" | grep -v "^$" | sed 's/^/  /' || true
        else
            echo "  checkout: FAILED"
            failed_paths+=("$repo_path")
        fi
    fi
    echo ""
}

##
## === MAIN ROUTINE
##

root_dir="$(realpath "${1:-.}")"
failed_paths=()

while read -r submodule_path; do
    checkout_default_branch "$root_dir/$submodule_path"
done < <(git -C "$root_dir" submodule foreach --recursive --quiet 'echo "$displaypath"')

if [ ${#failed_paths[@]} -gt 0 ]; then
    echo "Failed to checkout default branch in:"
    for repo_path in "${failed_paths[@]}"; do
        echo "  $repo_path"
    done
fi
