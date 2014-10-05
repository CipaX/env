#!/bin/bash

#   ---------------------------------------
#    PROGRAMMING - GENERAL
#   ---------------------------------------

alias m='make'
alias m2='make -j2'
alias m4='make -j2'
alias m6='make -j2'
alias m8='make -j2'
alias mts='for f in $(find . -name "*.ts"); do echo "Compiling $f ..."; tsc $f; done'
