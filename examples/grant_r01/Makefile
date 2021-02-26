# Sciquill configuration ------------------------------------------------------
# sqdir - points to your sciquill repository
# sqtype - sciquill media type: 'manuscript', 'cv', or 'grant'
# then, include sciquill.make for default recipes and variables

sqdir = ${SQDIR}
sqtype = grant
include $(sqdir)/sciquill.make

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
approach_only: figs
	$(mbin)/nobib `$(mbin)/ver src/significance_innovation` \
	`$(mbin)/ver src/aim1` `$(mbin)/ver src/aim2` `$(mbin)/ver src/aim3` | \
	pandoc -o output/aims_approach.pdf $(PANDOC_FLAGS)

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
