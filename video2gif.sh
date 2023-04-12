#!/bin/bash

PROG=video2gif
VERSION=1.0.0
GIF_HEIGHT=480
GIF_FPS=12

usage() {
	echo >&2 "usage: $PROG [-h] VIDEO_FILE"
}

print_help() {
	usage
	cat >&2 <<-END

	Convert a video file to a GIF. Resulting GIF will have a height
	of 480 pixels, framerate of 12 FPS, and the same base name as
	VIDEO_FILE, but with ".gif" extension.

	positional arguments:
	  VIDEO_FILE    a path to the video file you want to convert

	optional arguments:
	  -h, --help     display this help and exit
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
			usage_error "unrecognized option: $1"
			;;
		*)
			break
	esac
	shift
done

video_file="$1"
if [[ -z "$1" ]]; then
	usage_error 'the following arguments are required: VIDEO_FILE'
fi

basename="${video_file%.*}"
gif_file="${basename}.gif"
gif_filter="[0:v] fps=${gif_fps},scale=${gif_height}:-1,split [a][b];"
gif_filter+='[a] palettegen [p];[b][p] paletteuse'

ffmpeg -i "$video_file" \
       -filter_complex "$gif_filter" \
       "$gif_file"
