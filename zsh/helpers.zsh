#####################################################################

[ ! $_CA__SETTINGS_LOADED ] && source "${0:a:h}/settings.zsh"

#####################################################################

_CA__RESTORE_ENVIRONMENT() {
	deactivate >/dev/null 2>&1
	deactivate_node >dev/null 2>&1

	[ $_CA__RESTORE_PATH ] && export PATH="$_CA__RESTORE_PATH"
	[ $_CA__RESTORE_ENV  ] && for var in $_CA__RESTORE_ENV; do unset $var; done

	unset _CA__RESTORE_PATH _CA__RESTORE_ENV
}

_CA__GET_FULL_PATH() {
	local PROJECT="$1"

	local PROJECT_ROOT_SHORT=$(dirname $PROJECT)
	local PROJECT_NAME=$(basename $PROJECT)

	local FULL_BASE_DIR=$(echo $CODE_ACTIVATOR__DIRS | grep "^.*/$PROJECT_ROOT_SHORT$")

	echo "$FULL_BASE_DIR/$PROJECT_NAME"
}

_CA__TMUX_WINDOW_RENAME() {
	local PROJECT="$1"

	[[ $TERM =~ ^tmux- ]] \
		&& tmux rename-window "$(dirname $PROJECT):$(basename $PROJECT)"
}

_CA__SELECT_BASE_DIR() {
	local BASE_NAMES=()

	for dir in $CODE_ACTIVATOR__DIRS
	do
		BASE_NAMES=($BASE_NAMES $(basename $dir))
	done

	echo $CODE_ACTIVATOR__DIRS \
		| grep $(echo $BASE_NAMES | $FZF --prompt 'select base directory : ')
}

_CA__GET_REMOTE_TARGET() {
	local REMOTE_TARGET=$(\
		echo $CODE_ACTIVATOR__KNOWN_TARGETS \
		| sed 's/\s\+/\n/g' \
		| $FZF --print-query --prompt 'set a remote target : ' \
		| tail -1 \
	)

	local FIRST_SELECTION="$REMOTE_TARGET"

	echo $CODE_ACTIVATOR__KNOWN_TARGETS | grep -q "$REMOTE_TARGET" && {
		REMOTE_TARGET="$REMOTE_TARGET$(echo | $FZF --print-query --prompt "$REMOTE_TARGET" | tail -1)"
	}
	
	[[ $REMOTE_TARGET == $FIRST_SELECTION ]] && return ''

	echo $REMOTE_TARGET | grep -q '\.git$' || REMOTE_TARGET="$REMOTE_TARGET.git"
	echo $REMOTE_TARGET
}

_CA__GET_PROJECT_NAME() {
	local REMOTE_TARGET="$1"
	local DEFAULT_NAME=$(basename $REMOTE_TARGET | sed 's/\.git$//')

	echo $DEFAULT_NAME | $FZF --print-query --prompt 'set local project name : ' | tail -1
}

_CA__INTERACTIVE_ENV_SETUP() {
	local PROJECT_PATH="$1"
	local NO_ENV="$PROJECT_PATH/$_CA__NO_ENV_SENTINEL"

	printf 'set up a virtual environment now? [(Y)es / (n)o / n(e)ver] '
	read -k yn

	case $yn in
		e ) touch $NO_ENV; return 1 ;;
		n ) return 1 ;;
	esac

	local ENV_VERSION=$(_CA__SELECT_VIRTUAL_ENV)
	_CA__INIT_VIRTUAL_ENV $PROJECT_PATH $ENV_VERSION
}

_CA__SELECT_VIRTUAL_ENV() {
	local VERISON=$(\
		echo "$(_CA__GET_PYTHON_IN_PATH)\n$(which node 2>/dev/null)" \
			| $FZF --prompt 'select a virtual environment : ' \
		)

	[[ $VERSION =~ node$ ]] && VERSION=$(\
		nodeenv --list \
		| sed 's/\s\+/\n/g' \
		| $FZF --prompt 'select a node version : '\
	)

	echo $VERSION
}

_CA__GET_PYTHON_IN_PATH() {
	whence -pm '*' | grep python | grep -v -- '-config$'
}

_CA__INIT_VIRTUAL_ENV() {
	local PROJECT_PATH="$1"
	local ENV_VERSION="$2"
	local ENV_PATH="$PROJECT_PATH/$_CA__VIRTUAL_ENV_NAME"

	[[ $ENV_VERSION =~ ^[0-9] ]]\
		&& _CA__INIT_NODE_ENV $PROJECT_PATH $ENV_VERSION \
		|| _CA__INIT_VIRTUALENV $PROJECT_PATH $ENV_VERSION \
		;
}

_CA__INIT_NODE_ENV() {
	local ENV_PATH="$1"
	local ENV_VERSION="$2"

	nodeenv --node=$ENV_VERSION $ENV_PATH
}

_CA__INIT_VIRTUALENV() {
	local ENV_PATH="$1"
	local ENV_VERSION="$2"

	virtualenv --python=$ENV_VERSION $ENV_PATH
}

_CA__INIT_CUSTOM_ENV() {
	local PROJECT_PATH="$1"
	local CUSTOM_ENV="$PROJECT_PATH/$_CA__CUSTOM_ENV_NAME"
	local CUSTOM_ENV_TEMPLATE="$_CA__CUSTOM_ENV_TEMPALTE"

	cp $CUSTOM_ENV_TEMPLATE $CUSTOM_ENV
}

#####################################################################

export _CA__HELPERS_LOADED=1
