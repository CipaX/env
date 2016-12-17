#!/bin/bash

#   ---------------------------
#    SEARCHING
#   ---------------------------

alias qfind="find . -name "                 # qfind:    Quickly search for file
ff () { /usr/bin/find . -name "$@" ; }      # ff:       Find file under the current directory

#   spotlight: Search for a file using MacOS Spotlight's metadata
#   -----------------------------------------------------------
spotlight () { mdfind "kMDItemDisplayName == '$@'wc"; }

function perhost_prog_ts_help()
{
   echoH1 "perhost_search commands"
   echo "$(echoBold qfind) - Quickly search for file"
   echo "$(echoBold ff) - Find file under the current directory"
   echo "$(echoBold spotlight) - Search for a file using MacOS Spotlight's metadata"
}
