This repository renders `markdown` source docs with
[mediabuilder](https://github.com/nsheff/mediabuilder) and
[pandoc](https://pandoc.org/). See [setup.md](/setup.md) for instructions.

# Grant template

Fork this repository to write a new markdown grant. Leave the above notice
intact to guide unfamiliar users to instructions for building output.

## Example

You can build the [specific aims](/src/specific_aims.md) document by typing:

```
make aims
```

You can build the entire [final merged output](/output/merged.pdf) by typing:

```
make all
```