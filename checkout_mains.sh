#!/usr/bin/env bash
set -euo pipefail

git submodule foreach --recursive 'git checkout main'
