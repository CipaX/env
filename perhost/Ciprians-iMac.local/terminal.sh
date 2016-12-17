#!/bin/bash

#   -----------------------------
#    MAKE TERMINAL BETTER
#   -----------------------------

#   bash-completion
#   ------------------------------------------------------------
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

alias cp='cp -iv'                           # Preferred 'cp' implementation
alias mv='mv -iv'                           # Preferred 'mv' implementation
alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
alias ls='ls -GFh'                          # Preferred 'ls' implementation
alias ll='ls -lAp'                          # Preferred 'll' implementation
alias less='less -FSRXc'                    # Preferred 'less' implementation
alias which='type -p'                       # Always better than which
alias subl='~/bin/subl -w'
alias edit='subl'                           # edit:         Opens any file in sublime editor
alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop

#   lr:  Full Recursive Directory Listing
#   ------------------------------------------
alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

function perhost_terminal_help()
{
   echoH1 "perhost_terminal commands"
   echo "$(echoBold subl) - opens sublime text"
   echo "$(echoBold edit) - alias to subl"   
   echo "$(echoBold f) - Opens current directory in MacOS Finder"
   echo "$(echoBold path) - Echo all executable Paths"
   echo "$(echoBold trash) - Moves a file to the MacOS trash"
   echo "$(echoBold ql) - Opens any file in MacOS Quicklook Preview"
   echo "$(echoBold DT) - Pipe content to file on MacOS Desktop"
   echo "$(echoBold lr) - Full Recursive Directory Listing"
}
