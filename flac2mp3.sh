#!/bin/bash

prog_name=${0##*/}

usage () {
	echo "Usage: $prog_name FILE..."
	echo "       $prog_name [-h|--help]"
	echo "Transcode flac FILEs into mp3 files while keeping the tags."
	echo "Audio in the output files will have an avarage bitrate of 190kb/s."
} >&2

die () { printf >&2 '[%s] Error. %s\n' "$prog_name" "$*" ; exit 1; }

info () { printf >&2 '[%s] %s\n' "$prog_name" "$*";}

[[ $# -eq 0 ]] && usage && die Wrong number of arguments.

[[ "$1" == "--help" || "$1" == "-h" ]] && usage && exit 0

input_files=("$@")

for fname in "${input_files[@]}"; do
	[[ -f "$fname" ]] || die "'$fname': no such file"
done

for in_fname in "${input_files[@]}"; do
	in_basename=${in_fname%.*}
	out_fname="${in_basename}.mp3"
	[[ -f "$out_fname" ]] && die "File '$out_fname' already exists."
	info "Converting '${in_fname}'"
	ffmpeg -hide_banner \
		-i "${in_fname}" \
		-c:a libmp3lame \
		-q:a 2 \
		-map_metadata 0 \
		-id3v2_version 3 \
		"${out_fname}"
done
