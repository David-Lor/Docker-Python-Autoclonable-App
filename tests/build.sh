#!/bin/bash

IMAGE_NAME="python-autoclonable-app-test"

test "$(pwd | sed 's#.*/##')" == "tests" || { echo "Directory invalid! Current directory must be \"tests\"!"; exit 1; }
set -ex

docker build ../. --build-arg IMAGE_TAG="${IMAGE_TAG}" -t "${IMAGE_NAME}:${IMAGE_TAG}"
