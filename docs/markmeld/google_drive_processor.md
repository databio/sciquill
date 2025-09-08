# Google Drive Processor

A unified Python class for processing Google Drive files, including downloading Google Docs as markdown and converting SVG files to PDFs.

## Requirements

```bash
pip install google-auth google-auth-oauthlib google-auth-httplib2 google-api-python-client python-frontmatter

# For SVG to PDF conversion
sudo apt-get install inkscape  # Ubuntu/Debian
brew install inkscape          # macOS
```

## Setup

1. Create a service account in Google Cloud Console
2. Download the service account credentials JSON file
3. Place credentials in a secure location (default: `/home/nsheff/auth/shefflab-google-service-acct-credentials.json`)
4. Share the Google Drive files/folders you want to access with the service account email

## Quick Start

```python
from markmeld.google_drive import GoogleDriveProcessor

# Initialize processor
processor = GoogleDriveProcessor()

# Download and clean a Google Doc
doc = processor.download_doc('your-doc-id')
print(doc.content)  # Clean markdown content

# Process SVG files from a folder
results = processor.process_svg_folder('folder-id')

# Process entire manuscript folder (docs + figures)
results = processor.process_drive_folder('folder-id')
```

## Features

### Document Processing
- **Clean markdown output**: Automatically removes escape characters, embedded images, and bold from headings
- **File output**: Save documents directly to disk
- **Batch downloads**: Process multiple documents at once
- **Smart naming**: Use Google Drive document names for files
- **Flexible cleaning**: Choose which cleaning operations to apply
- **Metadata access**: Get document information without downloading content
- **Frontmatter parsing**: Automatic YAML frontmatter detection and parsing

### SVG Processing
- **SVG to PDF conversion**: Convert SVG files to PDFs using Inkscape
- **Batch processing**: Process entire folders of SVG files
- **Smart caching**: Skip unchanged files using MD5 checksums
- **Directory organization**: Automatic output directory structure

### Unified Processing
- **Manuscript folders**: Process complete manuscript projects with documents and figures
- **Auto-detection**: Automatically finds manuscript documents and figure folders

## Usage Examples

### Basic Document Download

```python
# Download and clean with frontmatter parsing
doc = processor.download_doc('doc-id')

# Download without cleaning
raw = processor.download_doc_raw('doc-id')

# Download cleaned markdown as string
content = processor.download_doc_clean('doc-id')
```

### Save Documents to File

```python
# Download and save to specific file
processor.download_doc('doc-id', output_path='output/document.md')

# Download with selective cleaning
content = processor.clean_markdown(
    markdown_content,
    clean_escapes=True,
    remove_images=True,
    strip_heading_bold=False  # Keep bold in headings
)
```

### Process SVG Files

```python
# Process all SVGs in a folder
results = processor.process_svg_folder('folder-id')
print(f"Converted: {results['stats']['converted']}")
print(f"Skipped: {results['stats']['skipped']}")

# Process without caching (always convert)
results = processor.process_svg_folder('folder-id', skip_unchanged=False)

# List SVG files in a folder
svg_files = processor.list_svg_files('folder-id')
for svg in svg_files:
    print(f"{svg['name']}: {svg['id']}")
```

### Batch Document Download

```python
# Download multiple docs to a folder
doc_ids = ['id1', 'id2', 'id3']
results = processor.download_docs_batch(
    doc_ids,
    output_folder='output/docs',
    use_document_names=True  # Use Google Drive names
)

# Use convenience method
results = processor.process_docs(doc_ids)
```

### Custom Configuration

```python
# Use custom credentials and base directory
processor = GoogleDriveProcessor(
    credentials_path='/path/to/credentials.json',
    local_base_dir='my_output',
    scopes=['https://www.googleapis.com/auth/drive.readonly']
)

# Check processor configuration
print(processor)  # Simple string representation
print(repr(processor))  # Detailed representation
info = processor.info()  # Get full configuration details
```

### Get File Metadata

```python
# Get metadata for any file (doc, SVG, etc.)
metadata = processor.get_metadata('file-id')
print(f"File: {metadata['name']}")
print(f"Type: {metadata['mimeType']}")
print(f"Modified: {metadata['modifiedTime']}")
```

### Process Complete Manuscript Folder

```python
# Process a folder containing manuscript and figures
results = processor.process_drive_folder(
    'folder-id',
    process_doc=True,   # Download and clean manuscript
    process_figs=True,  # Convert SVGs to PDFs
    output_path='output/manuscript.md'
)

# Access results
if results['document']:
    print(f"Processed: {results['document_name']}")
if results['figs_results']:
    stats = results['figs_results']['stats']
    print(f"Figures: {stats['converted']} converted")
```

## API Reference

### Initialization

```python
GoogleDriveProcessor(
    credentials_path: Optional[str] = None,
    local_base_dir: str = "output",
    scopes: Optional[List[str]] = None
)
```

### Document Methods

- `download_doc(doc_id, clean=True, output_path=None, parse_frontmatter=True)` - Download and process a Google Doc
- `download_doc_raw(doc_id)` - Get unprocessed markdown
- `download_doc_clean(doc_id, output_path=None)` - Get fully cleaned markdown
- `download_docs_batch(doc_ids, clean=True, output_folder=None, use_document_names=True)` - Batch download
- `clean_markdown(content, clean_escapes=True, remove_images=True, strip_heading_bold=True)` - Apply cleaning

### SVG Methods

- `process_svg_folder(folder_id, skip_unchanged=True)` - Process all SVGs in a folder
- `download_svg(file_id, destination_path)` - Download a single SVG
- `list_svg_files(folder_id)` - List SVG files in a folder
- `convert_svg_to_pdf(svg_path, pdf_path)` - Convert SVG to PDF using Inkscape

### Unified Processing

- `process_drive_folder(folder_id, process_doc=True, process_figs=True, output_path=None)` - Process manuscript folder
- `process_docs(doc_ids, output_folder=None)` - Convenience method for batch docs
- `process_svgs(folder_id)` - Convenience method for SVG processing

### Utility Methods

- `get_metadata(file_id)` - Get metadata for any file
- `download_file(file_id, destination_path)` - Download any file from Drive
- `write_to_file(content, output_path)` - Write content to disk
- `sanitize_filename(filename)` - Clean filename for filesystem

### Static Cleaning Methods

- `clean_escape_characters(markdown_content)` - Remove escape characters
- `remove_embedded_images(markdown_content)` - Remove embedded images
- `strip_bold_from_headings(markdown_content)` - Remove bold from headings

## Directory Structure

The processor creates the following directory structure:

```
output/           # Base directory (configurable)
├── docs/        # Downloaded markdown documents
├── pdf/         # Converted PDF files from SVGs
└── digest/      # MD5 checksums for change detection
```

## Common Use Cases

### Academic Manuscript Processing

```python
# Process a complete manuscript project
processor = GoogleDriveProcessor(local_base_dir="manuscript_output")

# Process the main folder containing manuscript and figures
results = processor.process_drive_folder('manuscript-folder-id')

# The processor will:
# 1. Find and download the manuscript document
# 2. Clean and save it as markdown
# 3. Find the 'figs' subfolder
# 4. Convert all SVG figures to PDFs
# 5. Track changes to avoid reprocessing unchanged files
```

### Collaborative Document Workflows

```python
# Set up for team collaboration
processor = GoogleDriveProcessor(
    credentials_path='/secure/team-credentials.json',
    local_base_dir='team_documents'
)

# Process shared documents
shared_docs = [
    'proposal-doc-id',
    'report-doc-id',
    'presentation-notes-id'
]

results = processor.process_docs(
    shared_docs,
    output_folder='team_documents/latest'
)
```

## Using Google Docs as Markmeld Target Sources

### Overview

Markmeld supports using Google Docs directly as content sources through special target configuration. This allows you to:
- Author content in Google Docs collaboratively
- Build documents without manual exports
- Automatically handle figures from Google Drive folders
- Cache content locally for fast rebuilds

### Configuration in `_markmeld.yaml`

To use a Google Doc as a target source, set the `type` field to `google-doc`:

```yaml
targets:
  my_manuscript:
    type: google-doc  # This tells markmeld to fetch from Google Drive
    jinja_template: template.jinja
    output_file: manuscript.pdf
    data:
      google_docs:
        doc_id: "YOUR_GOOGLE_DOC_ID_HERE"
        folder_id: "YOUR_FOLDER_ID_HERE"  # Optional: defaults to doc's parent folder
```

#### Field Options

The `google_docs` section supports these fields:
- `doc_id` or `manuscript`: The Google Doc ID (from the document URL)
- `folder_id`: Optional folder ID containing figures (SVGs, CSVs, etc.). If omitted, automatically uses the document's parent folder

Example with alternative field name:
```yaml
data:
  google_docs:
    manuscript: "1234567890abcdef"  # Can use 'manuscript' instead of 'doc_id'
    folder_id: "0987654321fedcba"
```

### Environment Setup

Set your Google Drive credentials using the environment variable:

```bash
# Option 1: Path to credentials file
export MM_GOOGLE_DRIVE_CREDENTIALS="/path/to/service-account-key.json"

# Option 2: JSON content directly
export MM_GOOGLE_DRIVE_CREDENTIALS='{"type": "service_account", ...}'
```

### Getting IDs from Google Drive

1. **Document ID**: 
   - Open your Google Doc
   - Find the ID in the URL: `https://docs.google.com/document/d/YOUR_DOC_ID_HERE/edit`

2. **Folder ID** (for figures):
   - Open the Google Drive folder
   - Find the ID in the URL: `https://drive.google.com/drive/folders/YOUR_FOLDER_ID_HERE`

### Building Google Doc Targets

Once configured, build your target normally:

```bash
# Build the target
mm my_manuscript

# Force refresh from Google Drive (bypass cache)
mm my_manuscript --force-refresh

# Clear cache before building
mm my_manuscript --clear-cache

# Check cache status
mm my_manuscript --cache-status
```

### Processing Pipeline

When you build a Google Doc target, markmeld:

1. **Downloads the Google Doc** as markdown (with automatic cleaning)
2. **Processes figures** from the folder (specified or auto-detected):
   - Uses the specified `folder_id` if provided
   - Otherwise, automatically uses the document's parent folder
   - Converts SVG files to PDF
   - Downloads CSV and other data files
   - Updates figure paths in the document
3. **Caches everything** locally for fast rebuilds
4. **Continues normally** as if the content was local

### Cache Management

Cached content is stored in `.cache/` relative to your `_markmeld.yaml`:

```
.cache/
└── {doc_id}/
    ├── docs/          # Cached markdown documents
    ├── converted/     # Converted figures (SVG→PDF)
    └── csv/           # Downloaded CSV files
```

Cache behavior:
- Documents are cached after first download
- Subsequent builds use cached version unless `--force-refresh` is used
- SVG→PDF conversion is cached based on file checksums
- Clear cache with `--clear-cache` flag or delete `.cache/` directory

### Complete Example

Here's a full example `_markmeld.yaml` for a manuscript project:

```yaml
targets:
  # Basic manuscript from Google Doc
  manuscript:
    type: google-doc
    jinja_template: manuscript_template.jinja
    output_file: "{today}_manuscript.pdf"
    data:
      google_docs:
        doc_id: "1a2b3c4d5e6f7g8h9i0j"
      variables:
        author: "Your Name"
        title: "My Research Paper"
    pandoc_args:
      - "--pdf-engine=xelatex"
      - "--citeproc"
  
  # Manuscript with auto-detected figures (from doc's parent folder)
  manuscript_auto_figures:
    type: google-doc
    jinja_template: manuscript_template.jinja
    output_file: "manuscript_with_figures.pdf"
    data:
      google_docs:
        doc_id: "1a2b3c4d5e6f7g8h9i0j"
        # No folder_id - uses document's parent folder automatically
      variables:
        figure_path: ".cache/{doc_id}/converted/"
  
  # Manuscript with explicit figures folder (different from parent)
  manuscript_custom_figures:
    type: google-doc
    jinja_template: manuscript_template.jinja
    output_file: "manuscript_custom.pdf"
    data:
      google_docs:
        doc_id: "1a2b3c4d5e6f7g8h9i0j"
        folder_id: "9i8h7g6f5e4d3c2b1a0"  # Explicit folder (e.g., shared figures folder)
  
  # Using 'manuscript' field instead of 'doc_id'
  research_paper:
    type: google-doc
    jinja_template: paper_template.jinja
    output_file: "research_paper.pdf"
    data:
      google_docs:
        manuscript: "1a2b3c4d5e6f7g8h9i0j"
```

### Jinja Template Considerations

When using Google Doc sources, the document content is available as `content` in your Jinja template:

```jinja
# {{ title }}

**Author:** {{ author }}

{{ content }}

## References
```

If you have frontmatter in your Google Doc (YAML between `---` markers), it's automatically parsed and made available as variables.

### Advantages of Google Doc Targets

1. **Collaborative Editing**: Multiple authors can work simultaneously in Google Docs
2. **Version Control**: Google Docs provides automatic version history
3. **Cloud-native**: No need to manually download/export documents
4. **Automatic Updates**: Changes in Google Docs are reflected in next build
5. **Figure Management**: Automatically handles figures from Drive folders
6. **Smart Caching**: Fast rebuilds with intelligent cache management

### Troubleshooting

Common issues and solutions:

1. **Authentication Errors**:
   - Verify service account has access to the document
   - Check credentials environment variable is set correctly
   - Share document with service account email

2. **Missing Figures**:
   - If using auto-detection, ensure figures are in the same folder as the document
   - If specifying folder_id, ensure it's correct
   - Verify service account has access to the folder
   - Check figure paths in the document match actual filenames

3. **Cache Issues**:
   - Use `--force-refresh` to bypass cache
   - Delete `.cache/` directory for complete refresh
   - Check cache status with `--cache-status` flag

4. **Document Not Found**:
   - Verify doc_id is correct (from document URL)
   - Ensure document is shared with service account
   - Check for typos in configuration

### Integration with CI/CD

For automated builds in CI/CD pipelines:

```yaml
# GitHub Actions example
steps:
  - name: Set Google Credentials
    run: echo "${{ secrets.GOOGLE_CREDENTIALS }}" > credentials.json
  
  - name: Build manuscript
    env:
      MM_GOOGLE_DRIVE_CREDENTIALS: ./credentials.json
    run: |
      mm manuscript --force-refresh
```

### Advanced Configuration

You can combine Google Doc targets with other markmeld features:

```yaml
targets:
  # Loop target for multiple documents
  batch_reports:
    type: google-doc
    loop:
      - doc_id: "doc1_id"
        name: "Report 1"
      - doc_id: "doc2_id"
        name: "Report 2"
    jinja_template: report_template.jinja
    output_file: "{name}_report.pdf"
    data:
      google_docs:
        doc_id: "{doc_id}"
  
  # Target with prebuild/postbuild
  manuscript_with_bib:
    type: google-doc
    prebuild:
      - update_bibliography
    data:
      google_docs:
        doc_id: "manuscript_id"
    postbuild:
      - extract_references
```

## License

MIT