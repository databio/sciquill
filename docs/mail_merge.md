# Mail merge

Mail merges are now possible using what are called markmeld "multi-output" targets. Basically, you need to specify 2 things: 1) a variable with an array to loop over, and 2) a variable name that will assume the value of each item in the array. For a mail merge, your array would be a list of addressees, and you'd assign each one to some variable, say, `recipient`. Then, you just have to ensure that your jinja template uses the `recipient` variable, and specify an output filepath that uses something that varies in the `recipient` variable, and that's it.

This process is documented here: 

[https://github.com/databio/markmeld/blob/master/docs/multi_targets.md](https://github.com/databio/markmeld/blob/master/docs/multi_targets.md)

See this issue for more information: [https://github.com/databio/markmeld/issues/1](https://github.com/databio/markmeld/issues/1).

