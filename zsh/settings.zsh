#####################################################################

[ ! $CODE_ACTIVATOR__DIRS ] && export CODE_ACTIVATOR__DIRS=("$HOME/Code")

export CODE_ACTIVATOR__KNOWN_TARGETS=(
	$CODE_ACTIVATOR__KNOWN_TARGETS
	'https://github.com/'
	'https://bitbucket.org/'
	'git@github.com:'
	'git@bitbucket.org:'
	)

#####################################################################

[ ! $_CA__SOURCE_DIR_NAME  ] && export _CA__SOURCE_DIR_NAME='code'
[ ! $_CA__VIRTUAL_ENV_NAME ] && export _CA__VIRTUAL_ENV_NAME='env'
[ ! $_CA__CUSTOM_ENV_NAME  ] && export _CA__CUSTOM_ENV_NAME='custom-env'
[ ! $_CA__NO_ENV_SENTINEL  ] && export _CA__NO_ENV_SENTINEL='.no-env'
[ ! $_CA__GIT_MAIN_BRANCH  ] && export _CA__GIT_MAIN_BRANCH='master'

[ ! $_CA__CUSTOM_ENV_TEMPLATE ] && export _CA__CUSTOM_ENV_TEMPLATE="${0:a:h}/custome-env-template.zsh"

FZF=(fzf -i --height=20% --layout=reverse)

#####################################################################

export _CA__SETTINGS_LOADED=1
