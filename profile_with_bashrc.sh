#!/bin/bash

if [ -f ~/.bashrc ]; then
   source ~/.bashrc
else
   echo "### Warning. .bashrc not found."
fi

CSPROF_DIR_ROOT_TMP="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ -f "${CSPROF_DIR_ROOT_TMP}/profile.sh" ]; then
   source "${CSPROF_DIR_ROOT_TMP}/profile.sh"
else
   echo "### Error. Special profile does not exist."
fi

