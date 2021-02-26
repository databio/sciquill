# figczar

figczar is a pandoc plugin that adds more power to markdown's ability to display figures in LaTeX documents. I called it figczar because it handles several different underlying figure capabilities all in one filter. It has a few different features:

## Wrapfig

Wraps a figure using the [LaTeX wrapfig package](https://ctan.org/pkg/wrapfig?lang=en).

Use like this:

```
![\label{requirements}Fig \ref{requirements}. Course requirements](fig/pdf/focus_tracks.pdf){wrap=82mm}
```

Specify the width (*i.e. 82mm*) in any LaTeX-compatible way that suits you.

## Full-width figs

Uses the **\figure\*** (figure STAR) environment to make a figure span columns in a multi-column template.

Use it like this:

```
![\label{requirements}Fig \ref{requirements}. Course requirements](fig/pdf/focus_tracks.pdf){fullwidth=t}
```

You can use any LaTeX-compatible positioning options here. For example, `{fullwidth=t}` sets valign to top, while `{fullwidth=b}` sets valign to bottom.

Latex options summary:

- h: *here*. Place figure where the figure environment is, if there is enough room
- t: *top*. Place at the top of a page.
- b: *bottom*. Place at the bottom of a page.
- p: *page*. Place on a page containing only floats.
- !: *bang/force*. Ignore parameters for float placement.

