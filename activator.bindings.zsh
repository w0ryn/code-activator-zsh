#####################################################################

[[ $CA__DISABLE_ALIAS -eq 0 ]] && {
	alias $CA__ALIAS='code-activator'
}

#####################################################################

[[ $CA__DISABLE_SHORTCUT -eq 0 ]] && command -v zle >/dev/null 2>&1 \
	|| return 0

_CA__ZSH_SHORTCUT_PLUGIN() {
	local OPTIONS=($(_CA_GET_LIST))
	[ $_CA_ENV ] && OPTIONS=(deactivate $OPTIONS)

	local SELECTION=$(echo $OPTIONS | _CA_MULTILINE | _CA_FZF 'select a project')
	[[ $SELECTION =~ . ]] && code-activator $SELECTION
	echo
	zle reset-prompt
}

zle -N codeactivator _CA__ZSH_SHORTCUT_PLUGIN
bindkey $CA__SHORTCUT codeactivator
