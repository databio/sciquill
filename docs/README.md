# Sciquill

Sciquill helps you write your academic grant, paper, biosketch, or CV in markdown.
It provides templates, style files, and helper scripts that are useful for building PDFs from markdown using pandoc. 
This brings us closer to the goal of authoring all types of scientific documents in markdown to completely [separate content from style](http://databio.org/posts/markdown_style.html).

## Quick start

Assuming [prerequisites are installed](install.md), you invoke sciquill like this:

```
git clone git@github.com:databio/sciquill.git
cd sciquill/examples/manuscript
make
```



2. The latex templates in `tex_templates` rely on some relative includes. To use these you'll need to add the path to that folder to your `TEXINPUTS` environment variable. Adding something like this in your `.bashrc` will accomplish this permanently:

```
export TEXINPUTS="${TEXINPUTS}${CODE}/sciquill/tex_templates/:"
```

