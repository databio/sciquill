# Marking changes

Sometimes we need to provide a version of a manuscript with changes marked. To make this easier, you can use the sciquill *change marker* filter. 



Turn on change marking by adding this to your document metadata:

```
mark_changes: true
```

Then, identify changes by using the `{.changed}` attribute to a text span, like this:

> This text will not be marked. [This text was changed.]{.changed} This text was not changed and will not be marked.

You can then turn change marking on or off by just toggling the `mark_changes` setting, so you can just have a single source and build it with changes marked, and then without changes marked.

The default text mark color is `brickred` but you can change the color in the metadata:

```
change_color: blue
```
