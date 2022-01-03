# Code Activator
##### *A `zsh` utility for terminal-based project navigation*
[![Generic badge](https://img.shields.io/badge/junegunn-fzf-blueviolet.svg)](https://github.com/junegunn/fzf)
[![Generic badge](https://img.shields.io/badge/stedolan-jq-blueviolet.svg)](https://github.com/jq/)

Code Activator provides fast project navigation in the terminal through both an API and CLI.

## Contributing
See our [contributing guide](./docs/CONTRIBUTING.md) and [code of conduct](./docs/CODE_OF_CONDUCT.md).

## Installation
1. install dependencies [junegunn/fzf](https://github.com/junegunn/fzf) and [stedolan/jq](https://github.com/stedolan/jq)
1. clone this repo, and source the `activator.plugin.zsh` in your `zshrc`:
```shell
# replace <path-to>/code-activator with the appropriate path
git clone https://github.com/w0ryn/code-activator-zsh.git <path-to>/code-activator
echo 'source <path-to>/code-activator' >> $HOME/.zshrc
```

By default, Code Activator looks for projects in `~/Projects/GitHub` and `~/Projects/BitBucket`, but you can configure\* this in your `~/.config/code-activator-zsh/settings.zsh`.
It is highly recommended that, if nothing else, you configure `CA__DIRS` to group your projects as you please.

<sup>\**the configuration file is created the first time Code Activator is sourced*</sup>


## Usage
Code Activator commands can be invoked one of three ways:
1. directly (`code-activator`; intended for use as an API)
2. through an alias (`lkj` by default)
3. through a shortcut (`CTRL+SPACE` by default; creates a zsh-plugin)

With no argument, Code Activator provides a list of all available projects.
Select one to activate it's environment and jump to the project's root.

If your first argument to Code Activator is a project name, the specified project will be activated.

You can also `deactivate` an activated project, `clone` an existing project, or create a `new` project (with the appropriate command).


## Custom Environment
Although not exactly a virtual environment, Code Activator creates a `custom-env` for projects where you can set project-specific environment variables or shell functions.
It also provides a `__RESTORE__` syntax to allow safe manipulation of `PATH` or other variables when activating a project.
See [the custom-env template](./.env.zsh) for more details.

