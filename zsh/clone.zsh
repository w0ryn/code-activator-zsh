#####################################################################

[ ! $_CA__SETTINGS_LOADED ] && source "${0:a:h}/settings.zsh"
[ ! $_CA__HELPERS_LOADED  ] && source "${0:a:h}/helpers.zsh"
[ ! $_CA__ACTIVATE_LOADED  ] && source "${0:a:h}/activate.zsh"

#####################################################################

_CA__CLONE() {
	local BASE_DIR="$1"
	local REMOTE_TARGET="$2"
	local PROJECT_NAME="$3"
	
	[ ! $BASE_DIR ] && BASE_DIR=$(_CA__SELECT_BASE_DIR)
	[ ! $BASE_DIR ] && return 1

	[ ! $REMOTE_TARGET ] && REMOTE_TARGET=$(_CA__GET_REMOTE_TARGET)
	[ ! $REMOTE_TARGET ] && return 1
	echo $REMOTE_TARGET
	[[ $REMOTE_TARGET =~ .git$ ]] || return 1

	[ ! $PROJECT_NAME ] && PROJECT_NAME=$(_CA__GET_PROJECT_NAME $REMOTE_TARGET)
	[ ! $PROJECT_NAME ] && return 1

	local PROJECT_PATH="$BASE_DIR/$PROJECT_NAME"

	[ -d $PROJECT_PATH ] && {
		echo "project '$PROJECT_NAME' already exists in '$(basename $BASE_DIR)'"
		return 1
	}
	
	mkdir $PROJECT_PATH
	[ ! $IS_NEW_PROJECT ] && _CA__CLONE_SOURCE $REMOTE_TARGET $PROJECT_PATH
	_CA__INIT_CUSTOM_ENV $PROJECT_PATH

	_CA__ACTIVATE "$(basename $BASE_DIR)/$PROJECT_NAME"
}


__CA__CLONE() {
	local state

	_arguments \
		'1: :->base_dir' \
		'2: :->project_name' \
		'3: :->remote_target' \
		':: :->arguments' \
		;

	case $state in
		base_dir )
			for dir in $CODE_ACTIVATOR__DIRS; do compadd $dir; done
			;;
		project_name )
			;;
		remote_target )
			;;
		arguments ) ;;
	esac
}

#####################################################################

_CA__CLONE_SOURCE() {
	local REMOTE_TARGET="$1"
	local PROJECT_PATH="$2"
	local SOURCE_DIR="$PROJECT_PATH/$_CA__SOURCE_DIR_NAME"

	echo "trying to clone '$REMOTE_TARGET' to '$PROJECT_PATH'"
	git clone "$REMOTE_TARGET" "$SOURCE_DIR" >/dev/null 2>&1 || {
		echo "failed to clone '$REMOTE_TARGET'"

		printf "is this a new project? [y/N]"
		_CA__READ_K yn
		[[ $yn =~ ^[yY] ]] && {
			printf 'initializing project...'
			{
				mkdir $SOURCE_DIR \
					&& cd $SOURCE_DIR \
					&& git init \
					&& touch .gitignore \
					&& git add .gitignore \
					&& git commit -m 'project init' \
					&& git remote add "$_CA__GIT_MAIN_BRANCH" $REMOTE_TARGET \
					&& cd .. \
					;
			} >/dev/null >&1 && echo ' success :)' || echo ' failed :c'
		} || { 
			rm -rf -- $PROJECT_PATH
			echo 'exiting'
			return 1
		}
	}
}

#####################################################################

export _CA__CLONE_LOADED=1
