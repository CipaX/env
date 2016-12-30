#!/bin/bash

#   -------------------------------
#    FILE AND FOLDER MANAGEMENT
#   -------------------------------

#   cdf:  cd's to frontmost window of MacOS Finder
#   ------------------------------------------------------
function cdf()
{
    currFolderPath=$( /usr/bin/osascript <<EOT
        tell application "Finder"
            try
        set currFolder to (folder of the front window as alias)
            on error
        set currFolder to (path to desktop folder as alias)
            end try
            POSIX path of currFolder
        end tell
EOT
    )
    echo "cd to \"$currFolderPath\""
    cd "$currFolderPath"
}

#   cdc:  copies the current directory (pwd) to the clipboard
#   ------------------------------------------------------
function cdc()
{
    pwd | pbcopy
}

#   cdp:  changes the current directory by to the value in the clipboard
#   ------------------------------------------------------
function cdp()
{
    cd "$(pbpaste)"
}

#   extract:  Extract most know archives with one command
#   ---------------------------------------------------------
function extract()
{
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

function perhost_files_help()
{
   echoH1 "perhost_files commands"
   echo "$(echoBold cdf) - cd's to frontmost window of MacOS Finder"
   echo "$(echoBold cdc) - copies the current directory (pwd) to the clipboard"
   echo "$(echoBold cdp) - changes the current directory by to the value in the clipboard"
   echo "$(echoBold extract) - Extract most know archives with one command"
}
