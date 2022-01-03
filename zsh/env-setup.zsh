_CA__INTERACTIVE_ENV_SETUP() {
	local PROJECT_PATH="$1"
	local NO_ENV="$PROJECT_PATH/$_CA__NO_ENV_SENTINEL"

	printf 'set up a virtual environment now? [(Y)es / (n)o / n(e)ver] '
	_CA_READ yn

	case $yn in
		e ) touch $NO_ENV; return 1 ;;
		n ) return 1 ;;
	esac

	local ENV_VERSION=$(_CA__SELECT_VIRTUAL_ENV)
	[ ! $ENV_VERSION ] && return 1

	_CA__INIT_VIRTUAL_ENV $PROJECT_PATH $ENV_VERSION
}

#####################################################################

_CA__SELECT_VIRTUAL_ENV() {
	local VERSION=$(_CA__GET_VIRTUALENVS | _CA_FZF 'select an environment')

	[[ $VERSION =~ node ]] && {
		FIRST_PICK=$VERSION

		VERSION=$(nodeenv --list 2>&1 \
			| _CA_MULTILINE \
			| sort --reverse --human-numeric-sort \
			| _CA_FZF 'which node version?')

		[[ $VERSION == $FIRST_PICK ]] && return
	}

	echo $VERSION
}

#####################################################################

_CA__INIT_VIRTUAL_ENV() {
	local PROJECT_PATH="$1"
	local ENV_VERSION="$2"
	local ENV_PATH="$PROJECT_PATH/$_CA__VIRTUAL_ENV_NAME"

	[[ $ENV_VERSION =~ ^[0-9] ]]\
		&& _CA__INIT_NODE_ENV $ENV_PATH $ENV_VERSION \
		|| _CA__INIT_VIRTUALENV $ENV_PATH $ENV_VERSION \
		;
}

_CA__INIT_NODE_ENV() {
	local ENV_PATH="$1"
	local ENV_VERSION="$2"

	echo "setting up node env ($ENV_VERSION)"
	nodeenv --node=$ENV_VERSION $ENV_PATH
	echo "done"
}

_CA__INIT_VIRTUALENV() {
	local ENV_PATH="$1"
	local ENV_VERSION="$2"

	echo "setting up virtualenv ($ENV_VERSION)"
	virtualenv --python=$ENV_VERSION $ENV_PATH
	echo "done"
}

#####################################################################

_CA__GET_VIRTUALENVS() {
	whence -pm '*' | grep python | grep -v -- '-config$\|m$'
	which node 2>/dev/null
}
