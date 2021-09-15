#####################################################################

# Store initial PATH; allows for safe PATH manipulation for a particular project
export RESTORE_PATH="$PATH"

# Store a list of project-specific environment variables; unset on env exit
export RESTORE_ENV=(
	CUSTOM_ENV_VAR
	)

#####################################################################

# example env var
export CUSTOM_ENV_VAR=69
