# <img src="img/markmeld_logo_long.svg" alt="markmeld logo" height="70">

## Introduction

Markmeld is a *markdown* *melder*. It merges `yaml` and `markdown` content using `jinja2` templates. You configure markmeld with your content in computer-readable `.md` and `.yaml` files, and markmeld helps produce polished, publication-ready versions of your content. Markmeld is useful for many types of output document, including resumes, biosketches, manuscripts, proposals, books, and more. 

## How it works

1. Store your content in computer-readable formats: `.md` for unstructured text, `.yaml` format for structured content like lists or objects. 
2. Write or find a jinja template that produces the output document you are trying to create. We have a variety of common examples in a [public repository](https://databio.org/mm_templates/).
3. Configure markmeld with a `yaml` configuration file to point to 1) your content files; and 2) your jinja template.

Markmeld is useful independently, but is particularly powerful when combined with [pandoc](https://pandoc.org) -- you pipe the markmeld output in markdown format to pandoc, making it easy to format the output in a variety of downstream output types, such as HTML or PDF via LaTeX. This lets you design design powerful multi-file documents, restructured into different output formats.

![demo](img/markmeld_abstract.svg)

## Why is this better than just stringing inputs together with pandoc?

For simple use cases, you can use pandoc without markmeld. You just provide a list of markdown files, which pandoc concatenates. This works for very basic documents that do nothing more than string together a list of markdown files. Markmeld adds power to this approach by providing several benefits:

1. **Structured content**. Most importantly, markmeld integrates structured yaml data. While pandoc alone can easily concatenate prose content (in markdown format), markmeld allow you to also integrate structured content (in yaml format) into one output. This is useful for something like a CV, where I have both prose components and lists, which I'd rather draw from a structured YAML file.

2. **Templated output**. Markmeld's jinja template gives you more control over the structure of the output. Vanilla pandoc can only concatenate `md` inputs in a sequence. Jinja templates let you re-arrange, subset, merge, and even compute on the input, allowing you to create arbitrarily complex output. For simple documents that don't need structured content, you can get by with concatenating `.md` files with vanilla pandoc. But even in these situations, you gain something from going the route of the jinja template with markmeld: it formalizes the linking of documents into a separate file, instead of relying the on order and content of CLI arguments to pandoc. So you can more easily write a little recipe saying, "provide these pieces of content under these names, and then use this jinja template to produce the output". Markmeld makes that recipe reproducible.

3. **Flexible downstream uses**. Markmeld outputs are not restricted to markdown, but could directly produce whatever you design with your jinja template. For example, you could use markmeld to restructure data into a JSON output to pipe into some other downstream system.

4. **Pre-build hooks**. Markmeld can also incorporate non-file-producing commands. You can also build "meta-targets", which are targets made up of other targets, so a single command can build multiple outputs. Markmeld replaces the need for a script or Makefile that runs prepwork, like updating a bibtex database.

5. **Mail merge**. Markmeld provides loop functions that allow you to generate multiple similar documents that differ based on structured input content, like a traditional mail merge.

6. **Target factories**. Markmeld provides a plugin system that allows you to auto-create targets using your own Python code.

Plus, there's more! Read on to see if Markmeld can help solve some of your content management issues.
