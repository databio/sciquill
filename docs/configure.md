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

There are only 2 required options to configure:

- `sqdir`: must point to the `sciquill` directory (the repository you clone from GitHub). Here, we use `$SQDIR`, so you can set an environment variable to point to it, which is convenient.
- `sqtype`: the media type. Built-in types include: `sqmanuscript`, `sqcv`.

You can change default behavior by adding in any of these options:

- `bib`: path to your bibtex file (use this to override the default, which uses `output/refs.bib` first, or if not found, then tries `$BIBTEXDB`).
- `csl`:  style file
- `lettertemplate`: template for letter
- `textemplate`: LaTeX template
- `manuscript_token`:  a string identifying which source file identifies your supplement source markdown file. Defaults to `manuscript`
- `supplement_token`: a string identifying which source file identifies your supplement source markdown file. Defaults to `supplement`.

```make
# Sciquill configuration ------------------------------------------------------
# sqdir - points to your sciquill repository
# sqtype - sciquill media type: 'sqmanuscript', 'sqcv', or 'sqgrant'

sqdir = ${SQDIR}
sqtype = sqmanuscript
include $(sqdir)/sciquill.make

```


## Configuring targets

Each sciquill media type comes with one or more targets, which are items to build. For example, for a `manuscript` type, you can build two targets: a `manuscript` or a `cover_letter`. There are also other targets, like `figs`, which creates all the figures.

### Default target

When you type `make` without any parameters, you'll build the default target. GitHub Actions will build the default target. The built-in media types have sensible default targets. 

You can configure this by changing the default target in your `Makefile`:

```console
.DEFAULT_GOAL := default
```

What if you want GitHub to build 2 different targets? You can also set the default target to build two targets by making a new target that depends on two other targets:

```console
.DEFAULT_GOAL := twotargets

twotargets: manuscript cover_letter
```

### Changing targets

To build a different target, for local computing just type `make target`. If using a github action, you can use the workflow_dispatch event trigger. Just click on "Actions" and select the Sciquill action; when you trigger the manual submission with "Run workflow", you can there specify a target manually.

