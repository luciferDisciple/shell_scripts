#!/bin/bash

PROG=gitignore

usage() {
	echo "usage: $PROG [-h|--help] LANG" >&2
}

print_help() {
	usage
	cat >&2 <<-END
	Put a .gitignore file in the current working directory obtained from
	https://github.com/github/gitignore for a specific language or
	runtime environment.
	
	positional arguments:
	  LANG        language or framework that you want to get a .gitignore for
	
	optional arguments:
	  -h, --help   show this help message and exit
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
		-*)
			usage_error unrecognized option: $1
			;;
		*)
			break
	esac
	shift
done

language="$1"

if [[ -z $language ]]; then
	usage_error the following arguments are required: LANG
fi

if [[ -f .gitignore ]]; then
	error 'File .gitignore already present in the current directory. Aborting.'
fi

# massage "language" argument
language=${language,,}  # lowercase all characters
language=${language^}   # uppercase first character

url=https://raw.githubusercontent.com/github/gitignore/main/$language.gitignore

wget -LO .gitignore "$url"
