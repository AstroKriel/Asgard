# Asgard (home to all of my science)

Asgard is the root of my science workflow, tying together my research projects (`mimir`), Python workflows (`sindri`), Julia tools (`brokkr`), and shell utilities for setting up on remote machines (`ratatosk`).

### Cloning

Asgard uses recursive Git submodules. Clone it and its submodules in one shot:

```bash
git clone --recurse-submodules git@github.com:AstroKriel/Asgard.git
cd Asgard
```

If, by mistake, you cloned without passing `--recurse-submodules`, then initialise and fetch the latest submodule changes using:

```bash
git submodule update --init --recursive
```

After cloning, submodules will be left in a detached HEAD state. I provide a few command line tools under `tools/` to help keep everything up to date:

| Script | Purpose |
|---|---|
| `show_repo_states.sh` | Shows the current branch and commit for every repo and submodule, or flags if it is in a detached HEAD state |
| `checkout_repo_defaults.sh` | Checks every submodule out onto its remote default branch (run this after cloning) |
| `update_repo_remotes.sh` | Pulls in the latest remote commits for every submodule |
| `push_repo_commits.sh` | Pushes all unpushed commits in every submodule and the root repo |

> **Note:** You should never work in a detached HEAD state; always run `checkout_repo_defaults.sh` and `update_repo_remotes.sh` after cloning or after pulling changes that update submodule pointers.

### Keeping everything up to date

To pull the latest changes for all submodules, run:

```bash
./tools/checkout_repo_defaults.sh
```

This checks each submodule out onto its remote default branch. Do this before
updating, especially after a fresh clone or after pulling root-repo changes that
move submodule pointers.

Then update all checked-out repos:

```bash
./tools/update_repo_remotes.sh
```

If a submodule has local uncommitted changes, `update_repo_remotes.sh` will skip it and flag it in the output rather than aborting, so it is always safe to run.

To push all unpushed commits across every submodule and the root repo, run:

```bash
./tools/push_repo_commits.sh
```

Submodules are pushed before the root so that no parent pointer ever references a commit that has not yet been pushed to the remote.

### File structure

```
Asgard/
├── mimir/     # research projects
├── sindri/    # Python workflows
├── brokkr/    # Julia tools
├── bragi/     # LaTeX writing templates
├── ratatoskr/ # tools for working on remote machines
└── tools/     # scripts for managing this repo
```
