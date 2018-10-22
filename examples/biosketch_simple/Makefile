# User configuration -----------------------------------------------------------
# Set this variable to point to your mediabuilder repository
mbdir = ${CODEBASE}mediabuilder

# choose a mediabuilder type: 'manuscript', 'cv', or 'grant'
mbtype = biosketch

# Include the mediabuilder.make file to get access to default recipes and
# default variables (which can be overridden below)
include $(mbdir)/mediabuilder.make


# User overrides ---------------------------------------------------------------
#csl = ${CODEBASE}styles/bioinformatics.csl
#csl = ${CODEBASE}mediabuilder/csl/compact.csl
#csl = ${CODEBASE}mediabuilder/csl/nature.csl
#textemplate = $(mbdir)/tex_templates/manuscript.tex



cv_nih_standard:
	pandoc \
	src/nih_biosketch.md \
	--template $(textemplate) \
	-o output/nih_biosketch.pdf