#!/bin/zsh
 ###################################################################
#                                                                   #
# code-activator() : a terminal-based navigation utility            #
#                                                                   #
 ###################################################################

_CA__VERSION=1.0.1
_CA__DEPENDENCIES=(code-activator fzf jq git)

#####################################################################

export _CA=${0:a:h}

source $_CA/global.zsh || return 1
source $_CA/config.zsh || return 1

for Z in $(ls $_CA/zsh/*); do source $Z || return 1; done

#####################################################################

code-activator() {
	_CA__CHECK_DEPENDENCIES $_CA__DEPENDENCIES || return 1

	local COMMAND ARGS

	case $1 in
	    deactivate ) COMMAND=DEACTIVATE ;;

		clone ) COMMAND=CLONE; ARGS=(${@:2}) ;;
		new   ) COMMAND=NEW;   ARGS=(${@:2}) ;;

		* ) COMMAND=ACTIVATE; ARGS=(${@:1}) ;;
	esac

	_CA_$COMMAND $ARGS
}

source $_CA/activator.completion.zsh
source $_CA/activator.bindings.zsh
