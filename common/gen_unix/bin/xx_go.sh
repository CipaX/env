#!/bin/bash

if [ "$#" -eq 1 ] && [ "$1" == "-h" ]; then
   _CMD="$(basename $0)"
   echo "usage: ${_CMD} <pattern>"
   echo ""
   echo "${_CMD} - matches the given file/directory path pattern within the base directory subtree and changes the directory to the first best path match."
   echo ""
   echo "The criteria for choosing the best path depends on the number of links, on their position and on the length of the path."
   echo "The base directory is determined by calling a user function with the name obtained from the SMARTPROF_GO_BASE_GET_FUNC env variable. If the variable does not exist, the base directory is the user's home."
   echo "First the exact <pattern>, with added leading and trailing wildcards is matched."
   echo "If that yields no results the given pattern is then split into separate words (by whitespaces and camelcase rules), with wildcards in-between."
   echo "" 
   echo "<pattern> = part1 [part2 [part3 [...]]]"
   echo ""
   echo "Important note:"
   echo "  Execute with source (or ". ") before, in order to keep the new location by avoiding to launch withing a subshell."
   echo ""
   echo "Examples:"
   echo "  Consider the following file structure:"
   echo "    Common/LibAbc/LibImpl/AbcImplFile.cc"
   echo "    Common/LibAbc/AbcFile.cc"
   echo "    Prototypes/LibAbc/LibImpl/AbcImplFile.cc"
   echo "    Prototypes/LibAbc/LibImpl/ProtoFile.cc"
   echo ""
   echo "  ${_CMD} Abc          # changes the folder to Common/LibAbc"
   echo "  ${_CMD} P Abc        # changes the folder to Prototypes/LibAbc"
   echo "  ${_CMD} PAbc         # same as ${_CMD} P Abc"
   echo "  ${_CMD} AbcFile      # changes the folder to Common/LibAbc"
   echo "  ${_CMD} ProtoFile.cc # changes the folder to Prototypes/LibAbc/LibImpl/"

   # Do not exit, because it may close the terminal

else

   MATCH=$(xx_match_dir.sh $@)
   if [[ -n ${MATCH} ]]; then
      cd "${MATCH}"
      pwd
   else
      echo "No directory or file matches the given pattern" 1>&2
   fi

fi
