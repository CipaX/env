#!/bin/bash

if [[ -z ${SMARTPROF_DIR_PERHOST_CIP_NAS} ]]; then
   export SMARTPROF_DIR_PERHOST_CIP_NAS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

   alias ll='ls -l'
fi
