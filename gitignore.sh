#!/bin/bash

PROG=gitignore
VERSION=1.0.0
XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
DATA_HOME="$XDG_DATA_HOME"/luciferdisciple/gitignore
REPO_DIR="$DATA_HOME/gitignore"

usage() {
	echo "usage: $PROG [-h] [--list] [-V] LANG" >&2
}

print_help() {
	usage
	echo
	cat >&2 <<-END
	Put a .gitignore file in the current working directory for a specific
	language or runtime environment, obtained from
	https://github.com/github/gitignore.git
	
	positional arguments:
	  LANG         language or framework name that you want to get a
	               .gitignore for
	
	optional arguments:
	  -h, --help     show this help message and exit
	  --list        print valid values for LANG argument and exit
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

ensure_git_installed() {
	if ! which git &>/dev/null; then
		error "Required 'git' program is not available on the system."\
		      "Install it."
	fi
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

list_available_gitignores() {
	(cd $REPO_DIR && find . -maxdepth 1 -name '*.gitignore') |
		sed 's:^[.]/::; s/[.]gitignore$//' |
		sort |
		column
}

ensure_git_installed
ensure_local_repo

while :; do
	case "$1" in
		-h|--help)
			print_help
			exit
			;;
		-V|--version)
			echo $VERSION && exit
			;;
		--list)
			list_available_gitignores
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

source_gitignore_file="$REPO_DIR/$language.gitignore"

if [[ ! -r "$source_gitignore_file" ]]; then
	error "no .gitignore available for '$language'"
fi

cp "$source_gitignore_file" .gitignore
