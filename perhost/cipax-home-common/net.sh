#!/bin/bash

if [[ -z ${SMARTPROF_DIR_PERHOST_CIPAX_HOME_COMMON} ]]; then
   export SMARTPROF_DIR_PERHOST_CIPAX_HOME_COMMON="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
   
   alias ss_mac='ss_prof ciprian@192.168.1.50'
   alias ss_centos6='ss_prof cstan@192.168.1.150'
   alias ss_centos7='ss_prof ats@192.168.1.151'
   alias ss_nas='ss_prof root@192.168.1.10'
   alias ss_atsdev='ss_prof cstan@gw.jlg.ro 22001'
   alias ss_icwprodev='ss_prof nor@gw.jlg.ro 22201'
fi
