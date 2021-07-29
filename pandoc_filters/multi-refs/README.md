# multi-refs pandoc filter

## Introduction and rationale

This filter lets you have multiple references sections. It's similar to the earlier `section-refs.lua` filter, but provides a bit more control: instead of automatically generating a bibliography for every section, it lets the user select where the bibliographies will go by including `multi-refs` divs. Each div will display the references that have accumulated to that point in the document.

I use this to divide my references section into one for the primary manuscript, and a separate references section for supplemental text.

## Configuration

### Specifying bibliographies

Place this in your markdown file to specify where you want your bibliography placed:

```
<div class="multi-refs"></div>
```

You can put that in multiple places and it will just show the citations that have accumulated to that point in the document.

### Duplicate references

What do you want to do if you have a reference that repeats across sections? Do you want it to be listed in both bibliographies, or only the first one? 

I think it looks nicest if you include it in both for alphabetical citation styles, but only include it in the first one for numerically ordered citation styles. By default it will list the entity in both bibliographies, but you can turn it off by adding this to the metadata:

```
---
multiref_no_duplicates: true
---
```

## Test it

Numeric references:

```
pandoc --citeproc --lua-filter multi-refs.lua \
	sample.md -o sample.pdf --bibliography bibliography.bib --csl /home/nsheff/code/sciquill/csl/biomed-central.csl
```

Alphabetical references: 

```
pandoc --citeproc --lua-filter multi-refs.lua \
	sample.md -o sample.pdf --bibliography bibliography.bib
```
