# Installing sciquill

## Install software prerequisites

Sciquill is not one piece of software, but a collection of templates, recipes, and scripts.
These scripts and templates require several open source tools, such as `pandoc` and `inkscape`.
Because sciquill handles the whole stack of creating documents, including authoring in markdown, figure layouts and generation, and building PDFs, there are a few prerequisites.

### Remote building with GitHub Actions

Sciquill can be easily set up to use github actions to build your documents in the cloud. You just edit markdown source files in your git repository, and then the output PDFs are built automatically via a github action. To use sciquill in this way, you don't need to install anything; just [set up the sciquill github action](github_actions.md). If you want to build things locally, then you can follow one of the approaches below. 

### Local building option 1: Use bulker

The easiest way to get everything you need is to just use [bulker](http://bulker.io), which is a container manager built on docker or singularity. If you have bulker already configured, then setting up sciquill is simple:

```console
pip install bulker
bulker load databio/sciquill
bulker activate databio/sciquill
```

You will also need to add the sciquill environment variables to your bulker config file:

```console
bulker envvars -a TEXINPUTS
bulker envvars -a SQDIR
bulker envvars -a BIBTEXDB
```

That alone will set up all the prerequisites you need to run sciquill.

### Local building option 2: Install everything natively

If you don't want to use bulker, the other option is to install everything natively.

* Install [pandoc](https://pandoc.org/) to convert markdown to PDF.
* Install [inkscape](http://inkscape.org) to convert SVG to PDF.
* Install [libreoffice](http:///www.libreoffice.org) (optional) for some recipes that read `xls` or `docx` files.
* Install [ghostscript](http:///www.ghostscript.com) (optional) if you need to merge PDFs (should be standard on linux).

## Configuring sciquill

After all the necessary is software is installed, you need to get the sciquill scripts and templates.

* Clone [databio/sciquill](http://github.com/databio/sciquill)
* Configure `sciquill`. The examples use an environment variable `$SQDIR` to point to this repository:

```console
git clone git@github.com:databio/sciquill.git
export SQDIR=`pwd`/sciquill
```

You'll want to add `export SQDIR=/path/to/sqdir` to your `.bashrc` so it will persist.


The latex templates in `tex_templates` rely on some relative includes. To use these, you'll need to add the path to that folder to your `TEXINPUTS` environment variable. Adding something like this in your `.bashrc` will accomplish this permanently (use your local path):

```console
export TEXINPUTS="${TEXINPUTS}${SQDIR}/tex_templates/:"
```

## Assemble your BibTeX database (optional).

If you want to produce a media type that includes citations, you will also need a `bibtex` file with your references.
My favorite BibTeX management software is [JabRef](http://www.jabref.org), because it is free, actively developed, and uses BibTeX as its native file format.
The default makefile ([sciquill.make](sciquill.make)) will use an `${BIBTEXDB}` environment variable to look for your `bibtex` database. You can set it like this:

```console
export BIBTEXDB=path/to/db.bib
```

As usual, make sure to put this in your `.bashrc` if you want it to persist.