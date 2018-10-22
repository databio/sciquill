# User configuration -----------------------------------------------------------
# Set this variable to point to your mediabuilder repository
mbdir = ${CODEBASE}mediabuilder

# choose a mediabuilder type: 'manuscript', 'cv', or 'grant'
mbtype = grant_simple

# Include the mediabuilder.make file to get access to default recipes and
# default variables (which can be overridden below)
include $(mbdir)/mediabuilder.make


# User overrides ---------------------------------------------------------------
#csl = ${CODEBASE}styles/bioinformatics.csl
#csl = ${CODEBASE}mediabuilder/csl/compact.csl
#csl = ${CODEBASE}mediabuilder/csl/nature.csl
#textemplate = $(mbdir)/tex_templates/manuscript.tex
docxtemplate = ~/Dropbox/uva_docs/letterhead_template2.docx
budgetdir=../budgets/`basename "${PWD}"`



# A few bonus targets that could be useful for reference for particular grants

# This recipe is atypical. It creates just the approach without specific aims.
# WARNING: useful only when the citation lists are divided
research_plan: figs
	$(mbin)/addrefsec `$(mbin)/ver src/research_plan` | \
	pandoc -o output/research_plan.pdf $(PANDOC_FLAGS)