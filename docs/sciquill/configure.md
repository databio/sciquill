# Configuring sciquill

In sciquill, documents (or collections of related documents) are organized as repositories.
Sciquill is configured in a `Makefile` placed in your repository's root.


## 1. Link your Makefile to sciquill

The first step is to include a sciquill Makefile as the first line in your Makefile. Here's a basic example:

```make
include ${SQDIR}/makefiles/manuscript.make # Sciquill link
```

Here, we're using environment variable `${SQDIR}` for convenience, but you can also just point to it directly. If you set up this environment variable it will work with GitHub Actions.

There are various media types available for you to use, each with its own Makefile. For instance, to get the `grant` targets, you'd do:

```make
include ${SQDIR}/makefiles/grant.make # Sciquill link
```

Now, you should be able to build all the targets provided by sciquill for that media type.

## 2. Configure your build

You can change default behavior by adding in any of these options to your makefile:

- `bib`: path to your bibtex file (use this to override the default, which uses `output/refs.bib` first, or if not found, then tries `$BIBTEXDB`).
- `csl`:  style file
- `lettertemplate`: template for letter
- `textemplate`: LaTeX template
- `manuscript_token`:  a string identifying which source file identifies your supplement source markdown file. Defaults to `manuscript`
- `supplement_token`: a string identifying which source file identifies your supplement source markdown file. Defaults to `supplement`.


Foe example, here, we will set the `textemplate` and `csl` variables:

```make
include ${SQDIR}/makefiles/grant.make # Sciquill link

textemplate=$(sqdir)/tex_templates/shefflab.tex
csl=$(sqdir)/csl/bioinformatics.csl
```

When setting these config options, you should use `$(sqdir)/` to refer to the sciquill repository. It will be provided for you automatically from your `include` instruction that links to the sciquill Makefile for your preferred media type.


## Configuring targets

Each sciquill media type comes with one or more targets, which are items to build. For example, for a `manuscript` type, you can use `make manuscript` or a `make cover_letter`, or `make response` or `make manuscript_supplement`. There are also other targets, like `figs`, which creates all the figures. To explore in more detail, you can just look at the Makefile in the sciquill repository that provides the targets.

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

