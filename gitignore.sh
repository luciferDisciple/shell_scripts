#!/bin/bash

language="$1"

die() {
    local message="$@"
    echo $message >&2
    exit 1
}

if [[ $# -ne 1 ]]; then
	die Wrong number of arguments. Required: 1
fi

if [[ -f .gitignore ]]; then
	die File already .gitignore present in the current directory. Aborting.
fi

# massage "language" argument
language=${language,,}  # lowercase all characters
language=${language^}   # uppercase first character

url=https://raw.githubusercontent.com/github/gitignore/main/$language.gitignore

wget -LO .gitignore "$url"
