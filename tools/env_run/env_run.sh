#!/bin/bash

source ${HOME}/.bash_profile

echo "=========================================="
echo "$(date '+%Y-%m-%d %H:%M:%S') > ${HOME}/.bash_profile"
echo "> $@"

"$@"

echo "------------------------------------------"
