
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
current_dir := $(notdir $(patsubst %/,%,$(dir $(mkfile_path))))
sqdir := $(abspath $(dir $(abspath $(dir $(mkfile_path)))))

# Variable for directory where bin utilities are stored
sqbin := $(sqdir)/bin
sqver = 0.1.0

SHELL := /bin/bash
today=`date +%y%m%d`

$(info Sciquill v$(sqver). Using $(mkfile_path); sqdir: '$(sqdir)'')
# $(info Linked to sciquill type: $(sqtype))


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
--citeproc \
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

