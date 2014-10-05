#!/bin/bash

#   -------------------------------
#    ENVIRONMENT CONFIGURATION
#   -------------------------------

#   Change Prompt
#   ------------------------------------------------------------
PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\$ " # before reinstall
PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;31m\]$(pwd)\[\e[0m\] \n\$ '
PS2='\$ '

#   Helper for avoiding duplicates when addind items to PATH
#   ------------------------------------------------------------
pathPrepend() {
    if ! echo $PATH | egrep -q "(^|:)$1($|:)" ; then
        export PATH=$1:$PATH
    fi
}

#   Set Paths (Homebrew installed binaries at the beginning)
#   ------------------------------------------------------------
pathPrepend "/usr/local/bin:~/bin"

#   Set Default Editor
#   ------------------------------------------------------------
export EDITOR='~/bin/subl -w'

#   Set default blocksize for ls, df, du
#   from this: http://hints.macworld.com/comment.php?mode=view&cid=24491
#   ------------------------------------------------------------
export BLOCKSIZE=1k

#   Add color to terminal
#   (this is all commented out as I use Mac Terminal Profiles)
#   from http://osxdaily.com/2012/02/21/add-color-to-the-terminal-in-mac-os-x/
#   ------------------------------------------------------------
export CLICOLOR=1
#export LSCOLORS=ExFxBxDxCxegedabagacad    # for light themed terminals
export LSCOLORS=GxFxCxDxBxegedabagaced    # for dark themed terminals
