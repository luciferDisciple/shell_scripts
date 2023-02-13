#!/bin/bash

PROG=gitignore
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
DATA_HOME="$XDG_DATA_HOME"/luciferdisciple/gitignore
REPO_DIR="$DATA_HOME/gitignore"

usage() {
	echo "usage: $PROG [-h|--help] LANG" >&2
}

print_help() {
	usage
	echo
	cat >&2 <<-END
	Put a .gitignore file in the current working directory for a specific
	language or runtime environment, obtained from
	https://github.com/github/gitignore.git
	
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

ensure_data_dir() {
	if [[ ! -w "$DATA_HOME" ]]; then
		mkdir -p "$DATA_HOME" || error "unable to create directory: '$DATA_HOME'"
	fi
}

ensure_local_repo() {
	ensure_data_dir
	if [[ ! -r "$REPO_DIR" ]]; then
		(cd "$DATA_HOME" && git clone https://github.com/github/gitignore) &>/dev/null
	fi
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

ensure_local_repo

source_gitignore_file="$REPO_DIR/$language.gitignore"

if [[ ! -r "$source_gitignore_file" ]]; then
	error "no .gitignore available for '$language'"
fi

cp "$source_gitignore_file" gitignore
