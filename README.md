# mediabuilder

This repository helps you write your academic grant or paper in markdown. It
provides templates, style files, and helper scripts that are useful for building
grants, papers, or other media output from `markdown` files. This repository
bring us closer to the goal of authoring scientific documents in markdown to
completely [separate content from
style](http://databio.org/posts/markdown_style.html). It uses [pandoc-
citeproc](https://github.com/jgm/pandoc-citeproc) to automatically generate a
nice bibliography and seamlessly convert from one style to another for journal
submission or publication.

## Mediabuilder assets

This repository contains:

* [tex_templates](/tex_templates) - a collection of tex templates for, *e.g.*
  NIH grants.
* [tex_utilities](/tex_utilities) - some bonus tex software to do things like
  add page numbers to an existing PDF
* [bin](/bin) - Small scripted utilities to build figures, extract
  bibliographies, suppress page numbers, merge PDFs, select versions of grant
  source files, etc. More documentation to come.
* [csl](/csl) - Contains some citation styles, which are derived from the
  [citationstyles](http://citationstyles.org/) project repository, or from [Zotero collection](https://www.zotero.org/styles)
  (https://github.com/citation-style-language/styles); it's the set of styles I
  use frequently, with some possible additions or adjustments for particular
  things I need. You can use any style from that repository or define your own
* [styles.doc](/styles.doc) - Word document templates for different grant agencies. To be used in YAML RMarkdown header as 

```
output:
  word_document:
    reference_docx: styles.doc/NSF_grant_style.docx
```

## Quick start

1. Install and configurethe **software prerequisites**.

	* Install [pandoc](https://pandoc.org/) to convert from source
	* Clone [nsheff/mediabuilder](http://github.com/nsheff/mediabuilder) (this repository, cloned with `--recursive` to get the [nsheff/pandoc-wrapfig](http://github.com/nsheff/pandoc-wrapfig) submodule)
	* Configure `mediabuilder`. The examples use an environment variable `$CODEBASE`, to where you will store this repo:

	```
	export CODEBASE=`pwd`/
	git clone git@github.com:nsheff/mediabuilder.git --recursive
	```

2. Produce your content in **markdown** format. 

There are working examples of different media types in the [examples folder](/examples). There you can find a [grant](/examples/grant), paper (pending), CV (pending). For each example there is a
basic `Makefile`, which provides examples of recipes for building different media types. For these to work, you will need:	

3. **BibTeX database** (optional).

	If you want to produce a media type that includes citations, you will also need a `bibtex` file with your references.  My favorite BibTeX management software is [JabRef](http://www.jabref.org), because it's free, uses BibTeX as its native file format, and actively developed.

With these items, just follow some of the recipes below to use the mediabuilder
assets to help build your output.

## Recipes

### How to use pandoc with mediabuilder assets

Start pandoc with these options:

* `--filter`: ${CODEBASE}/pandoc-wrapfig/pandoc-wrapfig.py
* `--template`: Choose a template from `mediabuilder/tex_templates`
* `--bibliography`: Use your bibtex database
* `--csl`: Choose a `csl` file from `mediabuilder/csl`

For example, this command will create a PDF output:

```
pandoc document.md -o output/document.pdf \
--filter ${CODEBASE}/pandoc-wrapfig/pandoc-wrapfig.py \
--template ${CODEBASE}mediabuilder/textemplate_paper.tex \
--bibliography ~/code/papers/sheffield.bib \
--csl path/to/style.csl
```


### Converting an `.xls` file to `.pdf` with `libreoffice`:

```{Makefile}
budget:
	echo "Make sure libreoffice isn't already open"
	libreoffice --headless --invisible --convert-to pdf \
	--outdir output \
	src/budget_worksheet.xlsx
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


## Separate citation lists (how to separate bibliography into its own file)

By default, pandoc will include your references cited just right at the end of
the document. That works for some grants, but others want a separate reference
list. To do this, we need to do 2 things: 1) make a bibliography-only file; 2)
suppress the bibliography in the main file.


1. make a bibliography-only file

I wrote a script that does this: [bin/getrefs](bin/getrefs)

Just run getrefs on your markdown files, and pipe the results pandoc:

``` getrefs document.md | pandoc ...```

For example, add this to your Makefile:

```
mbin=${CODEBASE}mediabuilder/bin
refs:
	$(mbin)/getrefs src/* | \
	pandoc \
	-o output/references.pdf \
	--filter ${CODEBASE}/pandoc-wrapfig/pandoc-wrapfig.py \
	--template $(textemplate) \
	--bibliography $(bib) \
	--csl $(csl)
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

