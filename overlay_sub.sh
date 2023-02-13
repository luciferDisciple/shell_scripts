#!/bin/bash

INPUT_FILE=$1
SUB_FILE=$2
OUTPUT_FILE=$3

ffmpeg -i $INPUT_FILE -sn \
-filter:v "subtitles='$SUB_FILE:force_style=BorderStyle=3,Fontsize=28'" \
-c:a copy -c:v libx264 -crf 24 -preset veryfast $OUTPUT_FILE

