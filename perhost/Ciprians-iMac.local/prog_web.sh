#!/bin/bash

#   ---------------------------------------
#    WEB DEVELOPMENT
#   ---------------------------------------

alias apacheEdit='sudo edit /etc/httpd/httpd.conf'      # apacheEdit:       Edit httpd.conf
alias apacheRestart='sudo apachectl graceful'           # apacheRestart:    Restart Apache
alias editHosts='sudo edit /etc/hosts'                  # editHosts:        Edit /etc/hosts file
alias herr='tail /var/log/httpd/error_log'              # herr:             Tails HTTP error logs
alias apacheLogs="less +F /var/log/apache2/error_log"   # Apachelogs:       Shows apache error logs
httpHeaders () { /usr/bin/curl -I -L $@ ; }             # httpHeaders:      Grabs headers from web page

#   httpDebug:  Download a web page and show info on what took time
#   -------------------------------------------------------------------
httpDebug () { /usr/bin/curl $@ -o /dev/null -w "dns: %{time_namelookup} connect: %{time_connect} pretransfer: %{time_pretransfer} starttransfer: %{time_starttransfer} total: %{time_total}\n" ; }

function perhost_prog_web_help()
{
   echoH1 "perhost_prog_web commands"
   echo "$(echoBold apacheEdit) - Edit httpd.conf"
   echo "$(echoBold apacheRestart) - Restart Apache"
   echo "$(echoBold editHosts) - Edit /etc/hosts file"
   echo "$(echoBold herr) - Tails HTTP error logs"
   echo "$(echoBold apacheLogs) - Shows apache error logs"
   echo "$(echoBold httpHeaders) - Grabs headers from web page"
   echo "$(echoBold httpDebug) - Download a web page and show info on what took time"
}
