#!/bin/bash

if [[ -z ${CSPROF_DIR_COMMON_GEN_DEVEL} ]]; then
   export CSPROF_DIR_COMMON_GEN_DEVEL="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

   HL_ERROR="egrep --color \"^|\: error\: |\: note\: \""
   TO_STD_OUT_HL_ERROR="2>&1 | $HL_ERROR"

   alias low_pri='nice -n19'
   alias hl_error='$$HL_ERROR'

   alias m="make $TO_STD_OUT_HL_ERROR"
   alias m4="make -j4 $TO_STD_OUT_HL_ERROR"
   alias m6="make -j6 $TO_STD_OUT_HL_ERROR"
   alias m8="low_pri make -j8 $TO_STD_OUT_HL_ERROR"
   alias m10="low_pri make -j10 $TO_STD_OUT_HL_ERROR"
   alias m12="low_pri make -j12 $TO_STD_OUT_HL_ERROR"

   alias t100='tail -n 100'
   alias rmc='rm -rf core*'
   alias kct='killall -9 cleartool'
fi

