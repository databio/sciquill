# link to parent/root makefile
SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
include $(SELF_DIR)root.make

.DEFAULT_GOAL := research_plan

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

