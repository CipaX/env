#!/bin/bash

#   ---------------------------
#    PROCESS MANAGEMENT
#   ---------------------------

#   findPid: find out the pid of a specified process
#   -----------------------------------------------------
#       Note that the command name can be specified via a regex
#       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
#       Without the 'sudo' it will only find processes of the current user
#   -----------------------------------------------------
findPid () { lsof -t -c "$@" ; }

#   memHogsTop, memHogsPs:  Find memory hogs
#   -----------------------------------------------------
alias memHogsTop='top -l 1 -o rsize | head -20'
alias memHogsPs='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#   cpuHogs:  Find CPU hogs
#   -----------------------------------------------------
alias cpuHogs='ps wwaxr -o pid,stat,%cpu,time,command | head -10'

#   ttop:  Recommended 'top' invocation to minimize resources
#   ------------------------------------------------------------
#       Taken from this macosxhints article
#       http://www.macosxhints.com/article.php?story=20060816123853639
#   ------------------------------------------------------------
alias ttop="top -R -F -s 10 -o rsize"

#   my_ps: List processes owned by my user:
#   ------------------------------------------------------------
my_ps() { ps $@ -u $USER -o pid,%cpu,%mem,start,time,bsdtime,command ; }

function perhost_pids_help()
{
   echoH1 "perhost_pids commands"
   echo "$(echoBold findPid) - find out the pid of a specified process (also works with /regex/)"
   echo "$(echoBold memHogsTop) - Find memory hogs with top"
   echo "$(echoBold memHogsPs) - Find memory hogs with ps"
   echo "$(echoBold cpuHogs) - Find CPU hogs"
   echo "$(echoBold ttop) - 'top' invocation to minimize resources"
   echo "$(echoBold my_ps) - List processes owned by my user"
}
