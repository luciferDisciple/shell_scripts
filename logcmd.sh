#!/bin/bash

PROG=logcmd

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
	  -h, --help    display this help and exit
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

array_to_string() {
	local -n array=$1
	declare -n joined_string=$2
	printf -v joined_string '%s, ' "${array[@]}"
	joined_string="${joined_string%, }"
}

while :; do
	case "$1" in
		-h|--help)
			show_help
			exit
			;;
		-*)
			usage_error unrecognized option: "$1"
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
	array_to_string missing_args missing_args_comma_separated
	error_usage "the following arguments are required: $missing_args_comma_separated"
fi
echo_prompt "$cmd" >>"$logfile"
{ eval "$cmd 2>&1" ; } | tee --append "$logfile"
