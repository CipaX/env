#!/bin/bash

function _csProfMain()
{
   source "${CSPROF_DIR_ROOT}/common/gen_linux/profile.sh"
   source "${CSPROF_DIR_ROOT}/common/gen_devel/profile.sh"

   HOSTNAME_PROFILE="${CSPROF_DIR_ROOT}/perhost/${HOSTNAME}/profile.sh"
   if [ -f ${HOSTNAME_PROFILE} ]; then
      echo "### Loading profile for hostname [${HOSTNAME}]."
      source ${HOSTNAME_PROFILE}
      export PATH="${CSPROF_DIR_ROOT}/perhost/${HOSTNAME}/bin":$PATH
   else
      echo "### There is no profile for hostname [${HOSTNAME}]."
   fi
}

if [[ -z ${CSPROF_DIR_ROOT} ]]; then
   export CSPROF_DIR_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

   HOSTNAME=$(hostname)
   ROOT_HOSTNAME="Ciprians-iMac.local"

   if [ -n "$PS1" ]; then
      IS_INTERACTIVE=1
   else
      IS_INTERACTIVE=0
   fi

   if [ $IS_INTERACTIVE == 1 ]; then
      _csProfMain
   else
      _csProfMain > /dev/null
   fi
fi
