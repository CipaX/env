#!/bin/bash

#   ---------------------------------------
#    SYSTEMS OPERATIONS & INFORMATION
#   ---------------------------------------

alias mountReadWrite='/sbin/mount -uw /'    # mountReadWrite:   For use when booted into single-user

#   cleanupDS:  Recursively delete .DS_Store files
#   -------------------------------------------------------------------
alias cleanupDS="find . -type f -name '*.DS_Store' -ls -delete"

#   finderShowHidden:   Show hidden files in Finder
#   finderHideHidden:   Hide hidden files in Finder
#   -------------------------------------------------------------------
alias finderShowHidden='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias finderHideHidden='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

#   cleanupLS:  Clean up LaunchServices to remove duplicates in the "Open With" menu
#   -----------------------------------------------------------------------------------
alias cleanupLS="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

#    screensaverDesktop: Run a screensaver on the Desktop
#   -----------------------------------------------------------------------------------
alias screensaverDesktop='/System/Library/Frameworks/ScreenSaver.framework/Resources/ScreenSaverEngine.app/Contents/MacOS/ScreenSaverEngine -background'

function perhost_osinfo_help()
{
   echoH1 "perhost_osinfo commands"
   echo "$(echoBold mountReadWrite) - For use when booted into single-user"
   echo "$(echoBold cleanupDS) - Recursively delete .DS_Store files"
   echo "$(echoBold finderShowHidden) - Show hidden files in Finder"
   echo "$(echoBold finderHideHidden) - Hide hidden files in Finder"
   echo "$(echoBold cleanupLS) - Clean up LaunchServices to remove duplicates in the "Open With" menu"
   echo "$(echoBold screensaverDesktop) - Run a screensaver on the Desktop"
}
