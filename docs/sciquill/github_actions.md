# Automating a build with GitHub Action

## Getting started

1. Fork the example paper repository: [https://github.com/databio/sciquill_paper_example](https://github.com/databio/sciquill_paper_example)

2. Edit the file in `src/manuscript.md`.

3. Wait for the GitHub Action to complete. You can watch progress by clicking on the Actions tab.

4. View your PDF output in `output/manuscript.PDF`.


## Configuring your own

If you want GitHub to automatically build your sciquill document when you make changes, then you can copy the `github_workflows/build-sciquill.yaml` file into your repository under `.github/workflows`.
