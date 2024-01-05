#!/bin/bash

# directory arg autocomplete for `op`
_op_completion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		return
	fi

	PROJECTS_PATH="$HOME/[Pp]rojects/*/*"
	IGNORE_DIR="$HOME/[Pp]rojects/deploys/*"

	COMPREPLY=($(compgen -W compgen -W "$(find ${PROJECTS_PATH} -mindepth 0 -maxdepth 0 -type d -not -path ${IGNORE_DIR} -printf "%f\n")" "${COMP_WORDS[1]}"))
}
complete -F _op_completion op
