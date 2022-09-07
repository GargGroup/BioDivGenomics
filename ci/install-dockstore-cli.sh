#!/bin/bash

set -ex

TOP_DIR="$(dirname "${0}")/.."
# This directory is set in the GitHub Actions.
BIN_DIR="$HOME/.local/bin"

# Download the latest stable dockstore command.
mkdir -p "${BIN_DIR}"
curl -L -o "${BIN_DIR}/dockstore" \
    https://github.com/dockstore/dockstore/releases/download/1.12.2/dockstore
chmod +x "${BIN_DIR}/dockstore"
ls -l "${BIN_DIR}/dockstore"
command -v dockstore

# Copy the config file. Note the config doesn't include the token for a better
# security.
mkdir -p ~/.dockstore
cp -p ${TOP_DIR}/ci/dot_dockstore_config ~/.dockstore/config

# Upgrade the dockstore to the 1.13.0-rc.0 or later versions
# to use the `dockstore yaml` command.
dockstore --upgrade-unstable

dockstore --version
