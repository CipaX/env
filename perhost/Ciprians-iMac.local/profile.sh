#!/bin/bash

if [[ -z ${SMARTPROF_DIR_PERHOST_CIP_MAC} ]]; then
   export SMARTPROF_DIR_PERHOST_CIP_MAC="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

   #  Environment Configuration
   source "${SMARTPROF_DIR_PERHOST_CIP_MAC}/env_conf.sh"

   #  Make Terminal Better (remapping defaults and adding functionality)
   source "${SMARTPROF_DIR_PERHOST_CIP_MAC}/terminal.sh"

   #  File and Folder Management
   source "${SMARTPROF_DIR_PERHOST_CIP_MAC}/files.sh"

   #  SEARCHING
   source "${SMARTPROF_DIR_PERHOST_CIP_MAC}/search.sh"

   #  PROCESS MANAGEMENT
   source "${SMARTPROF_DIR_PERHOST_CIP_MAC}/pids.sh"

   #  NETWORKING
   source "${SMARTPROF_DIR_PERHOST_CIP_MAC}/net.sh"

   #  SYSTEMS OPERATIONS & INFORMATION
   source "${SMARTPROF_DIR_PERHOST_CIP_MAC}/osinfo.sh"

   #  PROGRAMMING - GENERAL
   source "${SMARTPROF_DIR_PERHOST_CIP_MAC}/prog.sh"

   #  WEB DEVELOPMENT
   source "${SMARTPROF_DIR_PERHOST_CIP_MAC}/prog_web.sh"

   #  PYTHON
   source "${SMARTPROF_DIR_PERHOST_CIP_MAC}/prog_py.sh"

   #  TYPESCRIPT
   source "${SMARTPROF_DIR_PERHOST_CIP_MAC}/prog_ts.sh"

   #  SPECIFIC UTILITIES
   source "${SMARTPROF_DIR_PERHOST_CIP_MAC}/specific_utils.sh"

   #  ATS DEVELOPMENT
   source "${SMARTPROF_DIR_PERHOST_CIP_MAC}/proj_ats.sh"


   #  Common CipaX-home scripts
   source "${SMARTPROF_DIR_ROOT}/perhost/cipax-home-common/net.sh"   

   #  Aliases
   alias ats='source ~/01-prog/jlg/ATS/env/profile.sh'

   function perhost_help()
   {
      perhost_env_conf_help
      perhost_terminal_help
      perhost_files_help
      perhost_search_help
      perhost_pids_help
      perhost_net_help
      perhost_osinfo_help
      perhost_prog_help
      perhost_prog_web_help
      perhost_prog_py_help
      perhost_prog_ts_help
      perhost_specific_utils_help
      perhost_proj_ats_help
   }
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
