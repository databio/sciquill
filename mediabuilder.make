ifndef mbdir
  $(error You must define the mbdir variable before including mediabuilder.make)
endif

SHELL := /bin/bash
today=`date +%y%m%d`

# Variable for directory where bin utilities are stored
mbin=$(mbdir)/bin

# Default CSL styles for citations, with or without bibliographies
csl_nobib = $(mbdir)/csl/bioinformatics-nobib.csl
#csl = $(mbdir)/csl/biomed-central.csl
#csl = $(mbdir)/csl/bioinformatics.csl
#csl = $(mbdir)/csl/compact.csl
csl = $(mbdir)/csl/nature.csl

# Directory with pandoc-wrapfig
wrapfig = $(mbdir)/pandoc-wrapfig/pandoc-wrapfig.py

# These are the typical flags we want to pass to pandoc
define PANDOC_FLAGS
--filter $(wrapfig) \
--template $(textemplate) \
--bibliography $(bib) \
--csl $(csl)
endef

# Use a local bibtex database if it exists; otherwise try a general one
ifneq ("$(wildcard output/refs.bib)","")
bib = output/refs.bib
else
bib = ${BIBTEXDB}
endif


mbtest:
	@echo "mediabuilder makefile successfully imported."

# Auto-build svg figures that have changed since last render
figs:
	@echo "Converting changed svg files to PDF..."
	$(mbin)/buildfigpdfs fig/*.svg

figs_png:
	@echo "Converting changed svg files to PNG..."
	$(mbin)/buildfigs fig/*.svg


# Media type: biosketch ------------------------------------------------------------

ifeq ($(mbtype),biosketch)

textemplate = $(mbdir)/tex_templates/nih_bs.tex

endif

# Media type: outline ------------------------------------------------------------

ifeq ($(mbtype),outline)

textemplate = $(mbdir)/tex_templates/outline.tex

endif


# Media type: grant ------------------------------------------------------------

ifeq ($(mbtype),grant_simple)

textemplate = $(mbdir)/tex_templates/nih.tex
docxtemplate = $(mbdir)/docx_templates/NIH_grant_style.docx

endif

ifeq ($(mbtype),grant_nsf)

textemplate = $(mbdir)/tex_templates/nsf.tex

endif


ifeq ($(mbtype),grant)

textemplate = $(mbdir)/tex_templates/nih.tex
docxtemplate = $(mbdir)/docx_templates/NIH_grant_style.docx

# Recipe to run to make sure everything is up-to-date before submission
all: figs abstract aims research_plan split_research_plan refs merge

abstract:
	$(mbin)/nobib `$(mbin)/ver src/abstract` | \
	pandoc -o output/abstract.pdf $(PANDOC_FLAGS)

# Produce just the introduction
intro: 
	$(mbin)/nobib `$(mbin)/ver src/introduction` | \
	pandoc -o output/introduction.pdf $(PANDOC_FLAGS)

# Produce just the introduction + aims
intro_aims: figs
	$(mbin)/addrefsec `$(mbin)/ver src/introduction src/specific_aims` | \
	pandoc -o output/intro_aims.pdf $(PANDOC_FLAGS)

# Render just aim 1
aim1: figs
	$(mbin)/addrefsec `$(mbin)/ver src/aim1` | \
	pandoc -o output/aim1.pdf $(PANDOC_FLAGS)

# Produces just the specific aims.
aims: figs
	$(mbin)/nobib `$(mbin)/ver src/specific_aims` | \
	pandoc -o output/specific_aims.pdf $(PANDOC_FLAGS)

aims_docx: figs_png
	$(mbin)/nobib `$(mbin)/ver src/specific_aims` | sed 's/\.pdf/\.png/' | \
	pandoc -o output/specific_aims.docx $(PANDOC_FLAGS) \
	--reference-doc $(docxtemplate) 

# Produces the specific aims with significance, innovation, and refs
aims_sig_inno: figs
	$(mbin)/addrefsec `$(mbin)/ver src/specific_aims src/significance_innovation` | \
	pandoc -o output/aims_significance_innovation.pdf $(PANDOC_FLAGS)

# Render the entire research plan (including aims, significance, innovation, and
# approach). These must be rendered together so citations are numbered across
# the whole document (dividing them throws the citation numbering off)
research_plan: figs
	$(mbin)/nobib `$(mbin)/ver src/specific_aims` \
	`$(mbin)/ver src/significance_innovation` \
	`$(mbin)/ver src/aim1` `$(mbin)/ver src/aim2` `$(mbin)/ver src/aim3` | \
	pandoc -o output/aims_research_plan.pdf $(PANDOC_FLAGS) 

# Split out the specific aims off the rest of the research plan document. Some
# grants require them to be divided; we must produce them combined and then
# split them post-hoc so that citations are numbered correctly
split_research_plan:
	$(mbin)/poppdf output/aims_research_plan.pdf output/research_plan.pdf
	

# Render complete plan, including intro
research_plan_intro: figs
	$(mbin)/addrefsec `$(mbin)/ver src/introduction src/specific_aims` \
	`$(mbin)/ver src/significance_innovation` \
	`$(mbin)/ver src/aim1` `$(mbin)/ver src/aim2` `$(mbin)/ver src/aim3` | \
	pandoc -o output/intro_research_plan.pdf $(PANDOC_FLAGS)

approach_refs: figs approach refs
	$(mbin)/mergepdf output/aims_approach_refs.pdf \
	output/aims_approach.pdf \
	output/references.pdf

# Requires pandoc 2 with --strip-comments implemented
refs:
	pandoc --strip-comments -t markdown `$(mbin)/ver src/specific_aims` \
	`$(mbin)/ver src/significance_innovation` \
	`$(mbin)/ver src/aim1` `$(mbin)/ver src/aim2` `$(mbin)/ver src/aim3` | \
	$(mbin)/getrefs | \
	pandoc -o output/references.pdf $(PANDOC_FLAGS)


# Merge in the references PDF to the end of the combined research_plan
research_plan_refs: figs research_plan refs
	$(mbin)/mergepdf output/research_plan_refs.pdf \
	output/aims_research_plan.pdf \
	output/references.pdf

# Produce a subset bibliography for the project
bibsub:
	mkdir -p bibgen
	$(mbin)/nobib `$(mbin)/ver src/specific_aims` \
	`$(mbin)/ver src/significance_innovation` \
	`$(mbin)/ver src/aim1` `$(mbin)/ver src/aim2` `$(mbin)/ver src/aim3` | \
	pandoc -o bibgen/research_plan.tex $(PANDOC_FLAGS) --biblatex
	pdflatex --output-directory=bibgen bibgen/research_plan.tex
	jabref -n -a bibgen/research_plan.aux,bibgen/`hostname`.bib ${BIBTEXDB}
	cat bibgen/*.bib > output/refs.bib

cover_letter:
	@echo "Letter template '$(lettertemplate)'"
	pandoc -o output/cover_letter.pdf $(PANDOC_FLAGS) \
	--template $(lettertemplate) \
	src/cover_letter.md

# Supporting docs
supporting: authentication_of_resources facilities resource_sharing human_subjects project_narrative cover_letter

authentication_of_resources:
	pandoc src/authentication_of_resources.md -o output/authentication_of_resources.pdf $(PANDOC_FLAGS)

facilities:
	pandoc src/facilities.md -o output/facilities.pdf $(PANDOC_FLAGS)

resource_sharing:
	pandoc src/resource_sharing.md -o output/resource_sharing.pdf $(PANDOC_FLAGS)

human_subjects:
	pandoc src/human_subjects.md -o output/human_subjects.pdf $(PANDOC_FLAGS)

project_narrative:
	pandoc src/project_narrative.md -o output/project_narrative.pdf $(PANDOC_FLAGS)

personnel_justification:
	pandoc src/personnel_justification.md -o output/personnel_justification.pdf $(PANDOC_FLAGS)



endif



# Media type: manuscript -------------------------------------------------------

ifeq ($(mbtype),manuscript)

# Set the default filetoken, which is the string used to know which
# file to build
ifndef filetoken
  filetoken = manuscript
endif


textemplate = $(mbdir)/tex_templates/manuscript.tex

manuscript: figs
	$(mbin)/addrefsecsmall `$(mbin)/ver src/*$(filetoken)` | \
	pandoc \
	-o output/$(filetoken).pdf $(PANDOC_FLAGS)

# Produce a docx version of the paper, which can be necessary for feedback
manuscript_docx:
	$(mbin)/buildfigs fig/*.svg
	cat `$(mbin)/ver src/*manuscript` | sed 's/\.pdf/\.png/' | pandoc \
	-o output/manuscript.docx $(PANDOC_FLAGS)

manuscript_tex:
	$(mbin)/buildfigs fig/*.svg
	cat `$(mbin)/ver src/*manuscript` | pandoc \
	-o output/manuscript.tex $(PANDOC_FLAGS) --biblatex

manuscript_aux:	
	~/code/docker/bin/pdflatex --output-directory=output output/manuscript.tex

manuscript_txt:	
	cat `$(mbin)/ver src/*manuscript` | sed 's/\.pdf/\.png/' | pandoc \
	-o output/manuscript.txt --to=plain


# Produce a subset bibliography for the manuscript

bibsub:
	mkdir -p bibgen
	$(mbin)/nobib `$(mbin)/ver src/*manuscript` | \
	pandoc -o bibgen/manuscript.tex $(PANDOC_FLAGS) --biblatex
	pdflatex --output-directory=bibgen bibgen/manuscript.tex
	jabref -n -a bibgen/manuscript.aux,output/refs_`hostname`.bib ${BIBTEXDB}
	cat output/refs_*.bib > output/refs.bib


cover_letter:
	@echo "Letter template '$(lettertemplate)'"
	pandoc -o output/cover_letter.pdf $(PANDOC_FLAGS) \
	--template $(lettertemplate) \
	src/cover_letter.md


cl:
	pandoc --preserve-tabs \
	--reference-doc $(docxtemplate) \
	-o output/cover_letter.docx \
	src/cover_letter.md
	libre --convert-to pdf output/cover_letter.docx \
	--outdir output
	rm output/cover_letter.docx

cl_text:	
	pandoc -o output/cover_letter.txt \
	-t plain \
	--wrap=none \
	letter.md

clt:
	# Don't use.
	# Needs the tex letterhead template set.
	pandocker -o output/letter.pdf  $(PANDOC_FLAGS) \
	letter.md

supplemental: figs
	$(mbin)/addrefsec `$(mbin)/ver src/*suppl` | \
	pandoc \
	-o output/supplement.pdf $(PANDOC_FLAGS)

response:
	$(mbin)/nobib `$(mbin)/ver src/response_to_reviewers` | \
	pandoc -o output/response_to_reviewers.pdf $(PANDOC_FLAGS) \
	--template $(mbdir)/tex_templates/manuscript.tex

	
endif


