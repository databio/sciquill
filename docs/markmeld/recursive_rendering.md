## Recursive rendering

If you want a jinja variable to hold a variable, then you'll have to render the template recursively. Really, we'll just render it twice, since that's all I've needed so far.

But sometimes, you *don't* want to render it recursively, like if you want to actually show jinja variables in an output. So, we need it to be possible to choose for a given target. You do that with `recursive_render`, which can be True (default) or False.

So, generally you don't need to worry about this, and you can automatically go 2 layers deep, which means your variables can contain jinja variables. But if you want to turn it off, do it with:

```
targets:
  my_non_recursive_target:
    recursive_render: false
    data:
      ...
```
