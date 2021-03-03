# Configuring sciquill

In sciquill, documents (or collections of related documents) are organized as repositories.
Sciquill is configured in a `Makefile` placed in your repository's root.

The basic `Makefile` contains a few configurable options and then includes the parent sciquill makefile. Here's a basic example:

```make
# Sciquill configuration ------------------------------------------------------
# sqdir - points to your sciquill repository
# sqtype - sciquill media type: 'sqmanuscript', 'sqcv', or 'sqgrant'

sqdir = ${SQDIR}
sqtype = sqmanuscript
include $(sqdir)/sciquill.make
```

Here, `$SQDIR` must point to the `sciquill` directory (the repository you clone from GitHub).



## Configurable options

You can change default behavior by adding in any of these options:

- `sqtype`: Select the media type. Built-in types include: `sqmanuscript`, `sqcv`.
- `bib`: path to your bibtex file (use this to override the default, which uses `$BIBTEXDB`).
- `csl`:  style file
- `lettertemplate`: template for letter
- `textemplate`: LaTeX template
- `manuscript_token`:  a string identifying which source file identifies your supplement source markdown file. Defaults to `manuscript`
- `supplement_token`: a string identifying which source file identifies your supplement source markdown file. Defaults to `supplement`.


## Default target

When you type `make` without any parameters, you'll build the default target. GitHub Actions will build the default target. The built-in media types have sensible default targets. 

You can configure this by changing the default target in your `Makefile`:

```
.DEFAULT_GOAL := default
```

What if you want GitHub to build 2 different targets? You can also set the default target to build two targets by making a new target that depends on two other targets:

```
.DEFAULT_GOAL := twotargets

twotargets: manuscript cover_letter
```



