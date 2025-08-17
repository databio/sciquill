# Writing Jinja templates for markmeld

The data content for a target is specified in the markmeld config through a variety of options under a target's `data` attribute, such as `md_files`, `yaml_globs`, and more. Markmeld loads this data and then runs it through a jinja template. To write a template, you'll need to be able to reference specific data elements. This document explains how to do that for each of the various ways of specifying data for a target.

## `*_files` directives

For `md_files`, `yaml_files` you specify a key for each file, and your content will be available under the key you defined. For example, if you have the following `_markmeld.yaml` file:

```
targets:
  my_target:
    data:
      md_files:
        my_md_file: path/to/file1.md
      yaml_files:
        my_yaml_file: path/to/file2.yaml
```

You can then access them in the jinja template as jinja variables, like this. For markdown files, the content is directly accessible using the key:

```jinja
{{ my_md_file }}
```

You can also access the frontmatter for an individual `.md` file with `{{ _local_frontmatter.my_md_file }}`.

For yaml files, using the key directly will get you a dictionary of the yaml content, which you can then access using sub-attributes, like this:

```jinja
{{ my_yaml_file.variable_defined_in_file2 }}
```



## `*_globs` directives

If you are using the `md_globs`, or `yaml_globs` directives, the content of the files will be available under corresponding filename (without extension). For example, for this config file:

```
targets:
  my_target:
    data:
      md_globs:
        - path/to/file1.md
      yaml_globs:
        - path/to/file2.yaml
```

You'd reference content in your jinja template with:

```jinja
{{ file1 }}

{{ file2.variable_defined_in_file2 }}
```

### `yaml_globs_unkeyed` directive

The `yaml_globs_unkeyed` directive behaves a bit differently. Unlike markdown content, yaml content can be keyed natively (within the file), and sometimes you may need to rely on these keys directly, instead of using a filename, the yaml content is available directly as specified in the file.  Your markdown items will be available under the key you specify in the config. 

## Special variables

In addition to the variables you define in your `data` section, you'll automatically have access to some markmeld-produced variables:

- `{_today}`: Today's date in standard form (YYYY-MM-DD).
- `{_now}`: Current time in seconds since UNIX epoch.
- `{_global_frontmatter}`: Integrated frontmatter across all provided `.md` files. (Details below)
- `{_local_frontmatter}`: Array of frontmatter from individual markdown files.
- `{_md}`: the keyed content you specified in your `_markmeld.yaml` config in `md_files` and `md_globs`.
- `{_yaml}`:  the keyed content you specified in your `_markmeld.yaml` config in `md_files` and `md_globs`.

## Global frontmatter

The `{{ _global_frontmatter }}` is a really useful markmeld-produced variable that integrates frontmatter across all provided sources programatically. The rationale here is that you may be combining a bunch of `.md` files, each with its own frontmatter, and you may also want to supplement that with standalone `.yaml` files that are also defining frontmatter. If your goal is to produce an integrated document, then what you want is a merged frontmatter block that combines the variables from all of these sources. 

You could just write a jinja template to integrate them, but then you could accidentally include the same information multiple times; this is complicated to handle with jinja in every template, and pandoc also chokes if you provide multiple of the same key. To address this, markmeld provides the `_global_frontmatter` variable, which integrates your yaml frontmatter within markmeld. This will accumulate any yaml information from:

- The frontmatter on any `.md` files included via `md_files` or `md_globs`.
- Any yaml that is keyed with the regex `frontmatter_*`, from `yaml_files` or `yaml_globs`. There is no way to add frontmatter from `yaml_globs_unkeyed`.
- Any variables with keys that match the regex `frontmatter_*`, where the `*` will be used as the keys added to the frontmatter.

When values clash, the priority is as listed above. Markmeld then formats the final values into 3 different forms, so you can access these for various use cases. The 3 variables are:

- `{{_global_frontmatter.fenced}}` -- in raw, fenced yaml. Useful if you want to produce integrated frontmatter for an output `.md` file. If the frontmatter is empty, fences are automatically omitted.
- `{{_global_frontmatter.raw}}` -- in raw, unfenced yaml.
- `{{_global_frontmatter.dict}}` -- A dict version, so you can access individual elements, like `{{_global_frontmatter.dict.var2}}`


## Local frontmatter

Sometimes you need to access the frontmatter from a specific md file, rather than the global integrated version. You can also do that with: `_local_frontmatter.<VAR>`, Where `<VAR>` is the key for the markdown file. Like the `_global_frontmatter` variable, local frontmatter is also provided in 3 forms: `_local_frontmatter.<VAR>.fenced`, `_local_frontmatter.<VAR>.raw`, and `_local_frontmatter.<VAR>.dict`.


## Raw content

Sometimes I want the actual file itself, not processed at all. That's available in `_raw.<VAR>`

## Variables

`_global_vars.<VAR>` is under construction. I'm still trying to see if this is useful.
