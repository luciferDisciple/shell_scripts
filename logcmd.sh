#!/bin/bash

function echo_prompt () 
{ 
	echo "[$USER@$HOSTNAME $PWD]\$ $1"
}

function show_help ()
{
	cat <<-END
	Usage: logcmd [OPTION] COMMAND LOGFILE
	Execute a COMMAND and save output to a LOGFILE.  Prompt and executed command are
	also recorded in the LOGFILE.
	
	  -h, --help    display this help and exit
	END
}

if [[ $1 = "-h" || $1 = "--help" ]]; then
	show_help
	exit
elif [[ $# -lt 2 ]]; then
	echo "logcmd: too few arguments" >&2
	exit 1
elif [[ $# -gt 2 ]]; then
	echo "logcmd: too many arguments" >&2
	exit 2
fi

cmd="$1"
logfile="$2"

echo_prompt "$cmd" >>"$logfile"
{ eval "$cmd 2>&1" ; } | tee --append "$logfile"

