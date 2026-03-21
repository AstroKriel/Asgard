# Asgard (home to all of my science)

All commands should be run from the **Asgard root**.

## Cloning

Asgard is a nested submodule tree. Clone it with all submodules in one shot:

```bash
git clone --recurse-submodules git@github.com:AstroKriel/Asgard.git
cd Asgard
```

If you already cloned without `--recurse-submodules`, initialise and fetch everything after the fact:

```bash
git submodule update --init --recursive
```

## Keeping everything up to date

To pull the latest `main` for every submodule (including after a fresh clone):

```bash
git submodule update --remote --recursive
```

If it aborts due to local changes in a submodule, stash them first:

```bash
git -C path/to/submodule stash
git submodule update --remote --recursive
git -C path/to/submodule stash pop
```
