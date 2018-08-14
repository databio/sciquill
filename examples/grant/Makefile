SHELL := /bin/bash
today=`date +%y%m%d`

# Choose citation style
# no bibliography for this LOI
csl_nobib = ${CODEBASE}mediabuilder/csl/bioinformatics-nobib.csl
#csl = ${CODEBASE}styles/bioinformatics.csl
#csl = ${CODEBASE}mediabuilder/csl/compact.csl
csl = ${CODEBASE}mediabuilder/csl/nature.csl

wrapfig = ${CODEBASE}mediabuilder/pandoc-wrapfig/pandoc-wrapfig.py
budgetdir=../budgets/`basename "${PWD}"`
textemplate = ${CODEBASE}mediabuilder/tex_templates/nih.tex
mbin=${CODEBASE}mediabuilder/bin

# These are the typical flags we want to pass to pandoc
define PANDOC_FLAGS
--filter $(wrapfig) \
--template $(textemplate) \
--bibliography $(bib) \
--csl $(csl)
endef

# Use a general bibtex database if it exists; otherwise use a local one
ifneq ("$(wildcard ${CODEBASE}papers/sheffield.bib)","")
bib = ${CODEBASE}papers/sheffield.bib
else
bib = refs.bib
endif

all: figs abstract aims plan refs merge

abstract:
	$(mbin)/nobib `$(mbin)/ver src/abstract` | \
	pandoc -o output/abstract.pdf $(PANDOC_FLAGS)

# Auto-build svg figures that have changed since last render
figs:
	$(mbin)/buildfigpdfs fig/*.svg

# Produces just the specific aims.
aims: figs
	$(mbin)/nobib `$(mbin)/ver src/specific_aims` | \
	pandoc -o output/specific_aims.pdf $(PANDOC_FLAGS)

# Produce just the introduction + aims
intro_aims: figs
	$(mbin)/addrefsec `$(mbin)/ver src/introduction src/specific_aims` | \
	pandoc -o output/intro_aims.pdf $(PANDOC_FLAGS)

# Produces the specific aims with significance, innovation, and refs
aims_sig_inno: figs
	$(mbin)/addrefsec `$(mbin)/ver src/specific_aims src/significance_innovation` | \
	pandoc -o output/specific_aims_refs.pdf $(PANDOC_FLAGS)

# Render the entire research plan (including aims, significance, innovation, and
# approach). These must be rendered together so citations are numbered across
# the whole document (dividing them throws the citation numbering off)
plan: figs bib
	$(mbin)/nobib `$(mbin)/ver src/specific_aims` \
	`$(mbin)/ver src/significance_innovation` \
	`$(mbin)/ver src/aim1` `$(mbin)/ver src/aim2` `$(mbin)/ver src/aim3` | \
	pandoc -o output/research_plan.pdf $(PANDOC_FLAGS)

# Split out the specific aims off the rest of the research plan document. Some
# grants require them to be divided; we must produce them combined and then
# split them post-hoc so that citations are numbered correctly
split:
	$(mbin)/poppdf output/research_plan.pdf output/research_plan_noaims.pdf

# Produces the references from all
# WARNING: This will also pull commented references.
refs:
	$(mbin)/getrefs `$(mbin)/ver src/specific_aims` \
	`$(mbin)/ver src/significance_innovation` \
	`$(mbin)/ver src/aim1` `$(mbin)/ver src/aim2` `$(mbin)/ver src/aim3` | \
	pandoc -o output/references.pdf $(PANDOC_FLAGS)

# Produce references from all, but strip commented references
# Requires pandoc 2 with --strip-comments implemented
refs_nocomment:
	pandocker --strip-comments -t markdown `$(mbin)/ver src/specific_aims` \
	`$(mbin)/ver src/significance_innovation` \
	`$(mbin)/ver src/aim1` `$(mbin)/ver src/aim2` `$(mbin)/ver src/aim3` | \
	$(mbin)/getrefs | \
	pandoc -o output/references.pdf $(PANDOC_FLAGS)

# Merge in the references PDF to the end of the combined research_plan
merge:
	$(mbin)/mergepdf output/research_plan_refs.pdf \
	output/research_plan.pdf \
	output/references.pdf


# A few bonus targets that could be useful for reference for particular grants

# This recipe is atypical. It creates just the approach without specific aims.
# WARNING: useful only when the citation lists are divided
approach_only: figs
	$(mbin)/nobib `$(mbin)/ver src/significance_innovation` \
	`$(mbin)/ver src/aim1` `$(mbin)/ver src/aim2` `$(mbin)/ver src/aim3` | \
	pandoc -o output/aims_approach.pdf $(PANDOC_FLAGS)

# Supporting docs
supporting:
	pandoc src/authentication_resources.md -o output/authentication_resources.pdf $(PANDOC_FLAGS)
	pandoc src/facilities.md -o output/facilities.pdf $(PANDOC_FLAGS)
	pandoc src/resource_sharing.md -o output/resource_sharing.pdf $(PANDOC_FLAGS)
	pandoc src/human_subjects.md -o output/human_subjects.pdf $(PANDOC_FLAGS)
	pandoc src/project_narrative.md -o output/project_narrative.pdf $(PANDOC_FLAGS)

# Justification docs
budget:
	pandoc $(budgetdir)/personnel_justification.md \
	-o $(budgetdir)/personnel_justification.pdf $(PANDOC_FLAGS)
	pandoc $(budgetdir)/consortium_justification.md \
	-o $(budgetdir)/consortium_justification.pdf $(PANDOC_FLAGS)

# Produce a PDF from a docx using libreoffice
pdf:
	soffice --convert-to pdf output/toc.docx \
	--outdir output

# Contact all refs into refs.bib
bib:
	cat references/*.bib > output/refs.bib
