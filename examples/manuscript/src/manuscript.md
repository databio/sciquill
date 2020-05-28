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


\Begin{widefig}

![\label{fig3}Fig. \ref{fig3}: Example double-column figure](fig/example_figure.pdf) 

\End{widefig}



Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed vulputate tellus
sed vulputate maximus. Interdum et malesuada fames ac ante ipsum primis in
faucibus. Praesent interdum sapien dui, in placerat velit egestas auctor. Class
aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos
himenaeos. Etiam ac nunc auctor, iaculis nulla quis, tempor arcu. Vestibulum
volutpat, massa sed blandit aliquet, est elit rhoncus est, eu finibus leo turpis
sit amet nisl. Fusce nec diam ut sapien rutrum consequat. Aliquam massa sapien,
molestie sed ligula vitae, lacinia rutrum mi. Fusce ullamcorper accumsan quam
vel aliquam. Nullam efficitur, arcu eu consectetur tempus, mi dui facilisis
dolor, id lacinia augue turpis ut massa. Proin tincidunt congue lobortis.
Vestibulum semper condimentum enim accumsan malesuada. Aenean interdum tellus id
ex scelerisque mattis. Mauris tempor urna felis, eu efficitur eros tempus
condimentum. Aliquam erat volutpat.

Vivamus eu rhoncus neque.
Quisque egestas venenatis odio a mattis.
Ut ligula turpis, facilisis a cursus eget, semper quis dolor.
Integer varius est ipsum, porttitor ornare eros placerat eget.
Nulla aliquet nisi arcu, sed vestibulum urna faucibus pretium.
Maecenas laoreet diam non urna tincidunt iaculis a ut ex.
Aenean sem enim, laoreet id accumsan sed, faucibus vitae diam.
Aenean facilisis tincidunt risus.
Mauris sit amet hendrerit est, sit amet maximus augue.

# Tables

You can use markdown tables, too. Captions are preceded by the *Table* keyword.
Unfortunately, I can't figure out how to put the caption below the table (it's above it by default).

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