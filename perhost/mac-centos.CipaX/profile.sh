#!/bin/bash

if [[ -z ${CSPROF_DIR_PERHOST_CIP_MAC_CENTOS} ]]; then
   export CSPROF_DIR_PERHOST_CIP_MAC_CENTOS="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
   
   source /opt/rh/devtoolset-2/enable

   alias ss_mac='ss_prof ciprian@192.168.1.50'

   alias eclipse='nohup ~/opt/eclipse/current/eclipse > /dev/null &'
   alias webstorm='nohup ~/opt/WebStorm/current/bin/webstorm.sh > /dev/null &'
   alias ats='source ~/jlg/ATS/env/profile.sh'
fi
