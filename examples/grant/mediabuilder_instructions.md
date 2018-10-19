# Mediabuilder instructions

This repository [separates content from
style](http://databio.org/posts/markdown_style.html) by authoring all documents
in `markdown` format. It uses a series of tools to render those documents in the
desired output style. It relies on [pandoc](https://pandoc.org/) for document
format conversion, [inkscape](http://inkscape.org) for SVG conversion,
[pandoc-citeproc](https://github.com/jgm/pandoc-citeproc) to manage citations,
and [nsheff/mediabuilder](http://github.com/nsheff/mediabuilder) for templates
and styles.

The repository is organized into these directories:
* [/assets](/assets) - Misc external built documents (*e.g.* PDFs)
* [/src](/src) - Markdown source for the documents
* [/fig](/fig) - `.svg` source for figures
* [/output](/output) - documents rendered from `src` by pandoc
* [Makefile](Makefile) - recipes for rendering documents from `src`

# Instructions

**Viewing**. If you're only interested in viewing the documents (not editing
them), you can either just view the built versions in the [/output](/output)
folder, or the markdown text source in the [/src](/src) folder.

**Editing**. If you want to edit the documents, you can contribute changes
directly into markdown files in [/src](/src). It is not necessarily to build the
outputs or install any additional software to contribute to the source.

**Building**. To build outputs, follow the setup instructions at
[nsheff/mediabuilder](http://github.com/nsheff/mediabuilder). After setting up
mediabuilder, you can use `make` to build an output (tab-complete or see the
[Makefile](/Makefile) to view available options).

# Tips

You can find more tips and recipes for how to build nice documents from markdown
source at [nsheff/mediabuilder](http://github.com/nsheff/mediabuilder).