#!/bin/bash

#   -----------------------------
#    MAKE TERMINAL BETTER
#   -----------------------------

#   bash-completion
#   ------------------------------------------------------------
__BASH_COMPLETION_DIR="$(brew --prefix)/etc/bash_completion.d"
for bash_completion_script in $(find ${__BASH_COMPLETION_DIR} ); do
   if [[ -f ${bash_completion_script} ]]; then
      source ${bash_completion_script}
   fi
done

alias ls='ls -GFh'                          # Preferred 'ls' implementation
alias ll='ls -lAp'                          # Preferred 'll' implementation
alias subl='~/bin/subl -w'
alias edit='subl'                           # edit:         Opens any file in sublime editor
alias f='open -a Finder ./'                 # f:            Opens current directory in MacOS Finder
alias path='echo -e ${PATH//:/\\n}'         # path:         Echo all executable Paths
trash () { command mv "$@" ~/.Trash ; }     # trash:        Moves a file to the MacOS trash
ql () { qlmanage -p "$*" >& /dev/null; }    # ql:           Opens any file in MacOS Quicklook Preview
alias DT='tee ~/Desktop/terminalOut.txt'    # DT:           Pipe content to file on MacOS Desktop
eval "$(thefuck --alias)"                   # fuck:         Command alias (help on last command)

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
