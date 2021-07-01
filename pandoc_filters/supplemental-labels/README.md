# Supplemental labels pandoc filter

This filter will hide supplemental figures (figures with `label` on them), and instead replace them with just latex labels.

It's a work in progress.

The idea is to keep cross-references while not showing the supplemental text and figures. So you can build the document with both, but only get the main text, so the cross references are preserved.
