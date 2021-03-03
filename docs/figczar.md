# Figures in sciquill

For figures, sciquill includes a pandoc filter called `figczar`, which adds power to pandoc's ability to display figures in LaTeX documents. I called it figczar because it handles several different underlying figure capabilities all in one filter. It can handle figures wrapping or setting multi-column figures.

## Figure labels

You can refer to figures by LaTeX label instead of by number, which makes reordering figures within documents easy.  It also makes it possible to move figures and references from one document to another without renumbering.
```
![\label{abstract}Fig. \ref{abstract}: Example figure](fig/example_figure.png) 
```

Refer to figures with `\ref{label}`.

## Wrapfig

Append `{wrap=X}` as an attribute after your figure to wrap figures using the [LaTeX wrapfig package](https://ctan.org/pkg/wrapfig?lang=en). 

Use like this:

```
![\label{myfigure}Fig \ref{myfigure}. Fig Title](fig/pdf/figure.pdf){wrap=82mm}
```

Specify the width (*i.e. 82mm*) in any LaTeX-compatible way that suits you.

## Full-width figs

Use `{fullwidth=t}` as an image attribute to indicate a `\figure*` (figure STAR) environment to make a figure span columns in a multi-column template.

Use it like this:

```
![\label{myfigure2}Fig \ref{myfigure2}. Fig 2 Title](fig/pdf/figure2.pdf){fullwidth=t}
```

You can use any LaTeX-compatible positioning options here. For example, `{fullwidth=t}` sets valign to top, while `{fullwidth=b}` sets valign to bottom.

Latex options summary:

- h: *here*. Place figure where the figure environment is, if there is enough room
- t: *top*. Place at the top of a page.
- b: *bottom*. Place at the bottom of a page.
- p: *page*. Place on a page containing only floats.
- !: *bang/force*. Ignore parameters for float placement.

