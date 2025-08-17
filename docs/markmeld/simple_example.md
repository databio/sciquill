
# Simple example tutorial

## Definition of terms

- **configuration file** - A `yaml` file that configures markmeld and specifies targets (Default:  `_markmeld.yaml`).
- **target** - A specific recipe to run that usually builds an output.
- **data** - Content, either in markdown or yaml format, used to produce a target.
- **template** - A [jinja2](https://palletsprojects.com/p/jinja/) file defining how the input will be integrated to produce the output.

## A simple example

Here's `demo/_markmeld.yaml`, a simple example that produces a single basic target:

```yaml
targets:
  target1:
    output_file: "{today}_demo_output.pdf"  
    latex_template: pandoc_default.tex
    jinja_template: jinja_template.jinja
    command: |
        pandoc --template "{latex_template}" --output "{output_file}"
    data:
      yaml_files:
        - some_data.yaml
      md_files:
        some_text_data: some_text.md
```

This file specifies a single target, `target1`. This target can be built by specifying `mm target1` on the command line. Building target1 will read structured data from `some_data.yaml` and prose from `some_text.md`, integrated through the `jinja_template.jinja`. The integrated output of the template will be piped to `stdin` of the `pandoc` command to produce the output file named in the `output_file` variable.

## Using the command line

Markmeld gives you a series of CLI arguments:

- `mm` - List available targets concisely
- `mm -c <config>` - Specify a different config file (defaults to `_markmeld.yaml`).
- `mm -l` - List the available targets with their descriptions.
- `mm <target>` - Builds the target
- `mm <target> -p` - Prints out the output (what would be piped to the command on `stdin`)
- `mm <target> -d` - Dumps the structured input before melding with jinja, so you can see what your jinja template will be receiving. Useful for troubleshooting jinja templates.
- `mm <target> -e` - Explains the target -- shows you from the config file what this target is actually doing.

