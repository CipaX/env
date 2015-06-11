#!/bin/bash

if [ "$#" -eq 0 ] || ([ "$#" -eq 1 ] && [ "$1" == "-h" ]); then
	CMD=$(basename $0)
	echo "usage: ${CMD} <pattern> [path1 [path2 [...]]"
	echo ""
	echo "Matches the given pattern within the current directory subtree and outputs the first shortest path match."
	echo "  First the exact <pattern>, with added leading and trailing wildcards is matched."
	echo "  If that yelds no results the given pattern is then split into separate words (by whitespaces and camelcase rules), with wildcards in-between."
	echo ""
	echo "Examples:"
	echo "  ${CMD} Ice    # may match folder Client/Ige"
	echo "  ${CMD} S Cfg  # may match folder Server/Cfg"
	echo "  ${CMD} SCfg   # same as ${CMD} S Cfg"
	exit
fi

function getMinDirFromFindWithPipe()
{
	local MIN_LEN=10000
	local MIN_DIR=""

	while IFS= read -r -d '' DIR; do
		local let LEN=${#DIR}

		if (("${LEN}" > 0)); then
			if (("${LEN}" < "${MIN_LEN}")); then
				let MIN_LEN=${LEN}
				MIN_DIR=${DIR}
			fi
		fi
	done

	echo ${MIN_DIR}
}

function getMinDirFromList()
{
   DIR=""
   LENGTH=10000
   for _DIR in $@; do
      if [[ ${#_DIR} -lt ${LENGTH} ]]; then
         DIR=${_DIR}
         let LENGTH=${#DIR}
      fi
   done

   echo ${DIR}
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

function printAndExitIfNotEmpty()
{
	if [ -n "$1" ]; then
		echo $@
		exit
	fi
}

BASE="$(pwd)"
INDEX_KEY=""
INDEX_PATH=""
INDEX_LENGTH=10000
for ENTRY in $(cat ~/.smartgo_index/__index_registry); do
   _KEY="$(echo $ENTRY | cut -d: -f1)"
   _PATH="$(echo $ENTRY | cut -d: -f2)"

   if [[ ${_PATH} == *"${BASE}"* ]]; then
      if [[ ${#_PATH} -lt ${INDEX_LENGTH} ]]; then
         INDEX_KEY=${_KEY}
         INDEX_PATH=${_PATH}
         let INDEX_LENGTH=${#INDEX_PATH}
      fi
   fi
done

if [[ -n ${INDEX_KEY} ]]; then
   #
   # Index EXISTS
   #

   PATTERN=$(getSimplePattern "$@")
   MATCHES=$(cat ~/.smartgo_index/"${INDEX_KEY}" | egrep "${PATTERN}")
   MATCH=$(getMinDirFromList ${MATCHES})
   printAndExitIfNotEmpty ${MATCH}

   PATTERN=$(getPartsPattern "$@")
   MATCHES=$(cat ~/.smartgo_index/"${INDEX_KEY}" | egrep "${PATTERN}")
   MATCH=$(getMinDirFromList ${MATCHES})
   printAndExitIfNotEmpty ${MATCH}

else
   #
   # Index DOES NOT EXIST
   #

   echo "No index found. Proceding with live search." 1>&2

   PATTERN=$(getSimplePattern "$@")
   MATCH=$(find -L . -type d -regex "${PATTERN}" -print0 | getMinDirFromFindWithPipe)
   printAndExitIfNotEmpty ${MATCH}

   PATTERN=$(getPartsPattern "$@")
   MATCH=$(find -L . -type d -regex "${PATTERN}" -print0 | getMinDirFromFindWithPipe)
   printAndExitIfNotEmpty ${MATCH}
fi

echo "No matches found." 1>&2
