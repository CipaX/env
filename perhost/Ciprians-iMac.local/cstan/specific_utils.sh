#!/bin/bash

#   ---------------------------------------
#    SPECIFIC UTILITIES
#   ---------------------------------------

export SUBD_SUBS_DIR="/Users/ciprian/Downloads/_subd_subs"
export SUBD_CMD='/Users/ciprian/01-prog/env/tools/subd/subd.sh'

function subd()
{
	${SUBD_CMD} "$@"
}
