#####################################################################

# Store initial PATH; allows for safe PATH manipulation for a particular project
export RESTORE_PATH="$PATH"

# Store a list of project-specific environment variables; unset on env exit
export RESTORE_ENV=(
	__CUSTOM_ENV_ACTIVE
	)

#####################################################################

# example env var
export __CUSTOM_ENV_ACTIVE=69
