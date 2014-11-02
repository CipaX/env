#!/bin/bash

if [[ -z ${CSPROF_DIR_PERHOST_CIP_MAC} ]]; then
   export CSPROF_DIR_PERHOST_CIP_MAC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

   source ${CSPROF_DIR_PERHOST_CIP_MAC}/env_bootstrap.sh
   
   alias ss_centos='ss_prof cstan@192.168.1.150'
   alias ats='source ~/01-prog/jlg/ATS/env/profile.sh'
fi
