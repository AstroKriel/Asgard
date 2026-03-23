# Asgard (home to all of my science)

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

### Keeping everything up to date

To pull the latest changes for every submodule (this is also needed after a fresh clone), then run:

```bash
git submodule update --remote --recursive
```

If this aborts due to local changes in some of the submodules, first stash those changes:

```bash
git -C path/to/submodule stash
git submodule update --remote --recursive
git -C path/to/submodule stash pop
```
