#!/bin/bash

BASE="$(pwd)"

function getHome()
{
   echo ${HOME}
}

function getAbsPath()
{
   echo $(cd "$1"; pwd)
}

BASE_GET_FUNC=${SMARTPROF_GO_BASE_GET_FUNC:-'getHome'}
BASE="$($BASE_GET_FUNC)"
BASE="$(getAbsPath ${BASE})"


if [ "$#" -eq 1 ] && [ "$1" == "-h" ]; then
   _CMD="$(basename $0)"
   echo "usage: ${_CMD} <pattern>"
   echo ""
   echo "${_CMD} - matches the given file/directory path pattern within the base directory subtree and returns the first best path match."
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
	exit
elif [ "$#" -eq 0 ]; then
   echo ${BASE}
   exit
fi

function getPathCost()
{
   #echo "----------" 1>&2

   IFS='/' read -a PARTS <<< $1

   PART_COUNT=0
   LINK_COUNT=0
   HIGHEST_LINK_LEVEL=0

   SUB_PATH=${BASE}
   for PART in ${PARTS}; do
      SUB_PATH="${SUB_PATH}/${PART}"
      SUB_PATH="$(echo ${SUB_PATH} | sed 's,:, ,g')"

      if [[ -L "${SUB_PATH}" ]]; then

         let LINK_COUNT=LINK_COUNT+1
         let HIGHEST_LINK_LEVEL=PART_COUNT
      fi

      #echo " part: ${PART}" 1>&2         
      #echo " sub path: ${SUB_PATH}" 1>&2         
      #echo "   part count: ${PART_COUNT}" 1>&2         
      #echo "   link count: ${LINK_COUNT}" 1>&2         
      #echo "   highest link level: ${HIGHEST_LINK_LEVEL}" 1>&2         

      let PART_COUNT=PART_COUNT+1
   done

   LENGTH=${#1}
   let COST=LINK_COUNT
   let COST=COST*100+HIGHEST_LINK_LEVEL
   let COST=COST*100+PART_COUNT
   let COST=COST*1000+LENGTH

   echo "${COST}"
}

function getBestPathFromList()
{
   DIR=""
   COST=10000000000
   LENGTH=
   for DIR_IT in $@; do
      COST_IT=$(getPathCost ${DIR_IT})

      #echo "MATCH: ${DIR_IT} ${COST_IT}" 1>&2

      if [[ ${COST_IT} -lt ${COST} ]]; then
         DIR=${DIR_IT}
         let COST=${COST_IT}
      fi

   done

   #echo "->BEST MATCH: ${DIR} ${COST}" 1>&2

   echo ${DIR} | sed 's,:, ,g'
}

function getSimplePattern()
{
   local PATTERN=".*$@.*"
   echo "${PATTERN}"
}

function getPartsPattern()
{
   local PARTS=$(sed -e 's/\([A-Z]\)/ \1/g' -e 's/^-//'  <<< "$@")

   local PATTERN=""
   for PART in $PARTS; do
	   PATTERN="${PATTERN}.*${PART}"
   done
   PATTERN="${PATTERN}.*"

   echo "${PATTERN}"
}

function pathMatch()
{
   case $1 in
      0)
         INDEX_REGISTRY="${HOME}/.smartgo_index/__dir_index_registry"
         FIND_FILE_TYPE='d'
         MODE_TEXT="directory"
      ;;
      1)
         INDEX_REGISTRY="${HOME}/.smartgo_index/__file_index_registry"
         FIND_FILE_TYPE='f'
         MODE_TEXT="file"
      ;;
      *)
         return
      ;;
   esac
   shift

   INDEX_KEY=""
   INDEX_PATH=""
   INDEX_LENGTH=10000
   if [[ -f "${INDEX_REGISTRY}" ]]; then
      for ENTRY in $(cat "${INDEX_REGISTRY}"); do
         _KEY="$(echo $ENTRY | cut -d: -f1)"
         _PATH="$(echo $ENTRY | cut -d: -f2)"

         if [[ ${BASE} == *"${_PATH}"* ]]; then
            if [[ ${#_PATH} -lt ${INDEX_LENGTH} ]]; then
               INDEX_KEY=${_KEY}
               INDEX_PATH=${_PATH}
               let INDEX_LENGTH=${#INDEX_PATH}
            fi
         fi
      done
   fi

   if [[ -n ${INDEX_KEY} ]]; then
      #
      # Index EXISTS
      #

      PATTERN=$(getSimplePattern "$@")
      MATCHES=$(cat ~/.smartgo_index/"${INDEX_KEY}" | egrep "${PATTERN}" | sed "s, ,:,g")
      MATCH=$(getBestPathFromList ${MATCHES})

      if [ -n "${MATCH}" ]; then
	      echo "${MATCH}"
	      return
      fi

      PATTERN=$(getPartsPattern "$@")
      MATCHES=$(cat ~/.smartgo_index/"${INDEX_KEY}" | egrep "${PATTERN}" | sed "s, ,:,g")
      MATCH=$(getBestPathFromList ${MATCHES})
      if [ -n "${MATCH}" ]; then
	      echo "${MATCH}"
	      return
      fi

   else
      #
      # Index DOES NOT EXIST
      #

      echo "No ${MODE_TEXT} index found. Proceding with live search." 1>&2

      PATTERN=$(getSimplePattern "$@")
      MATCHES=$(cd "${BASE}"; find -L . -type ${FIND_FILE_TYPE} -regex "${PATTERN}" | sed "s,^\./,,g" | sed "s, ,:,g")
      MATCH=$(getBestPathFromList ${MATCHES})
      if [ -n "${MATCH}" ]; then
	      echo "${MATCH}"
	      return
      fi

      PATTERN=$(getPartsPattern "$@")
      MATCHES=$(cd "${BASE}"; find -L . -type ${FIND_FILE_TYPE} -regex "${PATTERN}" | sed "s,^\./,,g" | sed "s, ,:,g")
      MATCH=$(getBestPathFromList ${MATCHES})
      if [ -n "${MATCH}" ]; then
	      echo "${MATCH}"
	      return
      fi
   fi
}

BASE_GET_FUNC=${SMARTPROF_GO_BASE_GET_FUNC:-'getHome'}
BASE="$($BASE_GET_FUNC)"
BASE="$(getAbsPath ${BASE})"

# Search for dir
#
REL_MATCH=$(pathMatch 0 $@)
if [[ -n "${REL_MATCH}" ]]; then
   MATCH="${BASE}/${REL_MATCH}"
else
   # Search for file
   #
   REL_MATCH=$(pathMatch 1 $@)
   if [[ -n "${REL_MATCH}" ]]; then
      REL_DIR_FOR_FILE=$(dirname "${REL_MATCH}")
      MATCH="${BASE}/${REL_DIR_FOR_FILE}"
   fi
fi

if [[ -n ${MATCH} ]]; then
   echo ${MATCH}
fi
