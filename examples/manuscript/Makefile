# User configuration -----------------------------------------------------------
# Set this variable to point to your mediabuilder repository
mbdir = ${CODEBASE}mediabuilder

# choose a mediabuilder type: 'manuscript', 'cv', or 'grant'
mbtype = manuscript

# Include the mediabuilder.make file to get access to default recipes and
# default variables (which can be overridden below)
include $(mbdir)/mediabuilder.make


# User overrides ---------------------------------------------------------------
#csl = ${CODEBASE}styles/bioinformatics.csl
#csl = ${CODEBASE}mediabuilder/csl/compact.csl
#csl = ${CODEBASE}mediabuilder/csl/nature.csl
#textemplate = $(mbdir)/tex_templates/manuscript.tex
docxtemplate = ~/Dropbox/uva_docs/letterhead_template2.docx


cover_letter:
	pandoc --preserve-tabs \
	--reference-doc $(docxtemplate) \
	-o output/cover_letter.docx \
	src/cover_letter.md
	libre --convert-to pdf output/cover_letter.docx \
	--outdir output
	pandoc -o output/cover_letter.txt \
	-t plain \
	--wrap=none \
	src/cover_letter.md

cover_letter_manuscript:
	$(mbin)/mergepdf output/merged.pdf \
	output/cover_letter.pdf \
	output/manuscript.pdf

manuscript_bioinfo: figs
	$(mbin)/addrefsec `$(mbin)/ver src/*manuscript` | \
	pandoc \
	-o output/manuscript_bioinformatics.pdf $(PANDOC_FLAGS) --template $(mbdir)/tex_templates/bioinfo.tex

manuscript_twocol: figs
	$(mbin)/addrefsec `$(mbin)/ver src/*manuscript` | \
	pandoc \
	-o output/manuscript_twocol.pdf $(PANDOC_FLAGS) --template $(mbdir)/tex_templates/twocol.tex
