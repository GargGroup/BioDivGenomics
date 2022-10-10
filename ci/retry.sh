#!/bin/bash

set -eu

for sleep in 0 ${WAITS:- 1 25 100}; do
  sleep "$sleep"

  echo "+ $@"
  if "$@"; then
    exit 0
  fi
done

exit 1
