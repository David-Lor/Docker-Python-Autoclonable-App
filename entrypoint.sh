#!/bin/sh

set -ex

python -u /setup_app.py
python -u ${APP_NAME}
