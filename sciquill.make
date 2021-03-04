ifndef sqdir
  $(error You must define the sqdir variable before including sciquill.make)
endif

sqver = 0.0.1

SHELL := /bin/bash
today=`date +%y%m%d`

# Variable for directory where bin utilities are stored
sqbin=$(sqdir)/bin

# Default CSL styles for citations, with or without bibliographies
csl_nobib = $(sqdir)/csl/bioinformatics-nobib.csl
#csl = $(sqdir)/csl/biomed-central.csl
#csl = $(sqdir)/csl/bioinformatics.csl
#csl = $(sqdir)/csl/compact.csl
csl = $(sqdir)/csl/nature.csl

# Sciquill pandoc filters
figczar = $(sqdir)/pandoc_filters/figczar/figczar.lua

# These are the typical flags we want to pass to pandoc
define PANDOC_FLAGS
--template $(textemplate) \
--bibliography $(bib) \
--lua-filter $(figczar) \
--csl $(csl)
endef

# Use a local bibtex database if it exists; otherwise try a general one
bibdir=${bibdir}
ifneq ("$(wildcard output/refs.bib)","")
bib = output/refs.bib
else
bib = ${BIBTEXDB}
endif


.DEFAULT_GOAL := default

# sq settings
sq: 	
	@echo "Sciquill version: " $(sqver)
	@echo "TEXINPUTS: " ${TEXINPUTS}
	@echo "SQDIR: " ${SQDIR}
	@echo "sqtype: " $(sqtype)
	@echo "bib: " $(bib)
	@echo "csl: " $(csl)
	@echo "figczar: " $(figczar)
	@echo "lettertemplate: " $(lettertemplate)
	@echo "textemplate: " $(textemplate)
	@echo "supplement_token: " $(supplement_token)
	@echo "manuscript_token: " $(manuscript_token)

# These target confirm that a variable is set, and points to a file that exists.

define check-sq-variable
	@test -n "$(2)" || { echo "$(1) variable not set!"; exit 1; }
	@test -s $(2) || { echo "$(1) file does not exist: $(2)"; exit 1; }
endef

sq-check-bib:
	$(call check-sq-variable,bib,$(bib))

sq-check-csl:
	$(call check-sq-variable,textemplate,$(csl))

sq-check-figczar:
	$(call check-sq-variable,textemplate,$(figczar))

sq-check-lettertemplate:
	$(call check-sq-variable,lettertemplate,$(lettertemplate))

sq-check-textemplate:
	$(call check-sq-variable,textemplate,$(textemplate))

sq-check-all: sq-check-bib sq-check-csl sq-check-figczar sq-check-lettertemplate sq-check-textemplate
sq-check-core: sq-check-bib sq-check-csl sq-check-figczar sq-check-textemplate

# Auto-build svg figures that have changed since last render
figs:
	@echo "Converting changed SVG files to PDF..."
	$(sqbin)/build-pdfs fig

figs_png:
	@echo "Converting changed SVG files to PNG..."
	$(sqbin)/buildfigs fig/*.svg


# Media type: biosketch ------------------------------------------------------------

ifeq ($(sqtype),biosketch)

textemplate = $(sqdir)/tex_templates/nih_bs.tex

default: biosketch

biosketch:
	pandoc \
	src/nih_biosketch.md \
	--template $(textemplate) \
	-o output/nih_biosketch.pdf

endif

# Media type: outline ------------------------------------------------------------

ifeq ($(sqtype),outline)

textemplate = $(sqdir)/tex_templates/outline.tex

endif


# Media type: grant_simple ------------------------------------------------------------

ifeq ($(sqtype),grant_simple)

textemplate = $(sqdir)/tex_templates/nih.tex
docxtemplate = $(sqdir)/docx_templates/NIH_grant_style.docx

default: research_plan refs

research_plan: figs
	$(sqbin)/nobib `$(sqbin)/ver src/research_plan` | \
	pandoc -o output/research_plan.pdf $(PANDOC_FLAGS) 

refs:
	pandoc --strip-comments -t markdown `$(sqbin)/ver src/research_plan` | \
	$(sqbin)/getrefs | \
	pandoc -o output/references.pdf $(PANDOC_FLAGS)

research_plan_refs: figs
	$(sqbin)/addrefsec `$(sqbin)/ver src/research_plan` | \
	pandoc -o output/research_plan_refs.pdf $(PANDOC_FLAGS) 

endif

ifeq ($(sqtype),grant_nsf)

textemplate = $(sqdir)/tex_templates/nsf.tex

endif

# Media type: grant ------------------------------------------------------------

ifeq ($(sqtype),grant)

textemplate = $(sqdir)/tex_templates/nih.tex
docxtemplate = $(sqdir)/docx_templates/NIH_grant_style.docx

# Recipe to run to make sure everything is up-to-date before submission
all: figs abstract aims research_plan split_research_plan refs merge

abstract:
	$(sqbin)/nobib `$(sqbin)/ver src/abstract` | \
	pandoc -o output/abstract.pdf $(PANDOC_FLAGS)

# Produce just the introduction
intro: 
	$(sqbin)/nobib `$(sqbin)/ver src/introduction` | \
	pandoc -o output/introduction.pdf $(PANDOC_FLAGS)

# Produce just the introduction + aims
intro_aims: figs
	$(sqbin)/addrefsec `$(sqbin)/ver src/introduction src/specific_aims` | \
	pandoc -o output/intro_aims.pdf $(PANDOC_FLAGS)

# Render just aim 1
aim1: figs
	$(sqbin)/addrefsec `$(sqbin)/ver src/aim1` | \
	pandoc -o output/aim1.pdf $(PANDOC_FLAGS)

# Produces just the specific aims.
aims: figs
	$(sqbin)/nobib `$(sqbin)/ver src/specific_aims` | \
	pandoc -o output/specific_aims.pdf $(PANDOC_FLAGS)

aims_docx: figs_png
	$(sqbin)/nobib `$(sqbin)/ver src/specific_aims` | sed 's/\.pdf/\.png/' | \
	pandoc -o output/specific_aims.docx $(PANDOC_FLAGS) \
	--reference-doc $(docxtemplate) 

# Produces the specific aims with significance, innovation, and refs
aims_sig_inno: figs
	$(sqbin)/addrefsec `$(sqbin)/ver src/specific_aims src/significance_innovation` | \
	pandoc -o output/aims_significance_innovation.pdf $(PANDOC_FLAGS)

# Render the entire research plan (including aims, significance, innovation, and
# approach). These must be rendered together so citations are numbered across
# the whole document (dividing them throws the citation numbering off)
research_plan: figs
	$(sqbin)/nobib `$(sqbin)/ver src/specific_aims` \
	`$(sqbin)/ver src/significance_innovation` \
	`$(sqbin)/ver src/aim1` `$(sqbin)/ver src/aim2` `$(sqbin)/ver src/aim3` | \
	pandoc -o output/aims_research_plan.pdf $(PANDOC_FLAGS) 

research_plan_nofigs:
	$(sqbin)/nobib `$(sqbin)/ver src/specific_aims` \
	`$(sqbin)/ver src/significance_innovation` \
	`$(sqbin)/ver src/aim1` `$(sqbin)/ver src/aim2` `$(sqbin)/ver src/aim3` | \
	pandoc -o output/aims_research_plan.pdf $(PANDOC_FLAGS) 



# Split out the specific aims off the rest of the research plan document. Some
# grants require them to be divided; we must produce them combined and then
# split them post-hoc so that citations are numbered correctly
split_research_plan:
	$(sqbin)/poppdf output/aims_research_plan.pdf output/research_plan.pdf
	

# Render complete plan, including intro
research_plan_intro: figs
	$(sqbin)/addrefsec `$(sqbin)/ver src/introduction src/specific_aims` \
	`$(sqbin)/ver src/significance_innovation` \
	`$(sqbin)/ver src/aim1` `$(sqbin)/ver src/aim2` `$(sqbin)/ver src/aim3` | \
	pandoc -o output/intro_research_plan.pdf $(PANDOC_FLAGS)

approach_refs: figs approach refs
	$(sqbin)/mergepdf output/aims_approach_refs.pdf \
	output/aims_approach.pdf \
	output/references.pdf

# Requires pandoc 2 with --strip-comments implemented
refs:
	pandoc --strip-comments -t markdown `$(sqbin)/ver src/specific_aims` \
	`$(sqbin)/ver src/significance_innovation` \
	`$(sqbin)/ver src/aim1` `$(sqbin)/ver src/aim2` `$(sqbin)/ver src/aim3` | \
	$(sqbin)/getrefs | \
	pandoc -o output/references.pdf $(PANDOC_FLAGS)


# Merge in the references PDF to the end of the cosqbined research_plan
research_plan_refs: figs research_plan refs
	$(sqbin)/mergepdf output/research_plan_refs.pdf \
	output/aims_research_plan.pdf \
	output/references.pdf

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


ifeq ($(sqtype),sqmanuscript)

#
ifndef cover_token
  cover_token = cover_letter
endif

ifndef manuscript_token
  manuscript_token = manuscript
endif

ifndef supplement_token
  supplement_token = supplement
endif

ifndef response_token
  response_token = response
endif

.DEFAULT_GOAL := manuscript

cover_letter: sq-check-lettertemplate
	@echo "Letter template '$(lettertemplate)'"
	pandoc -o output/cover_letter.pdf $(PANDOC_FLAGS) \
	--template $(lettertemplate) \
	src/cover_letter.md

cover_manu: cover_letter
	$(sqbin)/mergepdf output/$(cover_token)_$(manuscript_token)_$(supplement_token).pdf \
	output/$(cover_token).pdf \
	output/$(manuscript_token).pdf

manuscript: sq-check-core figs manuscript_nofig

manuscript_nofig:
	cat `$(sqbin)/ver src/*$(manuscript_token)` | \
	pandoc $(PANDOC_FLAGS) \
	-o output/$(manuscript_token).pdf

response:
	$(sqbin)/nobib `$(sqbin)/ver src/*$(response_token)` | \
	pandoc -o output/$(response_token).pdf $(PANDOC_FLAGS) \
	--template $(sqdir)/tex_templates/manuscript.tex

bibsub:
	mkdir -p bibgen
	$(sqbin)/nobib `$(sqbin)/ver src/*$(manuscript_token)` | \
	pandoc -o bibgen/$(manuscript_token).tex --csl $(csl) --template $(textemplate)  --biblatex
	pdflatex --output-directory=bibgen bibgen/$(manuscript_token).tex
	jabref -n -a bibgen/$(manuscript_token).aux,bibgen/`hostname`.bib ${BIBTEXDB}
	cat bibgen/*.bib > output/refs.bib

manuscript_supplement:
	cat `$(sqbin)/ver src/*$(manuscript_token)` \
	`$(sqbin)/ver src/*$(supplement_token)`| \
	pandoc $(PANDOC_FLAGS) \
	-o output/$(manuscript_token)_$(supplement_token).pdf

manuscript_supplement_tex:
	cat `$(sqbin)/ver src/*$(manuscript_token)` \
	`$(sqbin)/ver src/*$(supplement_token)`| \
	pandoc $(PANDOC_FLAGS) \
	-o output/$(manuscript_token)_$(supplement_token).tex

supplement:
	cat `$(sqbin)/ver src/*$(supplement_token)`| \
	pandoc $(PANDOC_FLAGS) \
	-o output/$(supplement_token).pdf

response:
	$(sqbin)/nobib `$(sqbin)/ver src/response_to_reviewers` | \
	pandoc -o output/response_to_reviewers.pdf $(PANDOC_FLAGS) \
	--template $(sqdir)/tex_templates/manuscript.tex

response2:
	$(sqbin)/nobib `$(sqbin)/ver src/response_to_reviewers2` | \
	pandoc -o output/response_to_reviewers2.pdf $(PANDOC_FLAGS) \
	--template $(sqdir)/tex_templates/manuscript.tex


endif

# Media type: manuscript -------------------------------------------------------

ifeq ($(sqtype),manuscript)

default: manuscript_supplement

# Set the default manuscript_token, which is the string used to know which
# file to build
ifndef manuscript_token
  manuscript_token = manuscript
endif

ifndef supplement_token
  supplement_token = supplement
endif

textemplate = $(sqdir)/tex_templates/manuscript.tex

manuscript: figs manuscript_nofig

manuscript_nofig:
	$(sqbin)/passthru `$(sqbin)/ver src/*$(manuscript_token)` | \
	pandoc -t json | $(wrapfig) | pandoc -f json \
	-o output/$(manuscript_token).pdf $(PANDOC_FLAGS)

manuscript_supplement: figs
	$(sqbin)/passthru `$(sqbin)/ver src/*$(manuscript_token)` \
	`$(sqbin)/ver src/*$(supplement_token)`| \
	pandoc \
	-o output/$(manuscript_token)_$(supplement_token).pdf $(PANDOC_FLAGS)

deprecated_paste: figs manuscript supplement
	$(sqbin)/mergepdf output/$(manuscript_token)_$(supplement_token).pdf \
	output/$(manuscript_token).pdf \
	output/$(supplement_token).pdf


# Produce a docx version of the paper, which can be necessary for feedback
manuscript_docx:
	$(sqbin)/buildfigs fig/*.svg
	cat `$(sqbin)/ver src/*$(manuscript_token)` | sed 's/\.pdf/\.png/' | pandoc \
	-o output/manuscript.docx $(PANDOC_FLAGS)

manuscript_tex:
	$(sqbin)/buildfigs fig/*.svg
	cat `$(sqbin)/ver src/*$(manuscript_token)` | pandoc \
	-o output/manuscript.tex $(PANDOC_FLAGS) --biblatex

manuscript_aux:	
	~/code/docker/bin/pdflatex --output-directory=output output/manuscript.tex

manuscript_txt:	
	cat `$(sqbin)/ver src/*$(manuscript_token)` | sed 's/\.pdf/\.png/' | pandoc \
	-o output/manuscript.txt --to=plain


# Produce a subset bibliography for the manuscript

bibsub:
	mkdir -p bibgen
	$(sqbin)/nobib `$(sqbin)/ver src/*manuscript` | \
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

supplement: figs
	$(sqbin)/addrefsec `$(sqbin)/ver src/*suppl` | \
	pandoc \
	-o output/supplement.pdf $(PANDOC_FLAGS)

response:
	$(sqbin)/nobib `$(sqbin)/ver src/response_to_reviewers` | \
	pandoc -o output/response_to_reviewers.pdf $(PANDOC_FLAGS) \
	--template $(sqdir)/tex_templates/manuscript.tex

response2:
	$(sqbin)/nobib `$(sqbin)/ver src/response_to_reviewers2` | \
	pandoc -o output/response_to_reviewers2.pdf $(PANDOC_FLAGS) \
	--template $(sqdir)/tex_templates/manuscript.tex


endif


