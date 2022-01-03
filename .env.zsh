#####################################################################
# code-activator artifact                                           #
#####################################################################
#                                                                   #
# Variables and functions set in this file will be sourced when     #
# this project is activated                                         #
#                                                                   #
#                                                                   #
# Using the following syntax:                                       #
# ```                                                               #
# __RESTORE__ENV_VAR='new-value'                                    #
# ```                                                               #
# will save the current value of $ENV_VAR then assign ENV_VAR to    #
# the 'new-value'. When code-activator calls deactivate, ENV_VAR    #
# will be reset to its original value.                              #
#                                                                   #
# this only works with VARIABLES (not functions)                    #
#                                                                   #
#                                                                   #
#                                                                   #
# all other variables / functions will simply be unset whenever:    #
#   - deactivate is called                                          #
#   - another project is activated                                  #
#                                                                   #
#####################################################################

export __RESTORE__PATH="$PATH"

export MY_EXAMPLE_VARIABLE=69
