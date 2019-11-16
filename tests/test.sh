#!/bin/bash

set -ex

bash tests/test_repository_ok.sh
bash tests/test_repository_ko.sh
