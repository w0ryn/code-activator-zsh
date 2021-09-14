#####################################################################

[ ! $_CA__SETTINGS_LOADED ] && source "${0:a:h}/settings.zsh"
[ ! $_CA__HELPERS_LOADED  ] && source "${0:a:h}/helpers.zsh"

#####################################################################

_CA__ACTIVATE() {
	_CA__RESTORE_ENVIRONMENT

	local PROJECT="$1"
	[ ! $PROJECT ] && { cd; return 0; }

	local PROJECT_PATH=$(_CA__GET_FULL_PATH $PROJECT)
	[ ! -d $PROJECT_PATH ] && { cd; return 0; }

	_CA__ACTIVATE_VIRTUAL_ENV $PROJECT_PATH
	_CA__ACTIVATE_CUSTOM_ENV  $PROJECT_PATH
	_CA__ACTIVATE_SOURCE_DIR  $PROJECT_PATH

	_CA__TMUX_WINDOW_RENAME $PROJECT
}

_CA__ACTIVATE_VIRTUAL_ENV() {
	local PROJECT_PATH="$1"
	local ACTIVATE="$PROJECT_PATH/$_CA__VIRTUAL_ENV_NAME/bin/activate"
	local NO_ENV="$PROJECT_PATH/$_CA__NO_ENV_SENTINEL"

	[ -f $ACTIVATE ] && {
		source $ACTIVATE 
	} || {
		[ -f $NO_ENV ] && {
			echo 'no virtual environment here, boss!'
		} || { 
			_CA__INTERACTIVE_ENV_SETUP $PROJECT_PATH
		}
	}
}

_CA__ACTIVATE_CUSTOM_ENV() {
	local PROJECT_PATH="$1"
	local CUSTOM_ENV="$PROJECT_PATH/$_CA__CUSTOM_ENV_NAME"

	[ ! -f $CUSTOM_ENV ] || {
		source $CUSTOM_ENV && echo 'custom environment active'
	}
}

_CA__ACTIVATE_SOURCE_DIR() {
	local SOURCE_DIR="$1/$_CA__SOURCE_DIR_NAME"
	cd $SOURCE_DIR
}

#####################################################################

export _CA__ACTIVATE_LOADED=1
