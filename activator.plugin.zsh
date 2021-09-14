#!/bin/zsh
#####################################################################
#                                                                   #
# CODE_ACTIVATOR : a terminal-based navigation utility              #
#                                                                   #
#####################################################################

#####################################################################

DEPENDENCIES=(
	fzf
	)

IMPORTS=(
	"${0:a:h}/zsh/settings.zsh"
	"${0:a:h}/zsh/helpers.zsh"
	"${0:a:h}/zsh/activate.zsh"
	"${0:a:h}/zsh/clone.zsh"
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
		clone ) _CA__CLONE ${@:2}    || ERROR=1 ;;
		    * ) _CA__ACTIVATE ${@:2} || ERROR=2 ;;
	esac

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
			compadd clone

			for dir in $CODE_ACTIVATOR__DIRS
			do
				compadd "$(basename $dir)/$(basename $(ls -d -- $dir/*))"
			done
			;;
		arguments )
			case $words[2] in
				clone ) __CA__CLONE ;;
			esac
			;;
	esac
}
compdef _CODE_ACTIVATOR CODE_ACTIVATOR
