_CA__GIT_CLONE() {
	local PROJECT_PATH="$1"
	local REMOTE_TARGET="$2"
	local SOURCE_DIR="$PROJECT_PATH/$CA__SOURCE_DIR"

	[ -d $PROJECT_PATH ] && {
		echo "project '$PROJECT_NAME' already exists in '$(basename $BASE_DIR)'"
		return 1
	}

	echo "trying to clone '$REMOTE_TARGET' to '$PROJECT_PATH'"
	git clone "$REMOTE_TARGET" "$SOURCE_DIR" >/dev/null 2>&1 || {
		_CA_ERROR "failed to clone '$REMOTE_TARGET'"

		printf "is this a new project? [y/N]"
		_CA_READ yn
		[[ $yn =~ ^[yY] ]] && {
			_CA__GIT_INIT $PROJECT_PATH $REMOTE_TARGET || return 1
		} || {
			printf "cleaning up code-activator artifacts..."
			rmdir $PROJECT_PATH
			echo 'done'
		}
	}
}

_CA__GIT_INIT() {
	local PROJECT_PATH="$1"
	local REMOTE_TARGET="$2"
	local SOURCE_DIR="$PROJECT_PATH/$CA__SOURCE_DIR"

	[ -d $PROJECT_PATH ] && {
		echo "project '$PROJECT_NAME' already exists in '$(basename $BASE_DIR)'"
		return 1
	}

	printf "initializing '$(basename $PROJECT_PATH)'..."
	{
		mkdir -p $SOURCE_DIR \
			&& cd $SOURCE_DIR \
			&& git init \
			&& touch .gitignore \
			&& git add .gitignore \
			&& git commit -m '[INIT] repo initialized!' \
			&& git remote add origin $REMOTE_TARGET \
			;
	} >/dev/null 2>&1 && echo 'success!' || {
		echo 'failed to initialize repo; cleaning up'
		[ ! -d $SOURCE_DIR/.git ] && rm -rf $PROJECT_PATH
		return 1
	}
}
