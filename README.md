# mediabuilder

This repository contains some assets (*e.g.* templates, style files) that are
useful for building grants, papers, or other media output from `markdown` files.
This helps bring us closer to the goal of authoring scientific documents in
markdown to complete separate content from style, as explained in my blog post
[on content and style: the beauty of
markdown](http://databio.org/posts/markdown_style.html).

If you write your paper/grant/blog/whatever in markdown format, you can use
[pandoc- citeproc](https://github.com/jgm/pandoc-citeproc) to automatically
generate a nice bibliography and seamlessly convert from one style to another
for journal submission.

## Getting started

You will need:

1. **Software prerequisites**.

	* [nsheff/mediabuilder](http://github.com/nsheff/mediabuilder) (this repository)
	* [pandoc](https://pandoc.org/) to convert from source
	* [nsheff/pandoc-wrapfig](http://github.com/nsheff/pandoc-wrapfig) to wrap figures concisely in PDFs

	Set an environment variable `$CODEBASE` to where you will store the above git
	repositories

	```
	export CODEBASE=`pwd`/
	git clone git@github.com:nsheff/mediabuilder.git
	git clone git@github.com:nsheff/pandoc-wrapfig.git
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


## How to use pandoc:

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

## Adding page numbers

To add page numbers:

1. put the PDF document into the `tex_utilities/addpages.tex` file.
2. Run: `pdflatex addpages.tex`
3. Page numbers are added at addpages.pdf!

## Separate citation lists (how to separate bibliography into its own file)

Some grants want a separate reference list; other grants want references just
right at the end of the document that references them. The latter is the
default, but for the former, we need to do 2 things: 1) make a bibliography-only
file; 2) suppress the bibliography in the main file.


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


2. Suppress the bibliography in the main md files. In the file itself, put in a yaml header:

---
suppress-bibliography: True	
---

Done!

