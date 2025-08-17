# Configuration specification

This document explains how to configure markmeld.

A markmeld project is configured using a yaml configuration file, by default named `_markmeld.yaml`. This file specifies the things you want markmeld to build, which are called *targets*. Each target will include the data/content, the relevant templates, and anything else you want to include. Let's start with some quick definitions:


## Root configuration

The configurable attributes are:

- `version`: Should be "1" for the version 1 of the markmeld configuration specification.
- `targets`: a list of targets that can be built (described below)
- `target_factories`: a list of target factories (see [target factories](/target_factories))
- `imports`: A list of markmeld configuration files imported by the current file (see [imports](/imports))
- `imports_relative`: Exactly like `imports`, but the imported targets will be built relative to the importing file (see [imports](/imports))


## The targets block

The configuration file must define a `targets` block. In this example, `targets` is the only top-level attribute. This block contains a series of named targets. In this example configuration file, `target1` is the only target defined. Let's look deeper at the variables that define individual targets. 

## Target configuration

Under `target1`, we specify all the attributes of this target.

- **custom variables**: You can define variables, which are then available for your command. In this example, the command uses `{output_file}` and `{latex_template}`, which are defined as variables under the target. This attributes are made available to the build system, but not to the jinja templates.
- `jinja_template`: The `jinja_template` is a special variable that specifies the path to the jinja template that markmeld will use to render the output. The path is relative to the config file where it is defined (see [writing jinja templates](jinja_template.md)).
- `command`: The `command` attribute here is a special variable. It's the shell command to execute to build the target. The output of markmeld will be piped to this command on `stdin`. listed here turns out to be markmeld's default command, so in this case it could be omitted (see [commands](commands.md)).
- `type`: Specifies the type of target (see [commands](commands.md)).
- `data`: Finally, there's the `data` block, which is where the input content is specified.
This is the main section that points to the content. This block includes several sub-attributes:
    - `md_files`: a named list of markdown files, which will be made available to the templates
    - `md_globs`: Globs, where each file will be read, and available at the key of the filename.
    - `yaml_files`: a keyed list of yaml files to make available to the templates, under specified keys (to specify unkeyed files, use `yaml_globs_unkeyed`)
    - `yaml_globs`: a list of globs (regexes) to yaml files, which will be keyed by filename
    - `yaml_globs_unkeyed`: a list of globs (regexes) to yaml files, which will be directly available
    - `variables`: direct yaml data made available to the templates.
- `inherit_from`: Defines a base target; any base attributes will be available to the current target, with the local target taking priority in case of conflict (see [inheriting](inheriting.md))
- `loop`: used to specify a `multi-output` target (see [Multi-output targets](multi_output_targets.md))
- `prebuild`: A list of other targets to build before the current target is built (see [side targets](side_targets.md)).
- `recursive_render`: Defaults to true, but you can turn off if you want to NOT recursively render (see [recursive rendering](recursive_rendering.md)).

