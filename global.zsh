#####################################################################
### Artifacts and Operations ########################################
#####################################################################

_CA__LOCAL_CONFIG="$HOME/.config/code-activator-zsh/settings.zsh"


_CA_ERROR() { [ $_CA__SUPPRESS_ERROR ] || echo "CA::ERROR : $@" >&2; }

_CA_FZF() {
	local MSG="$@"
	[ ! $_NOSEP ] && MSG="$@ : "
	fzf -i --height=50% --layout=reverse $FLAGS --prompt $MSG
}
_CA_FZF_PRINT() { _NOSEP=$_NOSEP FLAGS=(--print-query) _CA_FZF $@ | tail -1; }

_CA_LOAD() { source $_CA/zsh/$1.zsh; }

_CA_READ() { read -k $1; echo; }

_CA_MULTILINE() { sed 's/\s\+/\n/g'; }

_CA_LIST() {
	local base_dir PROJECTS=()
	{
		for base_dir in $CA__DIRS
		do
			{ cd $base_dir; ls -d *; } \
				| awk '{print "'$(basename $base_dir)/'"$1;}'
		done
	}
}

#####################################################################
### Dependency Checking #############################################
#####################################################################

_CA__CHECK_DEPENDENCIES() {
	local D DEPENDENCIES=($@)
	for D in $DEPENDENCIES
	do
		command -v $D >/dev/null 2>&1 || {
			local LINK=$(_CA__GET_DEPENDENCY_LINK $D)
			echo "I require '$D', but it's not installed. $LINK" >&2
		}
	done
}

_CA__GET_DEPENDENCY_LINK() {
	local LINK

	case $1 in
		fzf ) LINK='https://github.com/junegunn/fzf' ;;
		jq  ) LINK='https://github.com/stedolan/jq' ;;
	esac

	[ $LINK ] && LINK='('$LINK')'
	echo $LINK
}
