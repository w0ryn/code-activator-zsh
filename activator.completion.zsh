#####################################################################
command -v compdef >/dev/null 2>&1 || return 0
#####################################################################

_CA__PROJECT_COMPADD() {
	local DESCRIPTIONS=()

	[ $_CA_ENV ] && DESCRIPTIONS+='deactivate:deactivate env and jump to $HOME'
	DESCRIPTIONS+='clone:clone a project from a known target'
	DESCRIPTIONS+='new:create a new project'

	_describe 'commands' DESCRIPTIONS

	compadd -- $(_CA_LIST)
}

#####################################################################

_code-activator() {
	local state

	_arguments \
		'1: :->project' \
		'2: :->arg1' \
		;

	case $state in
		project ) _CA__PROJECT_COMPADD ;;
		arg1 )
			case $words[2] in
				clone )
					echo; echo 'where should I clone this?'
					compadd -- $CA__DIRS
					;;
			esac
			;;
	esac
}

compdef _code-activator code-activator
