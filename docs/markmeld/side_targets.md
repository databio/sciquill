# Side targets

Side targets are additional targets that are built along with a target, either before or after the primary target is built. 

For example, you can add a 'prebuild' attribute in `_markmeld.yaml`:

```yaml
targets:
  prep_target1:
    ...
  prep_target2:
    ...    
  main_target:
    prebuild: 
    - prep_target1
    - prep_target2
```

The values under `prebuild` must be the keys of other targets. If you build `main_target`, Markmeld will first build the `prebuild` targets in the order listed before building the requested target. You can also specify `postbuild` targets. These targets will be built *after* the primary target is built.

```yaml
targets:
  post_target1:
    ...
  post_target2:
    ...    
  main_target:
    postbuild: 
    - post_target1
    - post_target2
```

The `prebuild` and `postbuild` side targets must be defined somewhere, but you could define them either in the same configuration file or in an imported configuration file. I'm using prebuild targets to build figures to make sure they are updated before a manuscript build, or to splitting a PDF into different pages after building. For these use cases, it makes sense for your pre-build targets to be of `type: raw`, since they won't actually produce markmeld outputs directly.
