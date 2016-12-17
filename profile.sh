#!/bin/bash

HOSTNAME=$(hostname)

if [ -n "$PS1" ]; then
  IS_INTERACTIVE=1
else
  IS_INTERACTIVE=0
fi


function _smartProfMain()
{
   source "${SMARTPROF_DIR_ROOT}/config.sh"
   alias pp_e_config="${SMARTPROF_EDITOR} ${SMARTPROF_DIR_ROOT}/config.sh &"

   SMARTPROF_REMOTE_USER_SUBDIR=${SMARTPROF_REMOTE_USER_SUBDIR:-${SMARTPROF_ROOT_HOSTNAME}}

   source "${SMARTPROF_DIR_ROOT}/common/gen_unix/profile.sh"
   source "${SMARTPROF_DIR_ROOT}/common/gen_devel/profile.sh"

   SMARTPROF_HOSTNAME_PROFILE="${SMARTPROF_DIR_ROOT}/perhost/${HOSTNAME}/profile.sh"
   if [ -f ${SMARTPROF_HOSTNAME_PROFILE} ]; then
      echo "### Loading profile for hostname [${HOSTNAME}]."
      source ${SMARTPROF_HOSTNAME_PROFILE}
      export PATH="${SMARTPROF_DIR_ROOT}/perhost/${HOSTNAME}/bin":$PATH
   else
      echo "### There is no profile for hostname [${HOSTNAME}]."
   fi

   function xx_help()
   {
      gen_unix_help
      gen_devel_help

      if [[ -n "$(type -t perhost_help)" ]]; then
         perhost_help
      fi
   }   
}

if [[ -z ${SMARTPROF_DIR_ROOT} ]]; then
   export SMARTPROF_DIR_ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

   if [ $IS_INTERACTIVE == 1 ]; then
      _smartProfMain
   else
      _smartProfMain > /dev/null
   fi

   # Alias defined at the end, because the ${SMARTPROF_EDITOR} is missing before.
   alias pp_e_root="${SMARTPROF_EDITOR} ${BASH_SOURCE[0]} &"
fi
