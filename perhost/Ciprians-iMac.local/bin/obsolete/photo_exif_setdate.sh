#!/bin/bash

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")

FILES=$(find . -maxdepth 1 \
	-name "*.jpg" -or -name "*.JPG" -or \
	-name "*.png" -or -name "*.PNG" -or \
	-name "*.gif" -or -name "*.GIF" -or \
	-name "*.mov" -or -name "*.MOV" -or \
	-name "*.mp4" -or -name "*.MP4")

for f in ${FILES}
do
   exiftool '-FileModifyDate<${CreateDate}' '-FileModifyDate<${DateTimeOriginal}' $f
done

IFS=$SAVEIFS
