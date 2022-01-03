_CA_ACTIVATE() {
	local PROJECT="$1"
	[ ! $PROJECT ] && return 1

	local PROJECT_PATH=$(_CA__GET_FULL_PATH $PROJECT)
	[ ! -d $PROJECT_PATH ] && return 1


	_CA_ACTIVATE_ENV $PROJECT_PATH
	return 0
}

_CA__GET_FULL_PATH() {
	local PROJECT="$1"

	local PROJECT_ROOT_SHORT=$(dirname $PROJECT)
	local PROJECT_NAME=$(basename $PROJECT)

	local FULL_BASE_DIR=$(\
		echo $CA__DIRS \
			| _CA_MULTILINE \
			| grep "^.*/$PROJECT_ROOT_SHORT$" \
		)

	echo "$FULL_BASE_DIR/$PROJECT_NAME"
}

#####################################################################

_CA_DEACTIVATE() {
	_CA_RESTORE_ENV
	cd
}
