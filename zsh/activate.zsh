#####################################################################

[ ! $_CA__SETTINGS_LOADED ] && source "${0:a:h}/settings.zsh"
[ ! $_CA__HELPERS_LOADED  ] && source "${0:a:h}/helpers.zsh"

#####################################################################

_CA__ACTIVATE() {
	_CA__RESTORE_ENVIRONMENT

	local PROJECT="$1"
	[ ! $PROJECT ] && {
		[ ! $_CA__IN_ZSH_PLUGIN ] && cd
		return 0
		}

	local PROJECT_PATH=$(_CA__GET_FULL_PATH $PROJECT)
	[ ! -d $PROJECT_PATH ] && return 1

	local SOURCE_PATH="$PROJECT_PATH/$_CA__SOURCE_DIR_NAME"
	[ ! -d $SOURCE_PATH ] && return 1

	_CA__ACTIVATE_VIRTUAL_ENV $PROJECT_PATH
	_CA__ACTIVATE_CUSTOM_ENV  $PROJECT_PATH
	_CA__ACTIVATE_SOURCE_PATH $SOURCE_PATH

	_CA__TMUX_WINDOW_RENAME $PROJECT
}

_CA__ACTIVATE_VIRTUAL_ENV() {
	local PROJECT_PATH="$1"
	local ACTIVATE="$PROJECT_PATH/$_CA__VIRTUAL_ENV_NAME/bin/activate"
	local NO_ENV="$PROJECT_PATH/$_CA__NO_ENV_SENTINEL"

	[ -f $ACTIVATE ] && {
		source $ACTIVATE 
	} || {
		[ ! -f $NO_ENV ] && {
			_CA__INTERACTIVE_ENV_SETUP $PROJECT_PATH && source $ACTIVATE
		}
	}
}

_CA__ACTIVATE_CUSTOM_ENV() {
	local PROJECT_PATH="$1"
	local CUSTOM_ENV="$PROJECT_PATH/$_CA__CUSTOM_ENV_NAME"

	[ ! -f $CUSTOM_ENV ] && _CA__INIT_CUSTOM_ENV $PROJECT_PATH
	source $CUSTOM_ENV
}

_CA__ACTIVATE_SOURCE_PATH() {
	local SOURCE_PATH="$1"
	cd $SOURCE_PATH
}

#####################################################################

export _CA__ACTIVATE_LOADED=1
