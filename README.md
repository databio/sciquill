# <img src="docs/img/sciquill_light.svg" alt="sciquill logo" height="70">
 
Sciquill is an academic publishing system. It helps to author academic documents using `markdown` and `YAML`. Document types include grants, papers, biosketches, CVs, dissertations, letters... anything you might want to write in `markdown`, really.
Sciquill is more of a publishing philosophy than a piece of software. It contains some scripts to glue together various stages of the authoring pipeline, but primarily it relies on existing tools, notably, [pandoc](http://pandoc.org), [inkscape](http://inkscape.org), and [markmeld](https://github.com/databio/markmeld). It provides templates, styles, workflows, and scripts that make it simple to go from markdown text and structured YAML data to beautiful PDF or other outputs, all from inside GitHub or your local computer.
Sciquill brings us closer to the goal of authoring all types of scientific documents in markdown to completely [separate content from style](http://databio.org/posts/markdown_style.html).

For more information, see the [sciquill documentation](http://sciquill.databio.org).


## Description of repository

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

