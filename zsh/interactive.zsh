_CA__SELECT_BASE_DIR() {
	local BASE_NAMES=()

	for dir in $CA__DIRS; do BASE_NAMES+=$(basename $dir); done
	BASE_NAMES=$(echo $BASE_NAMES | _CA_MULTILINE)

	SELECTION=$(echo $BASE_NAMES | _CA_FZF 'select base directory')

	[ $SELECTION ] && echo $CA__DIRS | _CA_MULTILINE | grep -- $SELECTION
}

#####################################################################

_CA__GET_REMOTE_TARGET() {
	local REMOTE_TARGET=$(\
		echo $CA__KNOWN_TARGETS \
		| _CA_MULTILINE | _CA_FZF_PRINT 'set a remote target' \
	)

	local FIRST_SELECTION="$REMOTE_TARGET"

	echo $CA__KNOWN_TARGETS | grep -q "$REMOTE_TARGET" && {
		REMOTE_TARGET="$REMOTE_TARGET$(_CA__GET_REPOS $REMOTE_TARGET )"
		[[ $REMOTE_TARGET == $FIRST_SELECTION ]] && return ''
	}

	echo $REMOTE_TARGET | grep -q '\.git$' || REMOTE_TARGET="$REMOTE_TARGET.git"
	echo $REMOTE_TARGET
}

_CA__GET_REPOS() {
	local REMOTE_TARGET="$1"

	# @TODO: github / bitbucket API integration
	echo | _NOSEP=1 _CA_FZF_PRINT "$REMOTE_TARGET"
}

#####################################################################

_CA__GET_PROJECT_NAME() {
	local REMOTE_TARGET="$1"
	local DEFAULT_NAME=$(basename $REMOTE_TARGET | sed 's/\.git$//')

	echo $DEFAULT_NAME | _CA_FZF_PRINT 'set local project name'
}
