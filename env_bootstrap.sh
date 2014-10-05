#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
	DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
	SOURCE="$(readlink "$SOURCE")"
	[[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
export SMART_ENV_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

export SMART_ENV_USER_DIR="${SMART_ENV_DIR}/cstan"

source "${SMART_ENV_USER_DIR}/main.sh"
