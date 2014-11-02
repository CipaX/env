#!/bin/bash

#   ---------------------------------------
#    SPECIFIC UTILITIES
#   ---------------------------------------

export SUBD_SUBS_DIR="/Users/ciprian/Downloads/_subd_subs"
export SUBD_CMD="${SMARTPROF_DIR_PERHOST_CIP_MAC}/tools/subd/subd.sh"

function subd()
{
	${SUBD_CMD} "$@"
}
