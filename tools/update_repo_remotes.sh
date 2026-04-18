#!/usr/bin/env bash
set -euo pipefail

##
## === FUNCTIONS
##

update_repo() {
    local repo_path="$1"

    ## extract the org/repo portion from the remote URL (works for both ssh and https remotes)
    local remote_url
    remote_url=$(git -C "$repo_path" remote get-url origin 2>/dev/null || echo "")
    local remote_repo_name
    remote_repo_name=$(echo "$remote_url" | sed 's|.*[:/]\([^/]*/[^/]*\)\.git|\1|')

    local pull_output
    echo "$remote_repo_name"
    echo "  path: $repo_path"
    if pull_output=$(git -C "$repo_path" pull --ff-only 2>&1); then
        if echo "$pull_output" | grep -q "^Already up to date"; then
            echo "  update: already up to date"
        else
            ## show the new commit(s) that were pulled in
            echo "  update: pulled new commits"
            echo "$pull_output" | grep -v "^$" | sed 's/^/  /' || true
        fi
    else
        ## likely detached HEAD or merge conflict — surface the error
        echo "  update: FAILED"
        echo "$pull_output" | grep -v "^$" | sed 's/^    /  /' || true
    fi
    echo ""
}

##
## === MAIN ROUTINE
##

root_dir="$(realpath "${1:-.}")"

update_repo "$root_dir"

git -C "$root_dir" submodule foreach --recursive --quiet 'echo "$displaypath"' | while read -r submodule_path; do
    update_repo "$root_dir/$submodule_path"
done
