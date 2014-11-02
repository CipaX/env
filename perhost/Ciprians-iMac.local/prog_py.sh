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

# make all typescripts from current folder recursively
alias mts='for f in $(find . -name "*.ts"); do echo "Compiling $f ..."; tsc $f; done'
