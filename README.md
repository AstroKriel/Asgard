# Asgard (home to all of my science)

Asgard is the root of my science workflow, tying together my research projects (`mimir`), Python workflows (`sindri`), Julia tools (`brokkr`), and shell utilities for setting up on remote machines (`ratatosk`).

### Cloning

Asgard uses recursive Git submodules. Clone it and its submodules in one shot:

```bash
git clone --recurse-submodules git@github.com:AstroKriel/Asgard.git
cd Asgard
```

If, by mistake, you clone without passing `--recurse-submodules`, then initialise and fetch the latest submodule changes using:

```bash
git submodule update --init --recursive
```

After cloning, submodules will be left in a detached HEAD state. I provide three useful tools under `tools/` to help inspect and keep everything up to date:

| Script | Purpose |
|---|---|
| `show_repo_states.sh` | Shows the current branch and commit for every repo and submodule, or flags if it is in a detached HEAD state |
| `checkout_repo_defaults.sh` | Checks every submodule out onto its remote default branch (run this after cloning) |
| `update_repo_remotes.sh` | Pulls in the latest remote commits for every submodule |

> **Note:** You should never work in a detached HEAD state; always run `checkout_repo_defaults.sh` after cloning or after pulling changes that update submodule pointers.

After cloning, run:

```bash
./tools/checkout_repo_defaults.sh
./tools/update_repo_remotes.sh
```

### Keeping everything up to date

To pull the latest changes for all submodules, run:

```bash
./tools/update_repo_remotes.sh
```

If a submodule has local uncommitted changes, `update_repo_remotes.sh` will skip it and flag it in the output rather than aborting, so it is always safe to run.

### Naming conventions

Multi-word folders use hyphens (`ww-quokka-sims`, `kriel-2026-ssd-nl`), except for importable Python packages which must use underscores (`ww_quokka_sims`, `sindri_cli`) since hyphens are not valid Python identifiers.

### File structure

```
Asgard/
├── mimir/     # research projects
├── sindri/    # Python workflows
├── brokkr/    # Julia tools
├── ratatosk/  # tools for working on remote machines
└── tools/     # scripts for managing this repo
```
