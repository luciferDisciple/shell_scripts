#!/bin/bash

PROG=install.sh
VERSION=1.0.0
EXECUTABLES_DIR="$HOME/.local/bin"
SCRIPTS=$(ls *.sh | sed '/^install[.]sh$/d')

usage() {
	echo >&2 "usage: $PROG [-h] [-V] TARGET [TARGET...]"
	echo >&2 "       $PROG [-h] [-V] all"
}

print_help() {
	usage
	cat >&2 <<-END

	Install selected scripts or all scripts for use by the current user
	only. Executables will be placed in ~/.local/bin/.

	positional arguments:
	  TARGET         script's name

	optional arguments:
	  -h, --help     show this help and exit
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

script_install() {
	local normalized_name="${1%.sh}"
	local name_is_valid=false
	for script_name in $SCRIPTS; do
		if [[ "${normalized_name}.sh" == "$script_name" ]]; then
			name_is_valid=true
		fi
	done
	$name_is_valid || usage_error "invalid TARGET: $1"
	local src="$normalized_name.sh"
	local dst="$EXECUTABLES_DIR/$normalized_name"
	info "copying '$src' to '$dst'..."
	cp -f "$src" "$dst" || error "failed to copy '$src' to '$dst'"
}

ensure_executables_dir_exists() {
	mkdir -p "$EXECUTABLES_DIR"
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
ensure_executables_dir_exists
declare -a targets=("$@")
for target in "${targets[@]}"; do
	if [[ "$target" == 'all' ]]; then
		for script in $SCRIPTS; do
			script_install "$script"
		done
		info success
		exit
	fi
done
for target in "${targets[@]}"; do
	script_install "$target"
done
info success
