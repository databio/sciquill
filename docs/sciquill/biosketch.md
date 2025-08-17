# NIH Biosketch

Like any markmeld target, building a biosketch simply requires specifying the inputs, the jinja template, and the

You can build an NIH biosketch from structured YAML/md input using markmeld. A demo showing how this works is in [https://github.com/databio/sciquill/tree/master/examples/biosketch_simple](https://github.com/databio/sciquill/tree/master/examples/biosketch_simple).


## User-provided Inputs

Basically, as a user who wants to build a biosketch, you need to provide markmeld with a few things:

### 1. Structured personal data in YAML format

Use a `.yaml` file for you biographical data. For example, it looks something like this:

```yaml
personal:
  last_name: Sheffield
  given_name: Nathan C.
  title: PhD
  web: https://www.databio.org
  eracommons: NSHEFF

...
```

I add in other information like training positions, honors, etc. See [the complete example here](https://github.com/databio/sciquill/blob/master/examples/biosketch_simple/src/biodata.yaml).

### 2. Written statements in markdown format

I have my personal statement and each of the 5 contributions stored as a markdown file. This is pretty basic, just a text file with prose in it.


### 3. References

You need to pass any references to markmeld in `yaml` format. Then, you can cite them using `pandoc-citeproc` and then you cite them in the personal statement or contributions with simple `@key` syntax.

## Sciquill-provided inputs

Markmeld also requires the templates that take your structure data and produce the desired output. Since I've already built these for my own biosketch, you can just use them as is, as long as you follow the examples to fit these templates. Or, of course, you're free to write your own if you want to do this in a different way. But the two templates you have to provide are the Jinja template and the LaTeX template.

### 4. Jinja template

I use a jinja template to structure the above information into a biosketch. I've made my jinja template available here: [databio.org/mm_templates/biosketch/nih_biosketch.jinja](https://databio.org/mm_templates/biosketch/nih_biosketch.jinja)

### 5. LaTeX template

I included a LaTeX template for the NIH biosketch layout in this repository ([https://github.com/databio/sciquill/blob/master/tex_templates/nih_bs.tex](https://github.com/databio/sciquill/blob/master/tex_templates/nih_bs.tex)).

### 5. Markmeld configuration

Then, you just need a `_markmeld.yaml` file that configures this target by specifying the paths to each of the entities above. You can find an example in the repository above.

## Mix and match contributions and statements

One thing I like about this approach is that I can create new biosketches by mix-and-matching components, and I just have to create a new target in my `_markmeld.yaml` file. Then I don't have to keep a bunch of different versions up-to-date, because if I change something in the structured yaml bio data file (like a new academic position), it updates everything automatically because the biosketches are built on-the-fly.

## Future plans

This `jinja` template, like any jinja template, expects the data in a certain structure; for example, the references need to be in an array under a key named `references`, the personal information is an object under `personal`, etc. I need to write a schema that defines these expectations, and then a little validator could tell you what you're missing, making it easier to get started.
