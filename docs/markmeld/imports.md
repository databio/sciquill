# Imports

It's super useful to define global config options, and then re-use them across projects. You can do this with `imports`. So I have a global config file, say `path/to/other/_markmeld.yaml`:

```yaml
targets:
  base_target:
    sciquill: /home/nsheff/code/sciquill/
    figczar: /home/nsheff/code/sciquill/pandoc_filters/figczar/figczar.lua
    highlighter: /home/nsheff/code/sciquill/pandoc_filters/change_marker/change_marker.lua
    multirefs: /home/nsheff/code/sciquill/pandoc_filters/multi-refs/multi-refs.lua
    csl: /home/nsheff/code/sciquill/csl/biomed-central.csl
    bibdb: /home/nsheff/code/papers/sheffield.bib
```

Now you use:
```yaml
imports:
  - path/to/other/_markmeld.yaml
```

And now I can use `{figczar}` and `{bibdb}` in `command` section of a `_markmeld.yaml` file. If you want to be really cool, maybe point to this config file with `$MARKMELD` and then use:

```yaml
imports:
  - $MARKMELD
```

It works! Imports are in priority order, and lower priority than whatever you have in the local file, like `css`.  You can also use `inherit_from` on imported targets:

```yaml
imports:
  - path/to/other/_markmeld.yaml
targets:
  my_local_target:
    inherit_from: base_target      <--- defined in imported file
    data:
      ...
```



## Relative imports

In general `imports`, any relative paths will be considered **relative to the importing file**. This allows you to define targets that expect some relative files, and then use those for different files of the same names in different directories.

But sometimes you want to import a remote target and keep its relative paths relative to import**ed** file. For that, you can use `imports_relative`:

```yaml
imports:
  - these/targets/are/relative/to/here/_markmeld.yaml
imports_relative:
  - these/targets/are/relative/to/there/_markmeld.yaml
```

One thing that can be tricky: if you import a file in `relative_imports`, and that file imports another, with `imports`... Then the targets in the second fill will be considered relative to the first file. That's because they are *relative to the importing file*, which in this case, is the first imported file. So, this can be a bit confusing if you are nesting relative imports. My advice is to just not import anything in a file that's imported with `imports_relative`.

