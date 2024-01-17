#!/bin/bash

# directory arg autocomplete for `op`
_op_completion() {
	if [ "${#COMP_WORDS[@]}" != "2" ]; then
		return
	fi

	COMPREPLY=($(compgen -W "$(op --list)" "${COMP_WORDS[1]}"))
}
complete -F _op_completion op
