#!/bin/bash

VIRTENV_PATH=${WORKON_HOME}/scrapping

pushd $(dirname $0) > /dev/null
SCRIPTDIR=$(pwd)
popd > /dev/null

cd $VIRTENV_PATH && source bin/activate && cd $SCRIPTDIR && python subd.py "$@"
