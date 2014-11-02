#!/bin/bash

if [[ -z ${CSPROF_DIR_PERHOST_CIP_MAC} ]]; then
   export CSPROF_DIR_PERHOST_CIP_MAC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

   #  Environment Configuration
   source "${CSPROF_DIR_PERHOST_CIP_MAC}/env_conf.sh"

   #  Make Terminal Better (remapping defaults and adding functionality)
   source "${CSPROF_DIR_PERHOST_CIP_MAC}/terminal.sh"

   #  File and Folder Management
   source "${CSPROF_DIR_PERHOST_CIP_MAC}/files.sh"

   #  SEARCHING
   source "${CSPROF_DIR_PERHOST_CIP_MAC}/search.sh"

   #  PROCESS MANAGEMENT
   source "${CSPROF_DIR_PERHOST_CIP_MAC}/pids.sh"

   #  NETWORKING
   source "${CSPROF_DIR_PERHOST_CIP_MAC}/net.sh"

   #  SYSTEMS OPERATIONS & INFORMATION
   source "${CSPROF_DIR_PERHOST_CIP_MAC}/osinfo.sh"

   #  PROGRAMMING - GENERAL
   source "${CSPROF_DIR_PERHOST_CIP_MAC}/prog.sh"

   #  WEB DEVELOPMENT
   source "${CSPROF_DIR_PERHOST_CIP_MAC}/prog_web.sh"

   #  PYTHON
   source "${CSPROF_DIR_PERHOST_CIP_MAC}/prog_py.sh"

   #  TYPESCRIPT
   source "${CSPROF_DIR_PERHOST_CIP_MAC}/prog_ts.sh"

   #  SPECIFIC UTILITIES
   source "${CSPROF_DIR_PERHOST_CIP_MAC}/specific_utils.sh"

   #  ATS DEVELOPMENT
   source "${CSPROF_DIR_PERHOST_CIP_MAC}/proj_ats.sh"


   #  Aliases
   alias ss_centos='ss_prof cstan@192.168.1.150'
   alias ats='source ~/01-prog/jlg/ATS/env/profile.sh'
fi


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
