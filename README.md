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

## Citation styles

The citation styles in [/csl](/csl) are derived from the
[citationstyles](http://citationstyles.org/) project repository
(https://github.com/citation-style-language/styles); it's the set of styles I
use frequently, with some possible additions or adjustments for particular
things I need.