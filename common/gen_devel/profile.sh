#!/bin/bash

if [[ -z ${SMARTPROF_DIR_COMMON_GEN_DEVEL} ]]; then
   export SMARTPROF_DIR_COMMON_GEN_DEVEL="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
   alias pp_e_gen_devel="${SMARTPROF_EDITOR} ${BASH_SOURCE[0]} &"

   SMARTPROF_CC_ERR_FILE="/tmp/cmd_err.txt"

   function toFileHlErr()
   {
      if [ $# -eq 0 ]; then
         echo "Error: parameter missing"
         echo "toFileHlErr \"<command_with_args>\""
         return
      fi

      $@ 2>&1 | tee ${SMARTPROF_CC_ERR_FILE} | egrep --color "^|\: error\: |\: note\: "
   }

   function cc_err()
   {
      CMD_STATUS=${PIPESTATUS[0]}
      if [ ${CMD_STATUS} -ne 0 ]; then
         if [[ -f ${SMARTPROF_CC_ERR_FILE} ]]; then
            ${SMARTPROF_EDITOR} ${SMARTPROF_CC_ERR_FILE}
         fi
      else
         echo "The error file \"${SMARTPROF_CC_ERR_FILE}\" does not exist."
      fi
   }

   LOW_PRI="nice -n19"
   alias low_pri='${LOW_PRI}'

   alias m="toFileHlErr make"
   alias m4="toFileHlErr make -j4"
   alias m6="toFileHlErr ${LOW_PRI} make -j6"
   alias m8="toFileHlErr ${LOW_PRI} make -j8"
   alias m10="toFileHlErr ${LOW_PRI} make -j10"
   alias m12="toFileHlErr ${LOW_PRI} make -j12"

   alias t100='tail -n 100'
   alias rmc='rm -rf core*'
   alias kct='killall -9 cleartool'
fi
