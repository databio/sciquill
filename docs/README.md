# Sciquill

## Motivation

Sciquill helps you use markdown and YAML to write your academic grant, paper, biosketch, or CV.
Sciquill is a framework that wraps existing tools like `pandoc`, `liquid`, `inkscape`, and `make`. It provides templates, styles, workflows, and scripts that make it simple to go from markdown text and structured YAML data to beautiful PDFs, all from inside GitHub or your local computer.
Sciquill brings us closer to the goal of authoring all types of scientific documents in markdown to completely [separate content from style](http://databio.org/posts/markdown_style.html).

## What is sciquill?

Sciquill is a collection of templates, makefiles, scripts, and GitHub actions. The basic workflow is:

1. Write your content (*e.g.* manuscript, CV, grant) in markdown and/or YAML.
2. Store your markdown files in a repository on GitHub.
3. Configure sciquill for your document type, template, *etc.*
4. Use a GitHub action to automatically build your document when the source files change.

You can also use sciquill as a framework to build whatever documents you like using custom LaTeX templates. Sciquill builds the following media types built-in:

- manuscript
- simple grant
- NIH R01
- NIH Biosketch
- CV

## Quick start

### Use GitHub Actions

The easiest way to get started with sciquill is using GitHub actions. We have several [demo repositories](github_actions.md) that are pre-configured to build different media types with GitHub actions, so you literally need only fork the repo and then edit the source markdown files to trigger a build of your own document. Then, you can just change the configuration options to switch the template or other settings as needed. This way, you can start building PDFs without downloading or installing anything.

If you want more control, or to iterate more quickly, you can also download sciquill and build documents locally. More details in [installation instructions](install.md).

You trigger a particular build using pre-defined makefile. Assuming [prerequisites are installed](install.md), you invoke sciquill locally like this:

```
git clone git@github.com:databio/sciquill.git
cd sciquill/examples/manuscript
make
```

This use of `make` is not to build sciquill; this is what you'd actually use to build your PDF output.


