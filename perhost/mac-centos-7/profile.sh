#!/bin/bash

if [[ -z ${SMARTPROF_DIR_PERHOST_CIP_MAC_CENTOS} ]]; then
   export SMARTPROF_DIR_PERHOST_CIP_MAC_CENTOS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
   
   source "${SMARTPROF_DIR_ROOT}/perhost/cipax-home-common/net.sh"

   alias eclipse='nohup ~/opt/eclipse/current/eclipse > /dev/null &'
   alias webstorm='nohup ~/opt/WebStorm/current/bin/webstorm.sh > /dev/null &'
   alias ats='source ~/jlg/ATS/env/profile.sh'
fi
