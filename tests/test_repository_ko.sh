#!/bin/bash

IMAGE_NAME="python-autoclonable-app-test"
GIT_REPOSITORY="https://github.com/David-Lor/Python-HelloWorld"
GIT_BRANCH="requirements-fail"

set -ex

bash build.sh

docker run --rm -e GIT_REPOSITORY=${GIT_REPOSITORY} -e GIT_BRANCH=${GIT_BRANCH} ${IMAGE_NAME}:${IMAGE_TAG} \
    && { echo "Failed test!"; exit 1; } \
    || echo "Successful test!"
