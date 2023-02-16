#!/bin/bash

PROG=flac2mp3
VERSION=1.0.0

usage () {
	echo >&2 "usage: $PROG [-h] [-V] FLAC [FLAC...]"
}

print_help() {
	usage
	cat >&2 <<-END
	
	Transcode flac FILEs into mp3 files while preserving the tags. Audio in the
	output files will have the average bitrate of 190kb/s.
	
	positional arguments:
	  FLAC          path to an audio file in flac format
	
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

info() {
	local message="$@"
	echo "$PROG: $message" >&2
}

while :; do
	case "$1" in
		-h|--help)
			print_help
			exit
			;;
		-V|--version)
			echo $VERSION && exit
			;;
		-*)
			usage_error unrecognized option: "$1"
			;;
		*)
			break
	esac
	shift
done
flac_files=("$@")
if (( ${#flac_files[@]} == 0 )); then 
	usage_error 'the following arguments are required: FLAC'
fi
for flac_file in "${flac_files[@]}"; do
	[[ -f "$flac_file" ]] || error "can't read '$flac': no such file or directory"
done
declare -i i=1
declare -i total_count="${#flac_files[@]}"
for flac_file in "${flac_files[@]}"; do
	flac_basename=${flac_file%.*}
	mp3_file="${flac_basename}.mp3"
	[[ -f "$mp3_file" ]] && error "File '$mp3_file' already exists."
	info "converting file $i of $total_count: '${flac_file}'"
	ffmpeg -hide_banner \
		-loglevel warning \
		-i "${flac_file}" \
		-c:a libmp3lame \
		-q:a 2 \
		-map_metadata 0 \
		-id3v2_version 3 \
		"${mp3_file}"
	i+=1
done
