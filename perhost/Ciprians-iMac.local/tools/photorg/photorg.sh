#!/bin/bash

VIRTENV_PATH=${WORKON_HOME}/photo_org

EXEC_DIR=$(pwd)

pushd $(dirname $0) > /dev/null
SCRIPT_DIR=$(pwd)
popd > /dev/null

cd ${VIRTENV_PATH} && source bin/activate && cd ${EXEC_DIR} && python ${SCRIPT_DIR}/photorg.py "$@"
