# Biosketch example

This folder contains an example of building an NIH biosketch entirely from structured data in either `yaml` or `markdown` format.


## Source

The `/src` folder contains the source, which is found in a few files:

- [src/biodata.yaml](src/biodata.yaml) contains some biographical information (name, NIH commons ID, etc), which is used to populate the biosketch template.
- [src/personal_statement.md](src/personal_statement.md) contains the personal statement
- [src/references.yaml](src/references.yaml) contains references used in the contribution citations sections, and in the 'publications to highlight' section.
- [src/contributions](src/contributions) contains multiple `.md` files, each outlining a contribution area, which can be mixed-and-matched for different biosketches.

## Building

The markmeld build recipes are specified in [_markmeld.yaml](_markmeld.yaml).

You can build the target like this:

```
cd sciquill/examples/biosketch_simple
mm biosketch
```

This will produce the output listed in [output](output).