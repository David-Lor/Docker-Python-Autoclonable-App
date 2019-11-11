#!/bin/bash

set -ex

cd $HOME
python -u /setup_app.py
python -u ${APP_NAME}
