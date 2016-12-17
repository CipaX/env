#!/bin/bash

#   ---------------------------------------
#    ATS DEVELOPMENT
#   ---------------------------------------

alias ats='cd ~/01-prog/jlg/ATS; . Env/profile.sh'

function perhost_proj_ats_help()
{
   echoH1 "perhost_proj_ats commands"
   echo "$(echoBold ats) - go to ats folder and load profile"
}
