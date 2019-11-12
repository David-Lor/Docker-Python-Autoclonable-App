#!/bin/bash

set -ex

docker run --rm \
    -e GIT_REPOSITORY=davidlor/python-autoclonable-app \
    --name python_helloworld \
    davidlor/python-autoclonable-app
