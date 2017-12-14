# mediabuilder

This repository contains some assets (*e.g.* templates, style files) that are
useful for building grants, papers, or other media output from `markdown` files.
This helps bring us closer to the goal of authoring scientific documents in
markdown to complete separate content from style, as explained in my blog post
[on content and style: the beauty of
markdown](http://databio.org/posts/markdown_style.html).

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
refs:
	$(getrefs) src/* | \
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


## Citation styles

The citation styles in [/csl](/csl) are derived from the
[citationstyles](http://citationstyles.org/) project repository
(https://github.com/citation-style-language/styles); it's the set of styles I
use frequently, with some possible additions or adjustments for particular
things I need.