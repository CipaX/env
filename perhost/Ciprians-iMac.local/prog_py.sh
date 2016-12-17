#!/bin/bash

#   ---------------------------------------
#    PYTHON
#   ---------------------------------------

#   Set architecture flags
#   ------------------------------------------------------------
export ARCHFLAGS="-arch x86_64"

#   Python VirtualEnv config
#   ------------------------------------------------------------
export PIP_REQUIRE_VIRTUALENV=true           # pip should only run if there is a virtualenv currently activated
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache   # cache pip-installed packages to avoid re-downloading

syspip(){
   PIP_REQUIRE_VIRTUALENV="" pip "$@"
}

export WORKON_HOME=$HOME/.py_venv
export PROJECT_HOME=$HOME/01-prog/tests/
source /usr/local/bin/virtualenvwrapper.sh

function perhost_prog_py_help()
{
   echoH1 "perhost_prog_py commands"
   echo "$(echoBold syspip) - system (not virtualenv) pip"
}
