#!/usr/bin/env bash
set -euo pipefail

##
## === FUNCTIONS
##

push_repo() {
    local repo_path="$1"

    ## extract the org/repo portion from the remote URL (works for both ssh and https remotes)
    local remote_url
    remote_url=$(git -C "$repo_path" remote get-url origin 2>/dev/null || echo "")
    local remote_repo_name
    remote_repo_name=$(echo "$remote_url" | sed 's|.*[:/]\([^/]*/[^/]*\)\.git|\1|')

    echo "$remote_repo_name"
    echo "  path: $repo_path"

    ## skip detached HEAD — no branch to push to
    local current_branch
    current_branch=$(git -C "$repo_path" branch --show-current 2>/dev/null)
    if [ -z "$current_branch" ]; then
        echo "  push: SKIPPED (detached HEAD)"
        echo ""
        return
    fi

    ## skip if no upstream is configured
    if ! git -C "$repo_path" rev-parse "@{u}" &>/dev/null; then
        echo "  push: SKIPPED (no upstream set for '$current_branch')"
        echo ""
        return
    fi

    ## check for unpushed commits
    local unpushed_commits
    unpushed_commits=$(git -C "$repo_path" log @{u}..HEAD --oneline 2>/dev/null)
    if [ -z "$unpushed_commits" ]; then
        echo "  push: already up to date"
        echo ""
        return
    fi

    ## push and report each commit that was sent
    local push_output
    if push_output=$(git -C "$repo_path" push 2>&1); then
        echo "  push: pushed commits"
        echo "$unpushed_commits" | sed 's/^/    /' || true
    else
        echo "  push: FAILED"
        echo "$push_output" | grep -v "^$" | sed 's/^/  /' || true
        failed_paths+=("$repo_path")
    fi
    echo ""
}

##
## === MAIN ROUTINE
##

root_dir="$(realpath "${1:-.}")"
failed_paths=()

## submodules first (depth-first = leaves before parents), then the root repo
while read -r submodule_path; do
    push_repo "$root_dir/$submodule_path"
done < <(git -C "$root_dir" submodule foreach --recursive --quiet 'echo "$displaypath"')

push_repo "$root_dir"

if [ ${#failed_paths[@]} -gt 0 ]; then
    echo "Failed to push in:"
    for repo_path in "${failed_paths[@]}"; do
        echo "  $repo_path"
    done
fi
