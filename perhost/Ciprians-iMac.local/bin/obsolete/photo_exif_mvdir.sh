#!/bin/bash

exiftool -d ./%Y.%m -r . \
      '-Directory<${FileModifyDate}' \
      '-Directory<${CreateDate}' \
      '-Directory<${DateTimeOriginal}'
