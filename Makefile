grant:
	pandoc research_plan.md -o research_plan.docx --bibliography ~/code/papers/sheffield.bib --csl ~/code/styles/vancouver-superscript.csl  --reference-docx=template.docx
	pandoc project_information.md -o project_information.docx --reference-docx=template.docx
	pandoc environment.md -o environment.docx --reference-docx=template.docx
	pandoc budget_justification.md -o budget_justification.docx --reference-docx=template.docx
pdf:
	gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=grant_merged.pdf \
	ALSF_signed_cover_170522.pdf \
	TOC.pdf \
	environment.pdf \
	letters/letter_institute.pdf \
	project_information.pdf \
	ALSF_5_year_budget.pdf \
	budget_justification.pdf \
	2017-05_NIH_Biosketch.pdf \
	Biosketch-Gomez_FINAL.pdf \
	research_plan.pdf \
	letters/letter_eleni.pdf \
	letters/letter_kovar.pdf \
	letters/letter_rich.pdf \
	letters/letter_gomez.pdf
	pdflatex addpages.tex # add page numbers
	mv addpages.pdf grant_final2.pdf
	echo "grant_final.pdf"

texpdf:
	pandoc research_plan_tex.md \
	-o research_plan_test.pdf \
	--template textemplate.tex \
	--bibliography ~/code/papers/sheffield.bib \
	--variable sansfont=Arial \
	--filter pandoc-wrapfig/pandoc-wrapfig.py \
	--csl ~/code/styles/vancouver-superscript.csl

support:
	pandoc environment.md -o environment_test.pdf --template $$CODE\grants\textemplate.tex
