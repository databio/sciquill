# Sciquill configuration ------------------------------------------------------
# sqdir - points to your sciquill repository
# sqtype - sciquill media type: 'sqmanuscript', 'sqcv', or 'sqgrant'

sqdir = ${SQDIR}
sqtype = biosketch
include $(sqdir)/sciquill.make

cv_nih_standard:
	pandoc \
	src/nih_biosketch.md \
	--template $(textemplate) \
	-o output/nih_biosketch.pdf