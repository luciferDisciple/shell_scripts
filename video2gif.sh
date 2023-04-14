#!/bin/bash

PROG=video2gif
VERSION=1.1.0

usage() {
	echo >&2 "usage: $PROG [-f FPS] [-h] [-x HEIGHT] VIDEO_FILE"
}

print_help() {
	usage
	cat >&2 <<-END

	Convert a video file to a GIF. Resulting GIF will have framerate of 12
	FPS and the same base name as VIDEO_FILE, but with ".gif" extension.

	positional arguments:
	  VIDEO_FILE    a path to the video file you want to convert

	optional arguments:
	  -f, --framerate FPS
	                 set the animation framerate of the GIF (default: 12)
	  -h, --help     display this help and exit
	  -y, --height HEIGHT
	                 set the height of the GIF, keep aspect ratio
	                 (default: same as video)
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

scale_filter=
gif_height=
gif_fps=12

while :; do
	case "$1" in
		-f|--framerate)
			[[ $# -lt 2 ]] && usage_error "argument $1: expected one argument"
			gif_fps=$2
			shift
			;;
		--framerate=*?)
			gif_fps="${1#*=}"
			;;
		--framerate=)
			usage_error '"--framerate" requires a non-empty option argument'
			;;
		-h|--help)
			print_help
			exit
			;;
		-y|--height)
			[[ $# -lt 2 ]] && usage_error "argument $1: expected one argument"
			gif_height=$2
			shift
			;;
		--height=*?)
			gif_height="${1#*=}"
			;;
		--height=)
			usage_error '"--height" requires a non-empty option argument'
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

[[ "$gif_height" ]] && scale_filter=",scale=-1:$gif_height"

video_file="$1"
if [[ -z "$video_file" ]]; then
	usage_error 'the following arguments are required: VIDEO_FILE'
fi

basename="${video_file%.*}"
gif_file="${basename}.gif"
gif_filter="[0:v] fps=${gif_fps}${scale_filter},split [a][b];"
gif_filter+='[a] palettegen [p];[b][p] paletteuse'

ffmpeg -i "$video_file" \
       -filter_complex "$gif_filter" \
       "$gif_file" \
&& info "success: GIF saved to '$gif_file'"
