#!/bin/bash

#   ---------------------------------------
#    TYPESCRIPT
#   ---------------------------------------

# make all typescripts from current folder recursively
alias mts='for f in $(find . -name "*.ts"); do echo "Compiling $f ..."; tsc $f; done'

function perhost_prog_ts_help()
{
   echoH1 "perhost_prog_ts commands"
   echo "$(echoBold mts) - make all typescripts from current folder recursively"
}
