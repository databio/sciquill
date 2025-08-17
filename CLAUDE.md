# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## General Monorepo Guidelines

This monorepo contains several independent pieces of software that work together.
Each subfolder in this repo is a separate project.
When working on a project, restrict yourself to that subfolder, unless you have an explicit task that should cross subfolder boundaries.

## Overview

Sciquill is an academic publishing system that helps author academic documents using markdown and YAML. 
It includes templates, styles, workflows, and scripts to transform markdown and YAML into beautiful PDFs and other outputs.

Key components:
- `./markmeld`: This subfolder holds the `markmeld` Python package, a markdown melder that merges YAML and markdown using jinja2 templates (installed as `mm` command)
- `makefiles`: Deprecated. Now `mm` will build the outputs. Previously, these makefiles served that purpose.
- **Pandoc**: Core document conversion engine
- **LaTeX templates**: Located in `/tex_templates/` for various document types
- **Utility scripts**: Located in `/bin/` for PDF manipulation and bibliography handling

## Architecture

The system follows a pipeline approach:
1. Content authored in markdown files (usually in `src/` directory)
2. Data and configuration in YAML files
3. Markmeld processes templates and merges content
4. Pandoc converts to PDF using LaTeX templates
5. Utility scripts handle post-processing (merging PDFs, extracting references, etc.)


## Common Commands

### Building Documents with Markmeld Commands

```bash
# Build default target from _markmeld.yaml
mm default

# Initialize new markmeld config
mm -i config.yaml

# Build specific target
mm target_name
```

### Using Python virtual environment

For any python testing, first activate the venv like this:

```bash
source .venv/bin/activate
```

### Testing Markmeld

```bash
cd markmeld
pytest
```

## Key Configuration

### Environment Variables
- `SQDIR`: Path to sciquill repository
- `BIBTEXDB`: Path to bibliography database
- `TEXINPUTS`: Extended with sciquill tex templates

### Markmeld Configuration
Projects using markmeld need `_markmeld.yaml` files defining:
- Templates to use
- Data sources (YAML and markdown files)
- Output targets and build commands

## Dependencies

### Python (Markmeld)
- python-frontmatter
- jinja2>=3.1
- logmuse
- pyyaml
- requests
- ubiquerg

### External Tools Used
- pandoc (document conversion)
- inkscape (SVG to PDF conversion)
- pdflatex (LaTeX processing)
- Various PDF utilities in `/bin/`

## Development Notes

- Utility scripts in `/bin/` are shell scripts for PDF/bibliography manipulation
- Markmeld is a separate Python package in `/markmeld/` directory
- LaTeX templates define document styling and are media-type specific
- Use `$(sqbin)/ver` to handle versioned source files
- Bibliography handling uses CSL styles from `/csl/` directory


## Documentation

- User-facing documentation is found in `/docs` using the `mkdocs` system.