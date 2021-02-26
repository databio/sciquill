# Sciquill

## Examples of input/output

The [examples](/examples) folder demonstrates what you can produce with mediabuilder. For each example there is a basic `Makefile`, which provides examples of recipes for building different media types. For example, this will render the example manuscript:

```
cd examples/manuscript
make manuscript
```

* [Manuscript](/examples/manuscript): Render the [.md manuscript source](examples/manuscript/src/manuscript.md) into [a generic manuscript PDF](examples/manuscript/output/manuscript.pdf), or use the [Oxford University Press Bioinformatics Template](examples/manuscript/output/manuscript_bioinformatics.pdf); or use the [Databio lab template](examples/manuscript/output/manuscript_twocol.pdf).
* [NIH biosketch](/examples/biosketch_simple): Render the [.md biosketch source](examples/biosketch_simple/src/nih_biosketch.md) into [a PDF](examples/biosketch_simple/output/nih_biosketch.pdf)
* [Grant](/examples/grant) (NIH-formatted):  Render the [.md grant source](examples/grant_simple/src/research_plan.md) into [a PDF](examples/grant_simple/output/research_plan.pdf)
* CV (pending).


## Building documents with mediabuilder


1. Install **software prerequisites**:

Really, just use Bulker (requires docker):

```
pip install bulker
bulker load databio/mediabuilder
bulker activate databio/mediabuilder
```


Or you can do it the hard way:
* Install [pandoc](https://pandoc.org/) to convert markdown to PDF.
* Install [inkscape](http://inkscape.org) to convert SVG to PDF.
* Install [libreoffice](http:///www.libreoffice.org) (optional) for some recipes that read `xls` or `docx` files.
* Install [ghostscript](http:///www.ghostscript.com) (optional) if you need to merge PDFs (should be standard on linux).


2. Clone and configure `mediabuilder`:
	* Clone [databio/sciquill](http://github.com/databio/sciquill)
	* Configure `mediabuilder`. The examples use an environment variable `$CODE`, in which you will store this repo:

	```
	export CODE=`pwd`
	git clone git@github.com:databio/sciquill.git
	```

	The latex templates in `tex_templates` rely on some relative includes. To use these you'll need to add the path to that folder to your `TEXINPUTS` environment variable. Adding something like this in your `.bashrc` will accomplish this permanently:

	```
	export TEXINPUTS="${TEXINPUTS}${CODE}/sciquill/tex_templates/:"
	```

	If using bulker, you will also need to make sure this variable is passed on to your bulker tools. So, add it to the list of `envvars` in your bulker config file.


3. Assemble your **BibTeX database** (optional).

	If you want to produce a media type that includes citations, you will also need a `bibtex` file with your references.  My favorite BibTeX management software is [JabRef](http://www.jabref.org), because it is free, actively developed, and uses BibTeX as its native file format. The default makefile ([mediabuilder.make](mediabuilder.make)) will use an `${BIBTEXDB}` environment variable to look for your `bibtex` database. You can set it like this:

	```
	export BIBTEXDB=path/to/db.bib
	```

4. Produce your **content in markdown format**. 

	You may choose to start with an example from the [examples folder](/examples).


## Description of mediabuilder repository

This repository contains:

* [tex_templates](/tex_templates) - a collection of tex templates for, *e.g.*
  NIH grants.
* [tex_utilities](/tex_utilities) - some bonus tex software to do things like
  add page numbers to an existing PDF
* [bin](/bin) - Small scripted utilities to build figures, extract
  bibliographies, suppress page numbers, merge PDFs, select versions of grant
  source files, etc. Documented in [/bin/README.md](/bin).
* [csl](/csl) - Contains some citation styles, which are derived from the
  [citationstyles](http://citationstyles.org/) project repository, or from [Zotero collection](https://www.zotero.org/styles)
  (https://github.com/citation-style-language/styles); it's the set of styles I
  use frequently, with some possible additions or adjustments for particular
  things I need. You can use any style from that repository or define your own
* [docx_templates](/docx_templates) - Word document templates for different grant agencies. To be used in YAML RMarkdown header as 

```
output:
  word_document:
    reference_docx: styles.doc/NSF_grant_style.docx
```


## Docker containers

I've also produced [docker containers](https://github.com/nsheff/docker) for `pandoc`, `inkscape`, `libreoffice` that make this easier if you use docker:

```
docker pull nsheff/pandocker
docker pull nsheff/inkscape-docker
docker pull nsheff/libre
```

## bulker

There's a bulker manifest that makes it much simpler:

```
pip install bulker
bulker load databio/mediabuilder
bulker activate databio/mediabuilder
```



## Recipes

### Converting an `.xls` file to `.pdf` with `libreoffice`:
Running `libreoffice` on the command-line like this will silently fail if you
already have `libreoffice` running. If you use a containerized version, you can
get around that issue. Use my `libre` docker container so you can run it while the real one is open.


```{Makefile}
budget:
	echo "Make sure libreoffice isn't already open"
	libreoffice --headless --invisible --convert-to pdf \
	--outdir output \
	src/budget_worksheet.xlsx
```

To set page printing limits in libreoffice calc:  
- go to View > Page Break
- now select the area to print
- choose: Format > Print Ranges > Define


### Converting a `.docx` to `.pdf` with  `libreoffice`:
```
pdf:
	soffice --convert-to pdf output/toc.docx \
	--outdir output
```



### Merging PDFs with `ghostscript`:

```
merge:
	$(mbin)/mergepdf output/merged.pdf \
	output/title_page.pdf \
	output/research_proposal.pdf \
	output/assembly_plan.pdf
```

### Adding page numbers

To add page numbers:

1. put the PDF document into the `tex_utilities/addpages.tex` file.
2. Run: `pdflatex addpages.tex`
3. Page numbers are added at addpages.pdf!



### Figures

You can refer to figures by label instead of by number, which makes reordering figures within documents easy.  It also makes it possible to move figures from one document to another without renumbering.
```
![\label{abstract}Fig. \ref{abstract}: Example figure](fig/example_figure.png) 
```

Refer to figures with `\ref{label}`.



### Separate citation lists (how to separate bibliography into its own file)

By default, pandoc will include your references cited just right at the end of
the document. That works for some grants, but others want a separate reference
document. To accomodate this, we need to do 2 things: 1) make a
bibliography-only file; 2) suppress the bibliography in the main file.


1. make a bibliography-only file

I wrote a script that does this: [bin/getrefs](bin/getrefs)

You can run getrefs on your markdown files, and pipe the results pandoc:

``` getrefs document.md | pandoc ...```

However, **this will also include any commented references**, which is probably
not what you want. So, there's a more complicated recipe in the
[mediabuilder.make Makefile](mediabuilder.make) called `refs` that will do this for you. It looks like this: 

```
# Requires pandoc 2 with --strip-comments implemented
refs_nocomment:
	pandoc --strip-comments -t markdown `$(mbin)/ver src/specific_aims` \
	`$(mbin)/ver src/significance_innovation` \
	`$(mbin)/ver src/aim1` `$(mbin)/ver src/aim2` `$(mbin)/ver src/aim3` | \
	$(mbin)/getrefs | \
	pandoc -o output/references.pdf $(PANDOC_FLAGS)
```

2. Suppress the bibliography in the main `.md` files. 

One way to do this is to use a `csl` file that doesn't have a style for a
bibliography. I don't like that, though, because it requires mucking around with
style files, and you may want to produce a document with the bibliography some
time. The better alternative is this: In the file itself, put in a yaml header:

```{yaml}
---
suppress-bibliography: True	
---
```

Or, I also wrote a little helper script that will do this for you on-the-fly:
[bin/nobib](bin/nobib). Use it like getrefs:
```
$(mbin)/nobib file.md | \
pandoc \
-o output/approach.pdf \
```

That will suppress the bibliography in the output. Done!


# Testing sciquill with docker

## Start up the container for testing

docker run --rm -it --volume=`pwd`:/repo --volume=$HOME/code/mediabuilder:/mbdir  --env TEXINPUTS=/mbdir/tex_templates: --workdir="/repo" --network="host" --entrypoint sh pandoc/latex 

## Run the test

pandoc content.md -o content.pdf --template  /mbdir/tex_templates/twocol.tex


## The whole shebang

This line will test the entire process

docker run --rm -it --volume=`pwd`:/repo --volume=$HOME/code/mediabuilder:/mbdir  --env TEXINPUTS=/mbdir/tex_templates: --workdir="/repo" --network="host" --entrypoint pandoc databio/sciquill  src/content.md -o output/content.pdf  --template  /mbdir/tex_templates/twocol.tex

docker run --rm -it --volume=`pwd`:/repo --volume=$HOME/code/mediabuilder:/mbdir  --env TEXINPUTS=/mbdir/tex_templates: --workdir="/repo" --network="host" --entrypoint pandoc databio/sciquill  src/*.md -o output/content.pdf  --template  /mbdir/tex_templates/twocol.tex




docker run --rm -it --volume=`pwd`:/repo --volume=$HOME/code/mediabuilder:/mbdir  --env TEXINPUTS=/mbdir/tex_templates: --workdir="/repo" --network="host" --entrypoint make databio/sciquill  manu





bulker load -c bulker/bulker_config.yaml databio/sciquill -f sciquill_bulker_manifest.yaml -r



## Pandoc in containers

in the past I just used  `pandoc --filter wrapfig`, but this way, the pandoc image has to have python available. It works better to use a pipe so that each program can run in its own container; so now: `	pandoc -t json | $(wrapfig) | pandoc -f json \` This works.











