# Advanced templates: variable variables

## Motivation

In a typical markmeld application, you'll encode the structure of your document within the jinja file. That's great. But to make the template reusable, sometimes it's convenient to do things like specify a *list* of items that show up somewhere in the document. For example, you may want a template to display a list of files in the output. If you encoded this directly, you'd have to change the template if the number of files changed. Here, we'll walk through a better alternative that uses markmeld `data_variables` with a jinja loop through the `md` array.

## The markmeld `_md` array

### How to access variable-named elements

Here's an example. Say I'm writing a book on finances. I have 3 chapters: *intro*, *credit*, and *savings*, each written in its own `.md` file. To start, I write a simple `_markmeld.yaml` config file that loads each chapter into an object:

```
targets:
  default:
    jinja_template: book.jinja
    output_file: "{today}_demo_output.pdf"
    data_md:
      intro: md/01-intro.md
      credit: md/02-credit.md
      savings: md/03-savings.md

```

My `book.jinja` template could simply be like this, which puts the chapters in order:

```
{{ intro }}
{{ credit }}
{{ savings }}
```

Great. That works. But the problem is that this jinja template is specific now to this particular set of chapters, and adding new chapters means changing the template, which is a pain. Could I make `book.jinja` adaptable and generic, so it will work with *any* chapters I add, and even extend to work with any book I may write in the future, regardless of what I name the chapter files and variables? Yes! You can do this using the magic of `data.variables`. Instead of specifying chapters directly in `book.jinja`, we'll take advantage of 2 markmeld features: 1. The `_md` variable contains an array of all the `.md` files in our target's `data`, indexed by key we specify; and 2. we can specify custom data to the jinja tempalte using `data.variables`. We'll define an array of variable names, and then use a jinja loop to loop through that array and use those values to index into the `_md` object.

### The `md` array

Markmeld makes available to jinja an array under the name `md` which has access to all of the markdown elements keyed by their names. So, while you can access the *intro* chapter directly with `{{ intro }}`, you can also access it through the `md` array using `{{ _md["intro"].content }}`. Take it one step further, and this means if you have "intro" in a variable, say `myvar`, you could access the exact same content with `{{ _md[myvar].content }}`.

So, let's set up an array with values as the chapter names by adding this to `_markmeld.yaml`:

```
  target:
    data:
      variables:
        chapters:
          - intro
          - credit
          - savings
```

This will give us access in the jinja template to a `chapters` array with those 3 values in it. So, we can switch the markmeld template to use this array like so...

```
{% for chapter in chapters %}
{{ _md[chapter].content }}
{% endfor %}
```

And voila! We have the same output, but now we've encoded the chapter order logic in the markmeld config file, and this jinja template can be reused. It's beautiful.

### `_md` array properties

In addition to the `.content` property, for each `md` file, you can also access other stuff:

- `_md[id].content` - content of the file
- `_md[id].path` - path to the file (relative to `_markmeld.yaml`)
- `_md[id].frontmatter` - frontmatter in the md file
- `_md[id].ext` - file extension

### `_yaml` array

The `_yaml` array operates in much the same way, though it doesn't provide a `.frontmatter` since there's no frontmatter to a yaml array. So it just provides:

- `_md[id].content` - content of the file
- `_md[id].path` - path to the file (relative to `_markmeld.yaml`)
- `_md[id].ext` - file extension
