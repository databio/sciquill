# Alternative commands

The way markmeld works is that it uses your `jinja` template to integrate the content provided in a target's `data` section, and then it will pass the output of rendered template as `stdin` to an arbitrary command, which is specified in the target's `command` attribute. Typically, the rendered jinja template will produce markdown output, which we may call *melded output*, and markmeld then passes this to pandoc to convert to the final output to whatever output form, since markdown is the native input to pandoc. Because this use case is so common, markmeld has a default `command` attribute, which is this:

```
    command: pandoc --template "{latex_template}" --output "{output_file}"
```

If the intent of the target is to pass the rendered template output to pandoc like this, then you can simply omit the `command` and this will suffice for many targets. But, markmeld is really more flexible than this, and you can tweak it to do other things if you like. For example, you may not want to pass the input the pandoc. You may not even produce markdown from your jinja template. Or, you might want to run a different command, or not run a command at all. You can do all of this with markmeld. Here, we'll cover alternative commands, raw targets, and meta targets.

## Alternative commands: targets without pandoc

Sometimes, the melded output is *not* markdown, and is my end product directly. For example, I may want to produce a `csv` file representation of some data I had in yaml format. Markmeld can also do this. In this case, you would just change the `command`, and don't use pandoc.

```yaml
command: |
  cat > {output_file}
```

Then, your jinja template would spit out a csv file. This command basically just writes that to an output file. You can use it to get the output from jinja directly.

## Output-less targets

### Raw targets

In typical targets, the melded output is passed to the command (usually pandoc) on `stdin`. But, you may just want to execute some command, and not pass anything to it on `stdin`. This type of a target is called a "raw" target, and you specify it with `type: raw`. Then, the command will run directly, and not pass the template render as stdin.

```yaml
targets:
  target_without_output:
    type: raw
    command: |
      ...
```

### Meta targets

Another type of target is called a *meta target*, which is a target that runs no command at all. Use `type: meta` to flag a target as a meta target. Meta targets are useful for creating a single target that just runs a bunch of other targets, for example.

For example, `target1` is a meta target that just builds target2 and target3, then runs no other command:

```yaml
targets:
  target1:
    type: meta
    prebuild:
      - target2
      - target3
```

### Abstract targets

Another type of target is an *abstract target*, which is a target that can be imported, but not built. Abstract targets can also be `meta` or `raw` targets, so we don't specify them with `type`, but with `abstract: true`.

For example, `base_target` below is an abstract target that can be used as a template for other concrete targets. You can use abstract targets to set up re-usable parameter sets or other configurations that you can then inheret in other targets.

```yaml
targets:
  targbase_target:
    abstract: true
    bibfolder: /path/to/bib/
```