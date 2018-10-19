SHELL := /bin/bash
# no bibliography for this LOI
csl_nobib = ${CODEBASE}mediabuilder/csl/bioinformatics-nobib.csl
#csl = ${CODEBASE}styles/bioinformatics.csl
csl = ${CODEBASE}mediabuilder/csl/biomed-central.csl
wrapfig = ${CODEBASE}mediabuilder/pandoc-wrapfig/pandoc-wrapfig.py
textemplate = ${CODEBASE}mediabuilder/tex_templates/manuscript.tex
docxtemplate = ~/Dropbox/uva_docs/letterhead_template2.docx
mbin=${CODEBASE}mediabuilder/bin
ifneq ("$(wildcard ${CODEBASE}papers/sheffield.bib)","")
bib = ${CODEBASE}papers/sheffield.bib
else
bib = refs.bib
endif

figs:
	$(mbin)/buildfigpdfs fig/*.svg

manuscript: figs
	pandoc `$(mbin)/ver src/*manuscript` \
	-o output/manuscript.pdf \
	--filter $(wrapfig) \
	--bibliography $(bib) \
	--template $(textemplate) \
	--csl $(csl)

manuscript_docx:
	$(mbin)/buildfigs fig/*.svg
	cat `$(mbin)/ver src/*manuscript` | sed 's/\.pdf/\.png/' | pandoc \
	-o output/manuscript.docx \
	--filter $(wrapfig) \
	--bibliography $(bib) \
	--template $(textemplate) \
	--csl $(csl)

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
