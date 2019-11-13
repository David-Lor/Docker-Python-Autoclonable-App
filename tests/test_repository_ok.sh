#!/bin/bash

IMAGE_NAME="python-autoclonable-app-test"
GIT_REPOSITORY="https://github.com/David-Lor/Python-HelloWorld"

set -ex

bash build.sh

docker run --rm -e GIT_REPOSITORY=${GIT_REPOSITORY} ${IMAGE_NAME}:${IMAGE_TAG} \
    && echo "Successful test!" \
    || { echo "Failed test!"; exit 1; }
