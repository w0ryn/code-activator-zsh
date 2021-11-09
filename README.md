# Code Activator
##### *A `zsh` utility for terminal-based project navigation*
[![Generic badge](https://img.shields.io/badge/junegunn-fzf-blueviolet.svg)](https://github.com/junegunn/fzf)

The `CODE_ACTIVATOR` function facilitates terminal-based project navigation by providing an interactive, fuzzy-search CLI.

Generally, the CLI will activate a project's virtual environment then step into the project root.
Once inside a project, the CLI gives the option to deactivate and return to the user's home directory.

Projects can also be quickly cloned or created from scratch by using the `clone` and `new` operations respectively.

Use the plugin one of three ways:
1. Use the shortcut combination (`CTRL+SPACE` by default)
1. Use the alias (`lkj` by default)
1. Call `CODE_ACTIVATOR` directly (meant for use as an API)

## Installation
1. install [junegunn/fzf](https://github.com/junegunn/fzf)
1. clone this repo, and source the `*.plugin.zsh` in your `zshrc`:
```shell
# replace <path-to>/code-activator with the appropriate path
git clone https://github.com/w0ryn/code-activator-zsh.git <path-to>/code-activator
echo 'source <path-to>/code-activator' >> $HOME/.zshrc
```

## Configuration
All configuration options are determined by their respective environment variables.

### Basic Configuration
Environment Variable               | Default                         | Description
---------------------------------- | ------------------------------- | -----------
`CODE_ACTIVATOR__SHORTCUT`         | `^@` (a.k.a. CTRL+SPACE)        | shortcut for running `CODE_ACTIVATOR` as a plugin
`CODE_ACTIVATOR__DISABLE_SHORTCUT` | `0` (a.k.a. false)              | whether (or not) the shortcut runner is disabled
`CODE_ACTIVATOR__ALIAS`            | `lkj`                           | easy-to-type alias for running `CODE_ACTIVATOR`
`CODE_ACTIVATOR__DISABLE_ALIAS`    | `0` (a.k.a. false)              | whether (or not) the alias runner is disabled

### Project Directories
- `CODE_ACTIVATOR__DIRS` (list) environment variable

A list of fully-qualified paths to project parent directories.
Provides `($HOME/Code)` as a generic default, but allows for meaningful project grouping:
```shell
export CODE_ACTIVATOR__DIRS=(
	"$HOME/Company/Team1"
	"$HOME/Company/Team2"
	"$HOME/Miscellaneous"
	"$HOME/Personal"
)
```

### Known Targets
- `CODE_ACTIVATOR__KNOWN_TARGETS` (list) environment variable
- expects targets to end in `:` or `/` character
- *appends environment variable list to the default list*

A list of default completion targets for setting up or cloning new repositories.
Includes HTTP and GIT protocol targets for GitHub and BitBucket by default, but you may want to add your user to the list:
```shell
export CODE_ACTIVATOR__KNOWN_TARGETS=(
	'git@github.com:<your-username>/'
)
```
