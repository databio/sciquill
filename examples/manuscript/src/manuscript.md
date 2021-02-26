---
title: "Example article title"
short_title: "Short title"
year: 2019
notes-after-punctuation: false
class: Research Article
section: Genome Analysis
author:
- name: Nathan C. Sheffield
  affiliation: "1,2,3,4"
  correspondence: "nsheffield@virginia.edu"
institutions:
- name: Center for Public Health Genomics, University of Virginia
  key: 1
- name: Department of Public Health Sciences, University of Virginia
  key: 2
- name: Department of Biomedical Engineering, University of Virginia
  key: 3
- name: Department of Biochemistry and Molecular Genetics, University of Virginia
  key: 4
abstract: |
  Vivamus eu rhoncus neque. Quisque egestas venenatis odio a mattis. Ut ligula
  turpis, facilisis a cursus eget, semper quis dolor. Integer varius est ipsum,
  porttitor ornare eros placerat eget. Nulla aliquet nisi arcu, sed vestibulum
  urna faucibus pretium. Maecenas laoreet diam non urna tincidunt iaculis a ut ex.
  Aenean sem enim, laoreet id accumsan sed, faucibus vitae diam. Aenean facilisis
  tincidunt risus. Mauris sit amet hendrerit est, sit amet maximus augue.
---

# Citations

Cite papers using brackets and `bibtex` keys. Example citation:
`[@Sheffield2016]` will be rendered like this [@Sheffield2016]. Use semicolons to separate multiple citations [@Sheffield2016; @Sheffield2018].

# Figures

![\label{abstract}Fig. \ref{abstract}: Example full-width figure](fig/pdf/example_figure.pdf) 

Refer to a figure using figure labels, so they are numbered automatically, like
this: `\ref{abstract}` (See Fig. \ref{abstract}).  Wrap a figure using the
`pandoc-wrapfig` extension by adding '{0}' to the end of the caption (Fig.
\ref{wrapped}).

![\label{wrapped}Fig. \ref{wrapped}: Example wrapped figure](fig/pdf/example_figure.pdf){wrap=44mm}

Duis in tempor mauris, a lobortis nisl. Integer arcu lorem, vehicula sed ante
commodo, maximus eleifend nisi. Aenean efficitur molestie lorem, ac pharetra
felis euismod nec. Duis vitae ligula facilisis, dignissim justo eget, elementum
est. Nulla quis mi a justo porta pellentesque eget sit amet purus. Ut ac
vestibulum ante, in efficitur massa. Cras feugiat in urna facilisis ultrices.
Nullam vestibulum, lacus eget pretium pharetra, augue ligula consectetur diam,
eget condimentum ipsum magna sed augue.


![\label{fig3}Fig. \ref{fig3}: Example double-column figure](fig/pdf/example_figure.pdf){fullwidth=t}


Vivamus eu rhoncus neque.
Quisque egestas venenatis odio a mattis.
Ut ligula turpis, facilisis a cursus eget, semper quis dolor.
Integer varius est ipsum, porttitor ornare eros placerat eget.
Nulla aliquet nisi arcu, sed vestibulum urna faucibus pretium.
Maecenas laoreet diam non urna tincidunt iaculis a ut ex.
Aenean sem enim, laoreet id accumsan sed, faucibus vitae diam.
Aenean facilisis tincidunt risus.
Mauris sit amet hendrerit est, sit amet maximus augue.

Duis in tempor mauris, a lobortis nisl. Integer arcu lorem, vehicula sed ante
commodo, maximus eleifend nisi. Aenean efficitur molestie lorem, ac pharetra
felis euismod nec. Duis vitae ligula facilisis, dignissim justo eget, elementum
est. Nulla quis mi a justo porta pellentesque eget sit amet purus. Ut ac
vestibulum ante, in efficitur massa. Cras feugiat in urna facilisis ultrices.
Nullam vestibulum, lacus eget pretium pharetra, augue ligula consectetur diam,
eget condimentum ipsum magna sed augue.

Duis in tempor mauris, a lobortis nisl. Integer arcu lorem, vehicula sed ante
commodo, maximus eleifend nisi. Aenean efficitur molestie lorem, ac pharetra
felis euismod nec. Duis vitae ligula facilisis, dignissim justo eget, elementum
est. Nulla quis mi a justo porta pellentesque eget sit amet purus. Ut ac
vestibulum ante, in efficitur massa. Cras feugiat in urna facilisis ultrices.
Nullam vestibulum, lacus eget pretium pharetra, augue ligula consectetur diam,
eget condimentum ipsum magna sed augue.


# Tables

## One-column table

\begin{table}[H]
    \centering\normalsize
    \begin{tabular}{cl}
    \toprule
  \textbf{Flag} & \textbf{Indication} \\ \midrule
   1 & CONTENT-ALL-A-IN-B \\ 
   2 & CONTENT-ALL-B-IN-A \\ 
   4 & LENGTHS-ALL-A-IN-B \\ 
   8 & LENGTHS-ALL-B-IN-A \\ 
   16 & NAMES-ALL-A-IN-B \\ 
   32 & NAMES-ALL-B-IN-A \\ 
   64 & CONTENT-A-ORDER \\ 
   128 & CONTENT-B-ORDER \\ 
   \bottomrule 
   \end{tabular}
    \caption{\textit{Table \label{params}\ref{params}:} \textbf{Compatibility flags} Parameter combinations used in the analysis and their results.}
    \label{params}
\end{table}


## A two-column table

You can do a two-column table using the `\begin{table*}` environment. See Table \ref{param_table}.

\begin{table*}[h]
    \centering\footnotesize
    \begin{tabular}{|l|l|l|l|p{2cm}|p{2cm}|p{2cm}|p{2cm}|}
    \hline
        parameter set & add & drop & shift & Jaccard mean & Coverage mean & Euclidean mean & Cosine mean \\ \hline
        add1 & 0.1 & 0.0 & 0.0 & 0.909 & 0.981 & 0.939 & 0.988 \\ \hline
        add2 & 0.2 & 0.0 & 0.0 & 0.833 & 0.964 & 0.914 & 0.977 \\ \hline
        add3 & 0.3 & 0.0 & 0.0 & 0.769 & 0.951 & 0.895 & 0.966 \\ \hline
        drop1 & 0.0 & 0.1 & 0.0 & 0.900 & 0.950 & 0.883 & 0.954 \\ \hline
        drop2 & 0.0 & 0.2 & 0.0 & 0.800 & 0.900 & 0.834 & 0.905 \\ \hline
        drop3 & 0.0 & 0.3 & 0.0 & 0.700 & 0.850 & 0.796 & 0.852 \\ \hline
        shift1 & 0.0 & 0.0 & 0.2 & 0.941 & 0.902 & 0.979 & 0.998 \\ \hline
        shift2 & 0.0 & 0.0 & 0.5 & 0.860 & 0.756 & 0.966 & 0.996 \\ \hline
        shift3 & 0.0 & 0.0 & 0.8 & 0.785 & 0.610 & 0.957 & 0.994 \\ \hline
        add\_drop1 & 0.1 & 0.1 & 0.0 & 0.942 & 0.933 & 0.874 & 0.946 \\ \hline
        add\_drop2 & 0.1 & 0.2 & 0.0 & 0.840 & 0.886 & 0.831 & 0.901 \\ \hline
        add\_drop3 & 0.1 & 0.3 & 0.0 & 0.737 & 0.838 & 0.795 & 0.852 \\ \hline
        add\_drop4 & 0.2 & 0.1 & 0.0 & 0.783 & 0.920 & 0.865 & 0.939 \\ \hline
        add\_drop5 & 0.2 & 0.2 & 0.0 & 0.878 & 0.886 & 0.827 & 0.898 \\ \hline
        add\_drop6 & 0.2 & 0.3 & 0.0 & 0.772 & 0.828 & 0.795 & 0.852 \\ \hline
        add\_drop7 & 0.3 & 0.1 & 0.0 & 0.736 & 0.910 & 0.857 & 0.932 \\ \hline
        add\_drop8 & 0.3 & 0.2 & 0.0 & 0.693 & 0.867 & 0.824 & 0.894 \\ \hline
        add\_drop9 & 0.3 & 0.3 & 0.0 & 0.807 & 0.828 & 0.795 & 0.851 \\ \hline
        shift\_drop1 & 0.0 & 0.1 & 0.2 & 0.850 & 0.857 & 0.882 & 0.953 \\ \hline
        shift\_drop2 & 0.0 & 0.1 & 0.5 & 0.779 & 0.718 & 0.879 & 0.950 \\ \hline
        shift\_drop3 & 0.0 & 0.1 & 0.8 & 0.714 & 0.579 & 0.877 & 0.949 \\ \hline
        shift\_drop4 & 0.0 & 0.2 & 0.2 & 0.758 & 0.812 & 0.833 & 0.904 \\ \hline
        shift\_drop5 & 0.0 & 0.2 & 0.5 & 0.765 & 0.767 & 0.832 & 0.902 \\ \hline
        shift\_drop6 & 0.0 & 0.2 & 0.8 & 0.642 & 0.548 & 0.830 & 0.900 \\ \hline
        shift\_drop7 & 0.0 & 0.3 & 0.2 & 0.665 & 0.767 & 0.795 & 0.851 \\ \hline
        shift\_drop8 & 0.0 & 0.3 & 0.5 & 0.615 & 0.643 & 0.794 & 0.849 \\ \hline
        shift\_drop9 & 0.0 & 0.3 & 0.8 & 0.568 & 0.518 & 0.793 & 0.847 \\ \hline
    \end{tabular}
    \caption{\textit{Table \label{param_table}\ref{param_table}:} \textbf{Parameter combinations used in the analysis and their results.}}
    \label{param_table}
\end{table*}



## Markdown tables

You can use markdown tables, too...sort of. Pandoc renders markdown tables with the `longtable` package. But longtable is not compatible with a two-column template. So, there are a few hacks and workarounds, but nothing works really well. The best thing I have found works *sometimes* -- but then occasionally it just gobbles up text and figures silently. So, I suggest using latex templates until this issue is solved:

https://github.com/jgm/pandoc/issues/1023

Another issue is that Captions are preceded by the *Table* keyword.
Unfortunately, I can't figure out how to put the caption below the table (it's above it by default).

<!-- 
| Flag   | Indication                 |
| :----: | -------------------------- |
| 1      | CONTENT_ALL_A_IN_B         |
| 2      | CONTENT_ALL_B_IN_A         |
| 4      | LENGTHS_ALL_A_IN_B         |
| 8      | LENGTHS_ALL_B_IN_A         |
| 16     | NAMES_ALL_A_IN_B           |
| 32     | NAMES_ALL_B_IN_A           |
| 64     | CONTENT_A_ORDER            |
| 128    | CONTENT_B_ORDER            |
| 256    | CONTENT_ANY_SHARED         |
| 512    | LENGTHS_ANY_SHARED         |
| 1024   | NAMES_ANY_SHARED           |

Table: Table \label{param_table}\ref{param_table}: **Compatibility flags**. A list of flags for compatibility testing functions.
 -->




## Lorem ipsum

In hac habitasse platea dictumst. Mauris ut aliquet nunc, id mattis velit. Nunc
commodo enim sed orci ultrices sodales. Fusce nec sem est. Nam euismod erat at
neque facilisis iaculis. Cras rutrum elementum erat eu egestas. In sit amet est
vitae ligula semper vestibulum sit amet quis justo. Sed porta dolor ac
scelerisque congue.

Vivamus convallis arcu et lacus egestas tempus. Pellentesque habitant morbi
tristique senectus et netus et malesuada fames ac turpis egestas. Integer
eleifend efficitur risus sit amet suscipit. Curabitur consectetur sapien eget
nulla maximus, quis lobortis nisl porta. Sed hendrerit semper placerat. Nulla
sagittis orci arcu, a tincidunt lorem lacinia sit amet. Nullam nec fringilla
odio. In mollis vitae nibh ut sollicitudin. Aliquam finibus tellus quis
sollicitudin cursus. Cras lobortis, tortor ac sodales tempus, lacus ipsum
aliquam mauris, sed placerat neque ante in arcu. Aliquam erat volutpat. Donec eu
sodales odio, eu cursus libero.

Sed in porttitor leo. Class aptent taciti sociosqu ad litora torquent per
conubia nostra, per inceptos himenaeos. Sed tristique malesuada ligula,
vulputate commodo mi lacinia ut. Ut consectetur, mauris vitae hendrerit mattis,
nisi urna condimentum nibh, vitae rhoncus nulla tellus sit amet dui. Vivamus
tempus magna eget quam posuere interdum. Nulla turpis augue, consequat quis
euismod a, tincidunt sed ligula. Integer ac iaculis lacus, nec posuere augue.
Fusce vitae dictum felis. In hac habitasse platea dictumst. Etiam suscipit magna
turpis, eget volutpat lectus placerat quis. Mauris sed cursus erat. Sed a
pellentesque felis. Ut in blandit dolor, vitae lobortis justo. Aenean turpis
felis, pulvinar fringilla vulputate et, venenatis in lorem. Donec vulputate,
nunc non imperdiet ullamcorper, justo nunc placerat elit, ut pretium justo metus
a mi.


# Embedded LaTeX

You can insert `latex` in-line in the markdown document: $rList[I_E] \leq q.start$

Or you can create separate environments like this:


## Algorithm examples

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

Maecenas vitae sodales est, venenatis ullamcorper magna. Integer id orci ut arcu venenatis mattis. Pellentesque eget risus non lectus interdum efficitur. In pharetra odio in tellus eleifend commodo. Morbi facilisis mauris ac eros gravida pretium. Nam sit amet nisi massa. Morbi at turpis in leo dictum suscipit. Ut interdum, orci sed laoreet venenatis, odio dui consectetur tortor, sit amet vulputate ipsum neque ac ante. Vivamus vitae mi interdum, dignissim leo lobortis, ultricies leo. Aenean facilisis sagittis urna in blandit. Sed sit amet consectetur purus. Mauris bibendum efficitur magna, vitae egestas lacus pretium dignissim. Nullam eu magna est. Suspendisse vel lobortis metus.

Suspendisse potenti. Donec gravida ut mauris vel scelerisque. Nullam gravida maximus porttitor. Duis dictum nisl sed neque tristique sodales. Maecenas lacinia dolor eget ligula volutpat maximus. Etiam placerat lobortis enim ut iaculis. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Fusce porta venenatis metus, vehicula sagittis ligula faucibus vel. Nunc nibh ipsum, vulputate sed bibendum non, euismod at sem. Praesent mi nulla, ornare vitae est a, euismod facilisis mauris.

Mauris a orci vehicula, aliquam orci in, cursus eros. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras semper vel enim eu dapibus. Maecenas placerat arcu nec metus tincidunt pharetra. Aenean rhoncus lacinia elit et cursus. Ut et metus vel augue sagittis volutpat quis nec nisi. Ut massa nisi, maximus vitae faucibus ut, eleifend ut odio.

Nam aliquam ex non accumsan efficitur. Nullam vehicula lorem vitae porttitor pellentesque. Fusce a tristique mi, sed congue velit. Nullam at ornare quam. Proin hendrerit accumsan ipsum, sed viverra velit vehicula sit amet. Donec non lectus diam. Sed condimentum non velit vel suscipit. Sed odio ex, vestibulum ullamcorper odio sit amet, lobortis accumsan risus. Nulla facilisi. Mauris eleifend viverra metus, ac varius lacus scelerisque non. 


<div id="refs"></div>