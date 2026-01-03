#!/usr/bin/env bash 

set -e

SCRIPT_ROOT="$(realpath "$(dirname "$0")")"

if [[ -z "$1" ]]; then
    echo "Usage: $(basename "$0") <project type>"
    exit 1
fi

PROJECT_TYPE="$(basename "$1")"

if [[ ! -e "${SCRIPT_ROOT}/${PROJECT_TYPE}-shell.nix" ]]; then
    echo "Error: Could not find shell.nix for project type $PROJECT_TYPE"
    exit 1
fi

cp "${SCRIPT_ROOT}/flake-template.nix" flake.nix
cp "${SCRIPT_ROOT}/${PROJECT_TYPE}-shell.nix" shell.nix
cp "${SCRIPT_ROOT}/envrc" .envrc
direnv allow .


