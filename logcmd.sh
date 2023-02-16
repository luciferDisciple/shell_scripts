#!/bin/bash

PROG=logcmd
VERSION=1.0.1

usage() {
	echo >&2 "usage: $PROG [-h] COMMAND LOGFILE"
}

print_help() {
	usage
	cat >&2 <<-END
	
	Execute a COMMAND and save output to a LOGFILE.  Prompt and executed command are
	also recorded in the LOGFILE.
	
	positional arguments:
	  COMMAND       shell command, whose output will be captured
	  LOGFILE       path to the file, where shell session will be
	                appended to
	
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

echo_prompt() {
	echo "[$USER@$HOSTNAME $PWD]\$ $1"
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
cmd="$1"
logfile="$2"
declare -a missing_args
[[ -z "$cmd" ]] && missing_args+=(COMMAND)
[[ -z "$logfile" ]] && missing_args+=(LOGFILE)
if (( ${#missing_args[@]} != 0 )); then
	usage_error "the following arguments are required: $(join_words "${missing_args[@]}")"
fi
echo_prompt "$cmd" >>"$logfile"
{ eval "$cmd 2>&1" ; } | tee --append "$logfile"
