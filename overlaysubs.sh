#!/bin/bash

PROG=overlaysubs
VERSION=1.0.0

usage() {
	echo >&2 "usage: $PROG [-h] [-V] INPUT_FILE SUBS_FILE OUTPUT_FILE"
}

print_help() {
	usage
	cat >&2 <<-END
	
	Add rendered subtitles directly onto the video stream of a video file.
	
	positional arguments:
	  INFILE        source video file
	  SUBFILE       file with subtitles for source video file
	  OUTFILE       name of a file, where the result will be written to
	
	optional arguments:
	  -h, --help     show this help and exit
	  -V, --version  output version information and exit
	END
}

error() {
	local message="$@"
	echo "$PROG: error: $message" >&2
	exit 1
}

usage_error() {
	local message="$@"
	usage
	error "$message"
}

join_words() {
	printf '%s' "$1"
	shift
	if (( $# != 0 )); then
	    printf ', %s' "$@"
	fi
	echo
}

while :; do
	case "$1" in
		-h|--help)
			print_help && exit
			;;
		-V|--version)
			echo $VERSION && exit
			;;
		-*)
			usage_error "unrecognized option: $1"
			;;
		*)
			break
			;;
	esac
	shift
done

INPUT_FILE="$1"
SUB_FILE="$2"
OUTPUT_FILE="$3"
declare -a missing_args=()
[[ -z "$INPUT_FILE" ]] && missing_args+=('INPUT_FILE')
[[ -z "$SUB_FILE" ]] && missing_args+=('SUB_FILE')
[[ -z "$OUTPUT_FILE" ]] && missing_args+=('OUTPUT_FILE')
if (( ${#missing_args[@]} != 0 )); then
	usage_error "the following arguments are required: $(join_words "${missing_args[@]}")"
fi

ffmpeg -i "$INPUT_FILE" -sn \
-filter:v "subtitles='$SUBS_FILE:force_style=BorderStyle=3,Fontsize=28'" \
-c:a copy -c:v libx264 -crf 24 -preset veryfast "$OUTPUT_FILE"
