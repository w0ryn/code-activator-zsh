_CA__CUSTOM_ENV_SET_VARIABLES() {
	[ $_CA_ENV ] && [ -f $_CA_ENV ] || return
	local env_var

	for env_var in $(_CA__CUSTOM_ENV_GET_RESTORE_NAMES)
	do
		eval 'export __RESTORE__'$env_var'=$'$env_var
	done

	eval "$(sed 's/__RESTORE__//g' $_CA_ENV)"
}

_CA__CUSTOM_ENV_UNSET_VARIABLES() {
	[ $_CA_ENV ] && [ -f $_CA_ENV ] || return
	local var

	for var in $(_CA__CUSTOM_ENV_GET_VARIABLE_NAMES)
	do
		[[ ! $var =~ ^PATH$ ]] && unset $var
	done

	for var in $(_CA__CUSTOM_ENV_GET_FUNCTION_NAMES)
	do
		unset -f $var
	done

	for var in $(_CA__CUSTOM_ENV_GET_RESTORE_NAMES)
	do
		eval 'export '$var'=$__RESTORE__'$var
		unset __RESTORE__$var
	done

	for var in $(_CA__CUSTOM_ENV_GET_FUNCTION_NAMES)
}

_CA__CUSTOM_ENV_INIT() {
	[ ! -f $_CA_ENV ] && {
		cp "$_CA/.env.zsh" $_CA_ENV
	}
}

#####################################################################

_CA__CUSTOM_ENV_GET_VARIABLE_NAMES() {
	 grep -- '^[^#][^=]*=.' $_CA_ENV \
		| _CA_SED__VARIABLE_NAME | sort -u
}

_CA__CUSTOM_ENV_GET_FUNCTION_NAMES() {
	{
		grep -- '[^ #]*()' $_CA_ENV
	} | sed 's/().*//; s/^function //' | sort -u
}

_CA__CUSTOM_ENV_GET_RESTORE_NAMES() {
	grep -- '^[^#][^=]*=.' $_CA_ENV | grep '__RESTORE__' \
		| _CA_SED__VARIABLE_NAME | sort -u
}

#####################################################################

_CA_SED__VARIABLE_NAME() {
	sed 's/^export //; s/=.*//; s/__RESTORE__//g' 
}
