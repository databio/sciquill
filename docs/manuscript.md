# Building a manuscript with sciquill

## Examples of input/output

The [examples](/examples) folder demonstrates what you can produce with mediabuilder. For each example there is a basic `Makefile`, which provides examples of recipes for building different media types. For example, this will render the example manuscript:

```
cd examples/manuscript
make manuscript
```

* [Manuscript](/examples/manuscript): Render the [.md manuscript source](examples/manuscript/src/manuscript.md) into [a generic manuscript PDF](examples/manuscript/output/manuscript.pdf), or use the [Oxford University Press Bioinformatics Template](examples/manuscript/output/manuscript_bioinformatics.pdf); or use the [Databio lab template](examples/manuscript/output/manuscript_twocol.pdf).