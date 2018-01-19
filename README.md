# mediabuilder

This repository provides templates, style files, and helper scripts that are
useful for building grants, papers, or other media output from `markdown` files.
Write your academic grant or paper in markdown. This repository bring us closer
to the goal of authoring scientific documents in markdown to completely
[separate content from style](http://databio.org/posts/markdown_style.html). It
uses [pandoc-citeproc](https://github.com/jgm/pandoc-citeproc) to automatically
generate a nice bibliography and seamlessly convert from one style to another
for journal submission or publication.

## Quick start

Check out the [newgrant repository](https://github.com/nsheff/newgrant) for a
template for a new grant or paper that uses mediabuilder. There, you will find a
basic [Makefile](https://github.com/nsheff/newgrant/blob/master/Makefile).

You will need:

1. **Software prerequisites**.

	* [pandoc](https://pandoc.org/) to convert from source
	* [nsheff/mediabuilder](http://github.com/nsheff/mediabuilder) (this repository)

	This repository contains a submodule for [nsheff/pandoc-
	wrapfig](http://github.com/nsheff/pandoc-wrapfig); To be complete, you will
	need to clone this repository with `--recursive`. Then, set an environment
	variable `$CODEBASE` to where you will store this repo:

	```
	export CODEBASE=`pwd`/
	git clone git@github.com:nsheff/mediabuilder.git --recursive
	```

2. **Markdown file**. 

	Your markdown file, with citations encoded using the Bibtex key, like
	"[@Sheffield2017]".

3. **BibTeX database**. 

	My favorite BibTeX management software is [JabRef](http://www.jabref.org),
	because it's free, uses BibTeX as its native file format, and actively
	developed.

4. **Citation style file**.

	In this repository are some citation styles in [/csl](/csl), which  are
	derived from the [citationstyles](http://citationstyles.org/) project
	repository (https://github.com/citation-style-language/styles); it's the set
	of styles I use frequently, with some possible additions or adjustments for
	particular things I need. You can use any style from that repository or
	define your own

## Recipes

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


### How to use pandoc

Pass the Bibtex database as your entry to `--bibliography`, and pass the
appropriate style file from the CSL repository to `--csl` like this. For
example, this command will create a PDF output using a latex template I made:

```
pandoc document.md -o output/document.pdf \
--filter ${CODEBASE}/pandoc-wrapfig/pandoc-wrapfig.py \
--template ${CODEBASE}mediabuilder/textemplate_paper.tex \
--bibliography ~/code/papers/sheffield.bib \
--csl path/to/style.csl
```



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

