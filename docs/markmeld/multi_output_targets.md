# Multi-output targets

Typical targets produce only a single output. But sometimes, it's useful to specify a single target and have it produce multiple outputs, which we call *multi-output targets*. To define a multi-output target, you  specify a *loop* variable in the target definition, which has two sub-variables: an array (with the content to iterate over for each output), and a variable name to populate with each array element. 

## Motivation

This is useful for something like a mail merge, where you'd write a single letter, but want to produce it with slight differences such as the name of the recipient. Another use case is that you want to load in a large piece of data one time (like a list of publications), and then produce several different versions or subsets of it without reloading the input.

The use case for multi-output targets is really intended for outputs that are almost identical. If you want one target to produce two or more targets that are very different, then your best bet is to define each target separately and then use a meta-target to build them simultaneously.

## Quick start

Create a multi-output target by adding a loop variable to a target in `_markmeld.yaml`:

```yaml
targets:
  target_name:
    loop:
      loop_data: recipients
      assign_to: recipient
```

The *loop* attribute has two sub-attributes:

- **loop_data**: Specify the name of the object that contains the array you want to loop over. This target will create one output per element in this array. The array can be either of primitive types (like strings), or can be an array of objects.
- **assign_to**: This is the name of the variable that each element in loop_data will be assigned to. This is how you will access the individual element, both in the command templates and in the jinja templates.

## Loop data: array of strings

In the simple example, the array data (found in `some_data.yaml`) looks like this:

```yaml
recipients:
  - "John Doe"
  - "Jane Doe"
```

This target will create 1 output for each recipient.

### Loop data: array of objects

If you have a more complicated needs, like more than one element per loop iteration, then you can use an array of objects like this:

```yaml
recipients:
  - name: "John Doe"
    institution: "University of Virginia"
  - name: "Jane Doe"
    institution: "Brigham Young University"
```

See how the `_markmeld.yaml` file uses this information:

```yaml
targets:
  default:
    output_file: "{today}_demo_output_{recipient}.pdf"
    jinja_template: jinja_template.jinja
    recursive_render: false
    loop:
      loop_data: recipients
      assign_to: recipient
    data:
      md_files:
        some_text_data: some_text.md
      yaml_globs_unkeyed:
      - some_data.yaml
  complex_loop:
    output_file: "{today}_demo_output_complex_{recipient[name]}.pdf"
    jinja_template: jinja_template_complex.jinja
    recursive_render: false
    loop:
      loop_data: recipients
      assign_to: recipient
    data:
      md_files:
        some_text_data: some_text.md
      yaml_globs_unkeyed:
      - complex_loop.yaml
```

We just have to make sure the `output_file` variable uses the `assign_to` variable in some way (in this case, it's `{recipient}`). This will create a separate output, with a separate output file name, for each iteration of the loop. The jinja template specified in `md_template` should also use `recipient`, so that each output is unique.

You thus produce multiple outputs with a single `mm` build call.