#!/bin/bash

if [ "$#" -eq 1 ] && [ "$1" == "-h" ]; then
	_CMD="$(basename $0)"
	echo "usage: ${_CMD} <pattern>"
	echo ""
	echo "${_CMD} matches the given pattern within the current directory subtree and changes the directory to the first shortest path match."
	echo "  First the exact <pattern>, with added leading and trailing wildcards is matched."
	echo "  If that yelds no results the given pattern is then split into separate words (by whitespaces and camelcase rules), with wildcards in-between."
	echo ""
	echo "Important note:"
	echo "  Execute with source (or ". ") before, in order to avoid launching a subshell and keeping the new location."
	echo ""
	echo "Examples:"
	echo "  ${_CMD} Ice    # may change folder to Client/Ige"
	echo "  ${_CMD} S Cfg  # may change folder to Server/Cfg"
	echo "  ${_CMD} SCfg   # same as ${_CMD} S Cfg"
else
   _BASE_RAW=${!SMARTPROF_GO_BASE_VAR}
   _BASE=${_BASE_RAW:-${HOME}}

	if [ "$#" -eq 0 ]; then
		cd ${_BASE}
		pwd
	else
		MATCH=$(cd ${_BASE} > /dev/null; xx_match_dir.sh $@)

		if [ -n "${MATCH}" ]; then
			cd "${_BASE}/${MATCH}"
			pwd
			echo "cd ${_BASE}/${MATCH}"
		else
			echo "No folder matches the given pattern" 1>&2
		fi
	fi
fi
