# link to parent/root makefile
SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)root.make

.DEFAULT_GOAL := manuscript_supplement

# Set default tokens, which are strings to identify source files

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


textemplate = $(sqdir)/tex_templates/manuscript.tex

manuscript: sq-check-core figs manuscript_nofig

supplement: figs supplement_nofig

manuscript_supplement: sq-check-core figs manuscript_supplement_nofig

manuscript_nofig:
	cat `$(sqbin)/ver src/*$(manuscript_token)` | \
	pandoc $(PANDOC_FLAGS) \
	-o output/$(manuscript_token).pdf
	@echo "Output: output/$(manuscript_token).pdf"

manuscript_supplement_nofig:
	cat `$(sqbin)/ver src/*$(manuscript_token)` \
	`$(sqbin)/ver src/*$(supplement_token)`| \
	pandoc $(PANDOC_FLAGS) \
	-o output/$(manuscript_token)_$(supplement_token).pdf
	@echo "Output: output/$(manuscript_token)_$(supplement_token).pdf"

split_supplement:
	$(sqbin)/splitsupl \
	output/$(manuscript_token)_$(supplement_token).pdf \
	output/$(manuscript_token).pdf \
	output/$(supplement_token).pdf
	@echo "Output: output/$(supplement_token).pdf"

supplement_nofig:
	cat `$(sqbin)/ver src/*$(supplement_token)` | \
	pandoc $(PANDOC_FLAGS) \
	-o output/$(supplement_token).pdf
	@echo "Output: output/$(supplement_token).pdf"

manuscript_supplement_tex:
	cat `$(sqbin)/ver src/*$(manuscript_token)` \
	`$(sqbin)/ver src/*$(supplement_token)`| \
	pandoc $(PANDOC_FLAGS) \
	-o output/$(manuscript_token)_$(supplement_token).tex

# Produce a docx version of the paper, which can be necessary for feedback
manuscript_docx:
	cat `$(sqbin)/ver src/*$(manuscript_token)` | sed 's/\.pdf/\.png/' | pandoc \
	-o output/manuscript.docx $(PANDOC_FLAGS)

manuscript_tex:
	cat `$(sqbin)/ver src/*$(manuscript_token)` | pandoc \
	-o output/manuscript.tex $(PANDOC_FLAGS) --biblatex

manuscript_aux:	
	~/code/docker/bin/pdflatex --output-directory=output output/manuscript.tex

manuscript_txt:	
	cat `$(sqbin)/ver src/*$(manuscript_token)` | sed 's/\.pdf/\.png/' | pandoc \
	-o output/manuscript.txt --to=plain

# cover letter plus manuscript
cover_manuscript: cover_letter
	$(sqbin)/mergepdf output/$(cover_token)_$(manuscript_token)_$(supplement_token).pdf \
	output/$(cover_token).pdf \
	output/$(manuscript_token).pdf
	@echo "Output: output/$(cover_token)_$(manuscript_token)_$(supplement_token).pdf"


# Produce a subset bibliography for the manuscript
bibsub:
	mkdir -p bibgen
	$(sqbin)/nobib `$(sqbin)/ver src/*$(manuscript_token)` | \
	pandoc -o bibgen/$(manuscript_token).tex --csl $(csl) --template $(textemplate)  --biblatex
	pdflatex --output-directory=bibgen bibgen/$(manuscript_token).tex
	jabref -n -a bibgen/$(manuscript_token).aux,bibgen/`hostname`.bib ${BIBTEXDB}
	cat bibgen/*.bib > output/refs.bib

cover_letter: sq-check-lettertemplate
	@echo "Letter template '$(lettertemplate)'"
	pandoc -o output/cover_letter.pdf $(PANDOC_FLAGS) \
	--template $(lettertemplate) \
	src/cover_letter.md

cover_letter_txt:
	pandoc -o output/cover_letter.txt \
	-t plain \
	--wrap=none \
	letter.md

response:
	cat `$(sqbin)/ver src/*$(response_token)` | \
	pandoc -o output/$(response_token).pdf $(PANDOC_FLAGS) \
	--template $(sqdir)/tex_templates/manuscript.tex
	@echo "Output: output/$(response_token).pdf"
