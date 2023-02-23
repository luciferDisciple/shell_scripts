#!/bin/bash

PROG=overlaysubs
VERSION=1.1.0

usage() {
	echo >&2 "usage: $PROG [-e POSITION] [-h] [-s POSITION] [-V] INPUT_FILE SUBS_FILE OUTPUT_FILE"
}

print_help() {
	usage
	cat >&2 <<-END
	
	Add rendered subtitles directly onto the video stream of a video file.
	
	positional arguments:
	  INPUT_FILE    source video file
	  SUBS_FILE     file with subtitles for source video file
	  OUTPUT_FILE   name of a file, where the result will be written to
	
	optional arguments:
	  -e, --end-at POSITION
	                 output just a part of the video, ending at specified moment
	                 in the input
	  -h, --help     show this help and exit
	  -s, --start-at POSITION
	                 output just a part of the video, starting at the specified
	                 moment in the input
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

declare -a ffmpeg_opt_ss=()
declare -a ffmpeg_opt_to=()
while :; do
	case "$1" in
		-h|--help)
			print_help && exit
			;;
		-e|--end-at)
			[[ $# -lt 2 ]] && usage_error "argument $1: expected one argument"
			ffmpeg_opt_ss=('-to' "$2")
			shift
			;;
		-s|--start-at)
			[[ $# -lt 2 ]] && usage_error "argument $1: expected one argument"
			ffmpeg_opt_to=('-ss' "$2")
			shift
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
SUBS_FILE="$2"
OUTPUT_FILE="$3"
declare -a missing_args=()
[[ -z "$INPUT_FILE" ]] && missing_args+=('INPUT_FILE')
[[ -z "$SUBS_FILE" ]] && missing_args+=('SUBS_FILE')
[[ -z "$OUTPUT_FILE" ]] && missing_args+=('OUTPUT_FILE')
if (( ${#missing_args[@]} != 0 )); then
	usage_error "the following arguments are required: $(join_words "${missing_args[@]}")"
fi

ffmpeg -i "$INPUT_FILE" -sn \
	-filter:v "subtitles='$SUBS_FILE:force_style=BorderStyle=3,Fontsize=28'" \
        -c:a copy \
	-c:v libx264 \
	-crf 24 \
	-preset veryfast \
	"${ffmpeg_opt_ss[@]}" \
	"${ffmpeg_opt_to[@]}" \
	"$OUTPUT_FILE"
