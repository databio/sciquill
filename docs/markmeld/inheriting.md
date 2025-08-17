# Target inheritance

Sometimes you want to define multiple targets that all share some content, or template, or other properties. Markmeld handles this with the `inherit_from` directive.

Example:

```yaml
targets:
  base_target:
    ...
  target2:
    inherit_from: base_target
    data:
      ...
```

If a target has an `inherit_from` attribute, then one or more targets will first be pre-loaded and processed. The targets are loaded in the order listed, with the specified target the last one, so attributes with the same name will have the highest priority.
