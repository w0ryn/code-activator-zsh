_CA_ACTIVATE_ENV() {
	local PROJECT_PATH="$1"
	local SOURCE_PATH="$PROJECT_PATH/$CA__SOURCE_DIR"

	_CA_RESTORE_ENV

	export _CA_ENV=$PROJECT_PATH/$CA__CUSTOM_ENV

	[ -d $SOURCE_PATH ] && {
		_CA__CUSTOM_ENV_INIT
		_CA__CUSTOM_ENV_SET_VARIABLES $PROJECT_PATH
		_CA__ENV__ACTIVATE $PROJECT_PATH
		cd $SOURCE_PATH
	} || {
		cd $PROJECT_PATH
	}

	_CA__TMUX_WINDOW_RENAME $PROJECT
}

_CA__ENV__ACTIVATE() {
	local PROJECT_PATH="$1"
	local NO_ENV="$PROJECT_PATH/$CA__NO_ENV"

	local ACTIVATE="$PROJECT_PATH/$CA__VIRTUAL_ENV/bin/activate"
	[ -f $ACTIVATE ] && {
		source $ACTIVATE 
	} || {
		[ ! -f $NO_ENV ] && {
			_CA__INTERACTIVE_ENV_SETUP $PROJECT_PATH && source $ACTIVATE
		}
	}
}

#####################################################################

_CA_RESTORE_ENV() {
	deactivate >/dev/null 2>&1
	deactivate_node >/dev/null 2>&1

	_CA__CUSTOM_ENV_UNSET_VARIABLES

	_CA__TMUX_RESTORE_WINDOW_NAME

	unset _CA_ENV
}
