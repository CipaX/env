#!/bin/bash

#   ---------------------------
#    NETWORKING
#   ---------------------------

alias myip='curl ip.appspot.com'                    # myip:         Public facing IP Address
alias netCons='lsof -i'                             # netCons:      Show all open TCP/IP sockets
alias flushDNS='dscacheutil -flushcache'            # flushDNS:     Flush out the DNS Cache
alias lsock='sudo /usr/sbin/lsof -i -P'             # lsock:        Display open sockets
alias lsockU='sudo /usr/sbin/lsof -nP | grep UDP'   # lsockU:       Display only open UDP sockets
alias lsockT='sudo /usr/sbin/lsof -nP | grep TCP'   # lsockT:       Display only open TCP sockets
alias ipInfo0='ipconfig getpacket en0'              # ipInfo0:      Get info on connections for en0
alias ipInfo1='ipconfig getpacket en1'              # ipInfo1:      Get info on connections for en1
alias openPorts='sudo lsof -i | grep LISTEN'        # openPorts:    All listening connections
alias showBlocked='sudo ipfw list'                  # showBlocked:  All ipfw rules inc/ blocked IPs

#   ii:  display useful host related informaton
#   -------------------------------------------------------------------
ii() {
    echo -e "\nYou are logged on ${RED}$HOST"
    echo -e "\nAdditionnal information:$NC " ; uname -a
    echo -e "\n${RED}Users logged on:$NC " ; w -h
    echo -e "\n${RED}Current date :$NC " ; date
    echo -e "\n${RED}Machine stats :$NC " ; uptime
    echo -e "\n${RED}Current network location :$NC " ; scselect
    echo -e "\n${RED}Public facing IP Address :$NC " ;myip
    #echo -e "\n${RED}DNS Configuration:$NC " ; scutil --dns
    echo
}

function perhost_net_help()
{
   echoH1 "perhost_net commands"
   echo "$(echoBold myip) - Public facing IP Address"
   echo "$(echoBold mtnetCons) - Show all open TCP/IP sockets"
   echo "$(echoBold flushDNS) - Flush out the DNS Cache"
   echo "$(echoBold lsock) - Display open sockets"
   echo "$(echoBold lsockU) - Display only open UDP sockets"
   echo "$(echoBold lsockT) - Display only open TCP sockets"
   echo "$(echoBold ipInfo0) - Get info on connections for en0"
   echo "$(echoBold ipInfo1) - Get info on connections for en1"
   echo "$(echoBold openPorts) - All listening connections"
   echo "$(echoBold showBlocked) - All ipfw rules inc/ blocked IPs"
   echo "$(echoBold ii) - Display useful host related informaton"
}
