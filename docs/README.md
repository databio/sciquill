---
hide:
  - navigation
  - toc
  - navigation.footer
---
<p align="center"><img align="center" src="/img/sciquill_light.svg" width="400">
</p>

# Sciquill

<span style="color:red">NOTE! Sciquill is currently fully functional and I've been using it for years to build all kinds of documents, from grants to manuscripts to NIH biosketches and more. However, it's under constant development and I haven't had time to document everything, as this is a side project. So, this documentation is provided as a work in progress. If you are interested in using or contributing to this system, please contact me and I'm happy to update things as needed.</span>

## Motivation

Sciquill is an academic publishing system. It helps to author academic documents using `markdown` and `YAML`. Document types include grants, papers, biosketches, CVs, dissertations, letters... anything you might want to write in `markdown`, really.
Sciquill is more of a publishing philosophy than a piece of software. It contains some scripts to glue together various stages of the authoring pipeline, but primarily it relies on existing tools, notably, [pandoc](http://pandoc.org), [inkscape](http://inkscape.org), and [markmeld](https://github.com/databio/markmeld). It provides templates, styles, workflows, and scripts that make it simple to go from markdown text and structured YAML data to beautiful PDF or other outputs, all from inside GitHub or your local computer.
Sciquill brings us closer to the goal of authoring all types of scientific documents in markdown to completely [separate content from style](http://databio.org/posts/markdown_style.html).

## The sciquill workflow

You specify 3 pieces of information: content, structure, and style. You use these to generate your desired output. So the sciquill workflow can be summarized as: `content + structure + style -> output`.


### 1. Content 


Write your content (*e.g.* manuscript, CV, grant) in `markdown` and/or `YAML` format. For editing and collaborating on your source content, you have 3 options: 1) local text editor of your choice; 2) collaborative markdown editor (*e.g.* hedgedoc or hackmd); or 3. a GitHub repository.

### 2. Structure

The *structure* of your output is how your content comes together and is formatted. All of your input `YAML` content plus your `markdown` content is integrated using a `jinja` template. Sciquill collates your inputs and renders your jinja template using [markmeld](http://github.com/databio/markmeld). The output is whatever you specify with your jinja template, but frequently, it will produce `markdown` output that integrates your inputs.

### 3. Style

The styles are the structure and "look and feel" of your output. Are you building a web page? A PDF document? For this, we rely on [pandoc](http://pandoc.org). You specify the style using a pandoc template, and we simply pipe the output of `markmeld` into `pandoc` to generate the final output.

## Connecting content, structure, and style

Configure markmeld by specifying the content, structure, and style in a `YAML` configuration file, `_markmeld.yaml`.

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


