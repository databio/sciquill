# Manuscript title


## Citations

Cite papers using brackets and `bibtex` keys. Example citation:
`[@Sheffield2016]` will be rendered like this [@Sheffield2016]. Use semicolons to separate multiple citations [@Sheffield2016; @Sheffield2018].

## Figures

![\label{abstract}Fig. \ref{abstract}: Example full-width figure](fig/example_figure.pdf) 


Refer to a figure using figure labels, so they are numbered automatically, like
this: `\ref{abstract}` (See Fig. \ref{abstract}).  Wrap a figure using the
`pandoc-wrapfig` extension by adding '{0}' to the end of the caption (Fig.
\ref{wrapped}).

![\label{wrapped}Fig. \ref{wrapped}: Wrap a figure {0}](fig/example_figure.pdf) 


Duis in tempor mauris, a lobortis nisl. Integer arcu lorem, vehicula sed ante
commodo, maximus eleifend nisi. Aenean efficitur molestie lorem, ac pharetra
felis euismod nec. Duis vitae ligula facilisis, dignissim justo eget, elementum
est. Nulla quis mi a justo porta pellentesque eget sit amet purus. Ut ac
vestibulum ante, in efficitur massa. Cras feugiat in urna facilisis ultrices.
Nullam vestibulum, lacus eget pretium pharetra, augue ligula consectetur diam,
eget condimentum ipsum magna sed augue.


## Embedded LaTeX

You can insert `latex` in-line in the markdown document: $rList[I_E] \leq q.start$

Or you can create separate environments like this:


### Algorithm examples

These examples use the `algorithmic` environment (from the `algorithmcx` package:)

\begin{algorithmic}
\Require $n \geq 0$
\Ensure $y = x^n$
\State $y \Leftarrow 1$
\State $X \Leftarrow x$
\State $N \Leftarrow n$
\While{$N \neq 0$}
\If{$N$ is even}
  \State $X \Leftarrow X \times X$
  \State $N \Leftarrow \frac{N}{2} $  \Comment{This is a comment}
\ElsIf{$N$ is odd}
  \State $y \Leftarrow y \times X$
  \State $N \Leftarrow N - 1$
\EndIf
\EndWhile
\end{algorithmic}


\begin{algorithmic}[1]
\Repeat
\Comment{forever}
\State this\Until{you die.}
\end{algorithmic}

This example uses the `algorithm` environment:

\begin{algorithm}
\caption{Euclid’s algorithm}\label{euclid}
\begin{algorithmic}[1]
\Procedure{Euclid}{$a,b$}\Comment{The g.c.d. of a and b}
\State $r\gets a\bmod b$
\While{$r\not=0$}\Comment{We have the answer if r is 0}
\State $a\gets b$
\State $b\gets r$
\State $r\gets a\bmod b$
\EndWhile\label{euclidendwhile}
\State \textbf{return} $b$\Comment{The gcd is b}
\EndProcedure
\end{algorithmic}
\end{algorithm}

