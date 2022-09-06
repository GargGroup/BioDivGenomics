#!/bin/bash

# The dockstore command doesn't work for the WDL file including Docker
# container on enabled SE Linux.
# https://discuss.dockstore.org/t/5857/2
if command -v getenforce > /dev/null; then
    if [ "$(getenforce)" = "Enforcing" ]; then
      echo "Lint ERROR: SE Linux is enabled." 1>&2
      exit 1
    fi
fi

exit 0
