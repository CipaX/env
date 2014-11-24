#!/bin/bash

if [[ -z ${SMARTPROF_DIR_COMMON_GEN_LINUX} ]]; then
   export SMARTPROF_DIR_COMMON_GEN_LINUX="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

   ###########
   # Terminal
   ###########

   export CLICOLOR=1
   #export LSCOLORS=ExFxBxDxCxegedabagacad    # for light themed terminals
   export LSCOLORS=GxFxCxDxBxegedabagaced    # for dark themed terminals

   # Entire path in red:
   #PS1='\[\e[0;33m\]\u\[\e[0m\]@\[\e[0;32m\]\h\[\e[0m\]:\[\e[0;31m\]$(pwd)\[\e[0m\] \n\$ '
   # Home relative path in orange:
   PS1="\[\033[36m\]\u\[\033[m\]@\[\033[32m\]\h:\[\033[33;1m\]\w\[\033[m\]\n\$ "

   PS2='\$ '

   ####################
   # Aliases and utils
   ####################

   alias cp='cp -iv'                           # Preferred 'cp' implementation
   alias mv='mv -iv'                           # Preferred 'mv' implementation
   alias mkdir='mkdir -pv'                     # Preferred 'mkdir' implementation
   alias less='less -FSRXc'                    # Preferred 'less' implementation
   alias which='type -p'                       # Always better than which

   #  lr:  Full Recursive Directory Listing
   #   -----------------------------------------------------
   alias xx_lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'' | less'

   #   findPid: find out the pid of a specified process
   #   -----------------------------------------------------
   #       Note that the command name can be specified via a regex
   #       E.g. findPid '/d$/' finds pids of all processes with names ending in 'd'
   #       Without the 'sudo' it will only find processes of the current user
   #   -----------------------------------------------------
   xx_findPid () { lsof -t -c "$@" ; }

   #   Helper for avoiding duplicates when addind items to PATH
   #   ------------------------------------------------------------
   xx_pathPrepend()
   {
      IFS=":" read -a NEW_PATH_PARTS <<< "$1"
      
      for (( IDX=${#NEW_PATH_PARTS[@]}-1 ; IDX>=0 ; IDX-- )) ; do
         NEW_PATH_PART=${NEW_PATH_PARTS[IDX]}
         
         if ! echo $PATH | egrep -q "(^|:)${NEW_PATH_PART}($|:)" ; then
            export PATH=${NEW_PATH_PART}:$PATH
         fi
      done
   }

   ########################
   # Environment variables
   ########################

   export EDITOR=gedit
   export WINEDITOR=gedit

   #######
   # Path
   #######

   xx_pathPrepend "${SMARTPROF_DIR_COMMON_GEN_LINUX}/bin"

   ################################
   # Distributable profile and ssh
   ################################

   function _universalMd5SumCmd()
   {
      echo "
         (if [[ \"\$OSTYPE\" == \"linux-gnu\" ]]; then
            md5sum $@; 
         elif [[ \"\$OSTYPE\" == \"darwin\"* ]]; then 
            md5 -r $@;
         else 
            echo 'xxxxxxxxx';
         fi) | cut -d' ' -f1
      "
   }

   function _universalTimestampCmd()
   {
      echo "
         if [[ \"\$OSTYPE\" == \"linux-gnu\" ]]; then
            stat -c '%Y' $1;
         elif [[ \"\$OSTYPE\" == \"darwin\"* ]]; then 
            stat -f '%m' $1;
         else 
            echo '0';
         fi
      "
   }

   function _universalTimestampOrNullIfMissingCmd()
   {
      echo "
         if [ -f $1 ]; then
            if [[ \"\$OSTYPE\" == \"linux-gnu\" ]]; then
               stat -c '%Y' $1;
            elif [[ \"\$OSTYPE\" == \"darwin\"* ]]; then 
               stat -f '%m' $1;
            else 
               echo '0';
            fi
         else
            echo '0';
         fi
      "
   }

   function ss_pub_key()
   {
      if [[ $# -eq 1 ]]; then
         if [ ! -e ~/.ssh/id_rsa.pub ]
         then
	         echo "No public key found, please generate one first !"
	         ssh-keygen
         fi

         cat ~/.ssh/id_rsa.pub | ssh $1 'PUB_KEY="$(cat)"; FIND_RES=$(grep -x "${PUB_KEY}" ~/.ssh/authorized_keys); if [ -z "${FIND_RES}" ]; then umask 077; mkdir -p ~/.ssh; echo ${PUB_KEY} >> ~/.ssh/authorized_keys; echo "Now you can login without introducing a password."; fi'

      else
	      echo "Usage: publickey.sh user@host"
      fi
   }

   function pp_copy()
   {
      echo "### Compressing"

      cd ${SMARTPROF_DIR_ROOT}/..
      tar czvf smartprof.tgz --exclude '.?*' "env" > /dev/null # <- assuming the smartprof environment is stored in a folder called "env"

      if [[ $# -eq 1 ]]; then
         ss_pub_key $1

         echo "### Creating am user sub-folder remotely in the remote HOME"
         REMOTE_HOME="$(ssh $1 'echo $HOME')"
         REMOTE_USER_SUBDIR="${REMOTE_HOME}/${SMARTPROF_REMOTE_USER_SUBDIR}"
         ssh $1 "mkdir -p \"${REMOTE_USER_SUBDIR}\""

         echo "### Transferring the archive, extracting and removing the remote archive copy"
         scp smartprof.tgz "$1:${REMOTE_USER_SUBDIR}"
         ssh $1 "cd \"${REMOTE_USER_SUBDIR}\" && tar xvf smartprof.tgz > /dev/null && rm -rf smartprof.tgz"
         echo "### Done"

         echo "### Removing the local archive"
         rm -rf smartprof.tgz
      else
         echo "pp_copy user@host"
      fi
   }

   function pp_copy_if_newer()
   {
      if [[ $# -eq 1 ]]; then
         cd ${SMARTPROF_DIR_ROOT}

         if [[ ${HOSTNAME} == ${SMARTPROF_ROOT_HOSTNAME} ]]; then
            echo "### We are in ROOT"

            # Create an md5 file for the current profile snapshot
            find . \( ! -regex '.*/\..*' \) | xargs ls -l | grep -v md5sum.txt | eval "$(_universalMd5SumCmd)" > md5sum.txt.tmp
            if [ ! -f "md5sum.txt.tmp" ]; then
               echo "### Error: md5sum.txt.tmp was not created."
               return
            fi

            # Compare the newly created md5 with the last existing one
            MD5_DIFFERENT=1
            if [ -f "md5sum.txt" ]; then
               diff "md5sum.txt" "md5sum.txt.tmp" > /dev/null
               if [ $? -eq 0 ]; then
                  MD5_DIFFERENT=0
               fi
            fi

            if [ ${MD5_DIFFERENT} -ne 0 ]; then
               echo "### md5 is different"
               mv -f md5sum.txt.tmp md5sum.txt
            fi

         fi

         if [ -f "md5sum.txt" ]; then
            ss_pub_key $1

            REMOTE_TIMESTAMP_CMD="$(_universalTimestampOrNullIfMissingCmd \$HOME/${SMARTPROF_REMOTE_USER_SUBDIR}/env/md5sum.txt)"
            REMOTE_DATE="$(ssh $1 ${REMOTE_TIMESTAMP_CMD})"

            LOCAL_TIMESTAMP_CMD="$(_universalTimestampOrNullIfMissingCmd md5sum.txt)"
            LOCAL_DATE="$(eval ${LOCAL_TIMESTAMP_CMD})"

            if [ ${LOCAL_DATE} -gt ${REMOTE_DATE} ]; then
               echo "### Local date greater. Copying profile ..."
               pp_copy $1
            else
               echo "### Remote date greater or equal. No profile will be copied."
            fi
         else
            echo "### Error: local md5sum.txt does not exist."
            echo "### Begin distributing the profile from ${SMARTPROF_ROOT_HOSTNAME} or from a machine that has a profile with an md5sum.txt."
            echo "### Aborting."
            return
         fi

      else
         echo "pp_copy_if_newer user@host"
      fi
   }

   function ss_prof()
   {
      if [[ $# -eq 1 ]]; then
         ss_pub_key $1

         pp_copy_if_newer $1

         REMOTE_HOME="$(ssh $1 'echo $HOME')"
         REMOTE_RC="${REMOTE_HOME}/${SMARTPROF_REMOTE_USER_SUBDIR}/env/profile_with_bashrc.sh"
         echo "ssh -X -t $1 \"bash --rcfile ${REMOTE_RC} -l\""
         ssh -X -t $1 "bash --rcfile ${REMOTE_RC} -i"
      else
         echo "ss_prof user@host"
      fi
   }

fi
