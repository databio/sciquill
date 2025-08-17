# Install

Use some variant of:

```
pip install markmeld
```

## Testing

Markmeld provides the `mm` executable. You can test using the demos in the mm repository if you clone it:

```
cd demo
mm default
```

This will produce the output, automatically piping to pandoc. You can also get the raw output with `-p`, like this:

```
mm default -p > rendered.md
```

Next, move on to basic configuration.
