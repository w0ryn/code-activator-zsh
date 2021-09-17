#####################################################################

# Store initial PATH; allows for safe PATH manipulation for a particular project
export _CA__RESTORE_PATH="$PATH"

# Store a list of project-specific environment variables; unset on env exit
export _CA__RESTORE_ENV=(
	__CUSTOM_ENV_ACTIVE
	)

#####################################################################

# example env var
export __CUSTOM_ENV_ACTIVE=69
