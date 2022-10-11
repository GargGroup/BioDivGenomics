#!/bin/bash

set -ex

CROMWELL_VERSION=77

wget https://github.com/broadinstitute/cromwell/releases/download/${CROMWELL_VERSION}/cromwell-${CROMWELL_VERSION}.jar \
    -O vendor/cromwell/cromwell-${CROMWELL_VERSION}.jar
