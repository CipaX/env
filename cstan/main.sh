#!/bin/bash

#  Environment Configuration
source "${SMART_ENV_USER_DIR}/env_conf.sh"

#  Make Terminal Better (remapping defaults and adding functionality)
source "${SMART_ENV_USER_DIR}/terminal.sh"

#  File and Folder Management
source "${SMART_ENV_USER_DIR}/files.sh"

#  SEARCHING
source "${SMART_ENV_USER_DIR}/search.sh"

#  PROCESS MANAGEMENT
source "${SMART_ENV_USER_DIR}/pids.sh"

#  NETWORKING
source "${SMART_ENV_USER_DIR}/net.sh"

#  SYSTEMS OPERATIONS & INFORMATION
source "${SMART_ENV_USER_DIR}/osinfo.sh"

#  PROGRAMMING - GENERAL
source "${SMART_ENV_USER_DIR}/prog.sh"

#  WEB DEVELOPMENT
source "${SMART_ENV_USER_DIR}/prog_web.sh"

#  PYTHON
source "${SMART_ENV_USER_DIR}/prog_py.sh"

#  SPECIFIC UTILITIES
source "${SMART_ENV_USER_DIR}/specific_utils.sh"

#  ATS DEVELOPMENT
source "${SMART_ENV_USER_DIR}/proj_ats.sh"


#   ---------------------------------------
#    REMINDERS & NOTES
#   ---------------------------------------

#   remove_disk: spin down unneeded disk
#   ---------------------------------------
#   diskutil eject /dev/disk1s3

#   to change the password on an encrypted disk image:
#   ---------------------------------------
#   hdiutil chpass /path/to/the/diskimage

#   to mount a read-only disk image as read-write:
#   ---------------------------------------
#   hdiutil attach example.dmg -shadow /tmp/example.shadow -noverify

#   mounting a removable drive (of type msdos or hfs)
#   ---------------------------------------
#   mkdir /Volumes/Foo
#   ls /dev/disk*   to find out the device to use in the mount command)
#   mount -t msdos /dev/disk1s1 /Volumes/Foo
#   mount -t hfs /dev/disk1s1 /Volumes/Foo

#   to create a file of a given size: /usr/sbin/mkfile or /usr/bin/hdiutil
#   ---------------------------------------
#   e.g.: mkfile 10m 10MB.dat
#   e.g.: hdiutil create -size 10m 10MB.dmg
#   the above create files that are almost all zeros - if random bytes are desired
#   then use: ~/Dev/Perl/randBytes 1048576 > 10MB.dat