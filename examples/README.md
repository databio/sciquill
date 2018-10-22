# Mediabuilder examples

In these subfolders you will find skeleton examples for how to create different
media types using `mediabuilder`. Just copy the folder and edit the documents to
start a new project.

Each media type has a `src` subfolder where the markdown source documents will
live, and an `output` folder where the rendered PDF output goes. Each also comes
with a `Makefile` that will link to the parent mediabuilder Makefile
[mediabuilder.make](/mediabuilder.make), which provides a few basic variables.
This link is optional, but provides some convenience. The `Makefile` will then
specify a few recipes for converting the text source the appropriate output.