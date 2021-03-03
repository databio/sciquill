# Sciquill recipes

Sciquill build instructions are just shell scripts stored in a makefile. Here are some useful recipes I've created over the years that you can add to your makefile:


## Converting an `.xls` file to `.pdf` with `libreoffice`:
Running `libreoffice` on the command-line like this will silently fail if you
already have `libreoffice` running. If you use a containerized version, you can
get around that issue. Use my `libre` docker container so you can run it while the real one is open. Or, this problem is also solved by using bulker.


```{Makefile}
budget:
	echo "Make sure libreoffice isn't already open"
	libreoffice --headless --invisible --convert-to pdf \
	--outdir output \
	src/budget_worksheet.xlsx
```

To set page printing limits in libreoffice calc:  
- go to View > Page Break
- now select the area to print
- choose: Format > Print Ranges > Define


## Converting a `.docx` to `.pdf` with  `libreoffice`:
```
pdf:
	soffice --convert-to pdf output/toc.docx \
	--outdir output
```



## Merging PDFs with `ghostscript`:

```
merge:
	$(mbin)/mergepdf output/merged.pdf \
	output/title_page.pdf \
	output/research_proposal.pdf \
	output/assembly_plan.pdf
```

## Adding page numbers

To add page numbers:

1. put the PDF document into the `tex_utilities/addpages.tex` file.
2. Run: `pdflatex addpages.tex`
3. Page numbers are added at addpages.pdf!
