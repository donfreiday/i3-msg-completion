#!/usr/bin/env bash

_i3msg-options() {
	local cur
	_get_comp_words_by_ref -n : cur
	local args="-q, --quiet             Only send ipc message and suppress the output of the response.
-v, --version           Display version number and exit.
-h, --help              Display a short help-message and exit.
-s, --socket {path}     i3-msg will use the environment variable I3SOCK or the socket path given here
-t {type}               Send ipc message. This option defaults to \"command\".
-m, --monitor           Wait for all events instead of terminating after first. Requires \"-t subscribe\"
"
	COMPREPLY=( $(compgen -W "$args" -- "$cur") )
}

_i3msg-messages() {
	local cur
	_get_comp_words_by_ref -n : cur

	local args="
command            A command for i3 that will be executed directly after receiving it
get_workspaces     Gets a JSON-encoded list of workspaces
get_outputs        Gets a JSON-encoded list of outputs; see https://i3wm.org/docs/ipc.html#_receiving_replies_from_i3
get_tree           Gets a JSON-encoded layout tree which includes every container
get_marks          Gets a JSON-encoded list of window marks (identifiers for containers to easily jump to them later)
get_bar_config     Gets the configuration of the workspace bar with the given ID, or an array with all configured bar IDs
get_binding_modes  Gets a list of configured binding modes.
get_version        Gets the version of i3. The reply will be a JSON-encoded dictionary with the major, minor, patch and human-readable version.
get_config         Gets the currently loaded i3 configuration.
send_tick          Sends a tick to all IPC connections which subscribe to tick events.
subscribe          Subscribe to events; pon reception, each event will be dumped as a JSON-encoded object. See the -m option for continuous monitoring.
"

	COMPREPLY=( $(compgen -W "$args" -- "$cur") )

	# Prevent colons from messing up completion
    [[ -n "$(type -t __ltrim_colon_completions)" ]] && __ltrim_colon_completions "$cur"
}

_i3msg() {
	local cur prev
 
 	# Use bash-completion to 
	_get_comp_words_by_ref -n : cur
	_get_comp_words_by_ref -n : -p prev

	# Set bash internal field separator to '\n'
	# This allows us to provide descriptions of options and tasks
	local OLDIFS="$IFS"
	local IFS=$'\n'

	if [[ ${cur} == -* ]]; then
		_i3msg-options
	else
		_i3msg-messages
	fi

	IFS="$OLDIFS"

	return 0
}

complete -F _i3msg i3-msg

#complete -W "move exec exit restart reload shmlog debuglog border layout append_layout workspace focus kill open fullscreen sticky split floating mark unmark resize rename nop scratchpad swap title_format mode bar gaps" i3-msg
