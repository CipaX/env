#!/bin/bash

#   ---------------------------------------
#    SPECIFIC UTILITIES
#   ---------------------------------------

export SUBD_SUBS_DIR="/Users/ciprian/Downloads/_subd_subs"
export SUBD_CMD="${SMARTPROF_DIR_PERHOST_CIP_MAC}/tools/subd/subd.sh"
export PHOTORG_CMD="${SMARTPROF_DIR_PERHOST_CIP_MAC}/tools/photorg/photorg.sh"

function subd()
{
	${SUBD_CMD} "$@"
}

function photorg()
{
   ${PHOTORG_CMD} "$@"
}
