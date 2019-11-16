#!/bin/bash

# For master: no suffix
# For develop: -dev
# For other branches: -{branch_name}

set -ex

BRANCH_NAME="$(echo ${GITHUB_REF##*/} | sed -e 's/[^[:alnum:]|-]//g')"

if [ "${BRANCH_NAME}" == "master" ]; then
  echo ""
elif [ "${BRANCH_NAME}" == "develop" ]; then
  echo "-dev"
else
  echo "-${BRANCH_NAME}"
fi
