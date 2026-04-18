# Asgard (home to all of my science)

### Naming conventions

Folders use hyphens (`my-project`, `ww-flash-sims`) except where Python requires underscores. Specifically:

- Importable Python packages must use underscores (`ww_flash_sims`, `sindri_cli`) because hyphens are not valid Python identifiers
- Everything else — repo names, submodule paths, project directories — uses hyphens

### Cloning

Asgard uses recursive Git submodules. Clone it and its submodules in one shot:

```bash
git clone --recurse-submodules git@github.com:AstroKriel/Asgard.git
cd Asgard
```

If you clone without passing `--recurse-submodules`, then initialise and fetch the latest submodule changes using:

```bash
git submodule update --init --recursive
```

Either way, submodules will be left in a detached HEAD state after cloning. To put all submodules (including nested ones) on their default branch, run from the repo root:

```bash
./tools/checkout_default_branches.sh
```

> **Note:** Never work in a detached HEAD state — always run this after cloning or updating.

To inspect the state of every repo and submodule (branch, commit, or detached):

```bash
./tools/show_repo_states.sh
```

### Keeping everything up to date

To pull the latest changes for every submodule (this is also needed after a fresh clone), run:

```bash
git submodule update --remote --recursive
```

If this aborts because there are local changes in some of the submodules, then stash those changes before updating, like so:

```bash
git -C path/to/submodule stash
git submodule update --remote --recursive
git -C path/to/submodule stash pop
```
