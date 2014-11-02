#!/bin/bash

export SMART_ENV_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" > /dev/null  && pwd )"

export SMART_ENV_USER_DIR="${SMART_ENV_DIR}/cstan"

source "${SMART_ENV_USER_DIR}/main.sh"
