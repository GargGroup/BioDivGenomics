#!/bin/bash

set -eu

PYTEST=$(command -v pytest-3 || command -v pytest)
echo "${PYTEST}"
