#####################################################################

[[ ${#CODE_ACTIVATOR__DIRS[@]} -eq 0 ]] && export CODE_ACTIVATOR__DIRS=("$HOME/Code")

export CODE_ACTIVATOR__KNOWN_TARGETS=(
	$CODE_ACTIVATOR__KNOWN_TARGETS
	'https://github.com/'
	'https://bitbucket.org/'
	'git@github.com:'
	'git@bitbucket.org:'
	)

[ ! $CODE_ACTIVATOR__SHORTCUT ] && export CODE_ACTIVATOR__SHORTCUT=' '
[ ! $CODE_ACTIVATOR__ALIAS    ] && export CODE_ACTIVATOR__ALIAS='lkj'

[ ! $CODE_ACTIVATOR__DISABLE_SHORTCUT ] && export CODE_ACTIVATOR__DISABLE_SHORTCUT=0
[ ! $CODE_ACTIVATOR__DISABLE_ALIAS    ] && export CODE_ACTIVATOR__DISABLE_ALIAS=0

#####################################################################

export _CA__SOURCE_DIR_NAME='code'
export _CA__VIRTUAL_ENV_NAME='env'
export _CA__CUSTOM_ENV_NAME='custom-env'
export _CA__NO_ENV_SENTINEL='no-env'
export _CA__GIT_MAIN_BRANCH='master'

export _CA__CUSTOM_ENV_TEMPLATE="${0:a:h}/custom-env-template.zsh"


#####################################################################

_CA__FZF=(fzf -i --height=20% --layout=reverse)
_CA__READ_K() { read -k $1; echo; }

#####################################################################

export _CA__SETTINGS_LOADED=1
