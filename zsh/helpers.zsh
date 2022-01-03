_CA__TMUX_WINDOW_RENAME() {
	local PROJECT="$1"

	[[ $TERM =~ ^tmux- ]] \
		&& tmux rename-window "$(dirname $PROJECT):$(basename $PROJECT)"
}

_CA__TMUX_RESTORE_WINDOW_NAME() {
	[[ $TERM =~ ^tmux- ]] \
		&& tmux set automatic-rename on
}
