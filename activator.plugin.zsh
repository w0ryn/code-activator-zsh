#!/bin/zsh
#####################################################################
#                                                                   #
# CODE_ACTIVATOR : a terminal-based navigation utility              #
#                                                                   #
#####################################################################

DEPENDENCIES=(
	fzf
	)

IMPORTS=(
	"${0:a:h}/zsh/settings.zsh"
	"${0:a:h}/zsh/helpers.zsh"
	"${0:a:h}/zsh/clone.zsh"
	"${0:a:h}/zsh/activate.zsh"
	)

#####################################################################

for DEPENDENCY in $DEPENDENCIES
do
	command -v $DEPENDENCY >/dev/null 2>&1 || {
		echo "I require '$DEPENDENCY' but it's not installed :c"
		ERROR_CODE=1
	}
done

#####################################################################

for IMPORT in $IMPORTS; do source $IMPORT; done

[ ! $_CA__ACTIVATE_LOADED ] && ERROR_CODE=2
[ ! $_CA__CLONE_LOADED    ] && ERROR_CODE=2

#####################################################################

[ $ERROR_CODE ] && return $ERROR_CODE

#####################################################################
#####################################################################

CODE_ACTIVATOR() {
	local ERROR=0

	case $1 in
	    deactivate ) _CA__RESTORE_ENVIRONMENT && cd || ERROR=1 ;;

		clone ) _CA__CLONE ${@:2} || ERROR=1 ;;
		  new ) IS_NEW_PROJECT=1 _CA__CLONE ${@:2} || ERROR=1 ;;
		    * ) _CA__ACTIVATE ${@:1} || ERROR=42 ;;
	esac

	[[ $ERROR -ne 0 ]] && _CA__ERROR_CLEANUP $ERROR

	return $ERROR
}

_CODE_ACTIVATOR() {
	local state

	_arguments \
		'1: :->project' \
		':: :->arguments' \
		;

	case $state in
		project )
			compadd $(_CA__GET_COMMANDS_AND_PROJECTS | sed 's/deactivate//')
			;;
		arguments )
			case $words[2] in
				clone ) __CA__CLONE ;;
			esac
			;;
	esac
}
compdef _CODE_ACTIVATOR CODE_ACTIVATOR

#####################################################################

_CA__GET_COMMANDS_AND_PROJECTS() {
	local COMMANDS=(deactivate clone new)
	local PROJECTS=()

	for base_dir in $CODE_ACTIVATOR__DIRS
	do
		for project_dir in $(ls -d -- $base_dir/*)
		do
			PROJECTS+=("$(basename $base_dir)/$(basename $project_dir)")
		done
	done

	echo $COMMANDS $PROJECTS
}

_CA__ERROR_CLEANUP() {
	local ERROR="$1"
	case $ERROR in 
		42 )
			echo 'failed to activate environment; aborting' >&2
			;;
	esac
}

#####################################################################

[[ $CODE_ACTIVATOR__DISABLE_SHORTCUT -eq 0 ]] && {
	_CA__ZSH_SHORTCUT_PLUGIN() {
		local OPTIONS=$(_CA__GET_COMMANDS_AND_PROJECTS | sed 's/\s\+/\n/g')
		[ ! $__CUSTOM_ENV_ACTIVE ] && OPTIONS=$(echo $OPTIONS | grep -v 'deactivate')

		local ARGUMENT=$(\
			echo $OPTIONS \
				| sed 's/\s\+/\n/g' \
				| $_CA__FZF --prompt 'select a project: ' \
		)

		_CA__IN_ZSH_PLUGIN=1 CODE_ACTIVATOR $ARGUMENT

		echo
		zle reset-prompt
	}
	zle -N codeactivator _CA__ZSH_SHORTCUT_PLUGIN
	bindkey $CODE_ACTIVATOR__SHORTCUT codeactivator
}

[[ $CODE_ACTIVATOR__DISABLE_ALIAS -eq 0 ]] && {
	alias $CODE_ACTIVATOR__ALIAS='CODE_ACTIVATOR'
}
