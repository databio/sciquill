# pandoc functions


pd:
	pandoc project_description.md -o   project_description.pdf \
	--filter ${CODEBASE}/pandoc-wrapfig/pandoc-wrapfig.py \
	--template ${CODEBASE}mediabuilder/textemplate_paper.tex \
	--bibliography ~/code/papers/sheffield.bib \
	--csl ~/code/styles/biomed-central.csl \
	--reference-docx=template.docx


mdToPdf() {
	pandoc $1.md -o $1.pdf \
	--filter ${CODEBASE}pandoc-wrapfig/pandoc-wrapfig.py \
	--template ${CODEBASE}mediabuilder/textemplate_paper.tex \
	--bibliography ${CODEBASE}papers/sheffield.bib \
	--csl ${CODEBASE}styles/biomed-central.csl
}

mdToPf project_description 