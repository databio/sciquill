# Sciquill configuration ------------------------------------------------------
# sqdir - points to your sciquill repository
# sqtype - sciquill media type: 'manuscript', 'cv', or 'grant'
# then, include sciquill.make for default recipes and variables

sqdir = ${SQDIR}
sqtype = sqmanuscript
include $(sqdir)/sciquill.make


# User overrides ---------------------------------------------------------------
#csl = ${CODEBASE}styles/bioinformatics.csl
#csl = ${CODEBASE}mediabuilder/csl/compact.csl
#csl = ${CODEBASE}mediabuilder/csl/nature.csl
textemplate = $(sqdir)/tex_templates/manuscript.tex
lettertemplate="$(sqdir)/tex_templates/manuscript.tex"

cover_letter_manuscript:
	$(sqbin)/mergepdf output/merged.pdf \
	output/cover_letter.pdf \
	output/manuscript.pdf

manuscript_bioinfo: figs
	$(sqbin)/addrefsec `$(sqbin)/ver src/*manuscript` | \
	pandoc \
	$(PANDOC_FLAGS) --template $(sqdir)/tex_templates/bioinfo.tex \
	-o output/manuscript_bioinformatics.pdf 

manuscript_twocol: figs
	$(sqbin)/addrefsec `$(sqbin)/ver src/*manuscript` | \
	pandoc --verbose \
	$(PANDOC_FLAGS) --template $(sqdir)/tex_templates/twocol.tex \
	-o output/manuscript_twocol.pdf


manuscript_twocol_tex: figs
	$(sqbin)/addrefsec `$(sqbin)/ver src/*manuscript` | \
	pandoc \
	$(PANDOC_FLAGS) --template $(sqdir)/tex_templates/twocol.tex \
	-o output/manuscript_twocol.tex
