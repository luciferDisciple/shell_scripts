#!/bin/bash

PROG=logcmd
VERSION=2.1.0

usage() {
	echo >&2 "usage: $PROG [-h] [-V] [-q] COMMAND [COMMAND...] LOGFILE"
}

print_help() {
	usage
	cat >&2 <<-END
	
	Execute a COMMAND and save output to a file. Command prompts and commands will
	be written to the LOGFILE.
	
	positional arguments:
	  COMMAND       shell command, whose output will be captured
	  LOGFILE       path to the file, where shell session will be
	                appended to
	
	optional arguments:
	  -h, --help     display this help and exit
	  -V, --version  output version information and exit
	  -q, --quiet    print nothing to stdout, write only to LOGFILE
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

log_cmds_to_stdin_and_logfile() {
	local -a cmds=()
	while (( $# > 1 )); do
		cmds+=("$1")
		shift
	done
	local -a logfile="$1"
	for cmd in "${cmds[@]}"; do
		{ echo_prompt "$cmd" ; eval "$cmd 2>&1" ; } | tee --append "$logfile"
	done
	echo_prompt >>"$logfile"  # write final prompt with empty command line to LOGFILE
}

log_cmds_to_logfile_only() {
	local -a cmds=()
	while (( $# > 1 )); do
		cmds+=("$1")
		shift
	done
	local -a logfile="$1"
	for cmd in "${cmds[@]}"; do
		{ echo_prompt "$cmd" ; eval "$cmd 2>&1" ; } >>"$logfile"
	done
	echo_prompt >>"$logfile"  # write final prompt with empty command line to LOGFILE
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
		-q|--quiet)
			opt_quiet=true
			;;
		-*)
			usage_error "unrecognized option: $1"
			;;
		*)
			break
	esac
	shift
done
declare -a cmds=()
while (( $# > 1 )); do
	cmds+=("$1")
	shift
done
logfile="$1"
declare -a missing_args=()
(( ${#cmds[@]} == 0 )) && missing_args+=(COMMAND)
[[ -v "$logfile" ]] && missing_args+=(LOGFILE)
if (( ${#missing_args[@]} != 0 )); then
	usage_error "the following arguments are required: $(join_words "${missing_args[@]}")"
fi
if [[ -v opt_quiet ]]; then
	log_cmds_to_logfile_only "${cmds[@]}" "$logfile"
else
	log_cmds_to_stdin_and_logfile "${cmds[@]}" "$logfile"
fi
