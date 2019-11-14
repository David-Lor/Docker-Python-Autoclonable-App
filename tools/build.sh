#!/bin/bash

if [ ! -e "Dockerfile" ]; then
    echo "Invalid directory! Dockerfile not found!"
    exit 1
fi

test "${BASE_IMAGE_TAG}" || { echo "Base Image Tag undefined!"; exit 1; }
test "${IMAGE_NAME}" || { echo "Image Name undefined!"; exit 1; }
test "${IMAGE_TAG}" || { echo "Image Tag undefined!"; exit 1; }

set -ex

docker build . --build-arg IMAGE_TAG="${BASE_IMAGE_TAG}" -t "${IMAGE_NAME}:${IMAGE_TAG}"
