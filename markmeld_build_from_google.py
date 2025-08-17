import sys
sys.path.insert(0, './markmeld')  # to get the local one for development work (skip in production)

# Turn on debug logging (optional)
# import logging
# logging.basicConfig(
#     level=logging.DEBUG,
#     format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
# )

# Start production code here

import os
from markmeld import GoogleDriveProcessor, MarkdownMelder

# Initialize the Google Drive processor
gdp = GoogleDriveProcessor()

seqcol_figs = "1zzXQaZpC2AH27pmln0nO3uLvgesgHJPV"
seqcol_root = "19DLQyPWq7cJ7dMduXxNVhy1GL-XqTE4t"
seqcol_doc = "1sp2IhaHsemelA8IaCBwPhZ_uEdN7XGyWQWPdL5w7ckU"
atacformer_doc = "1qS4X0NZHJjzl_oNXJJMOSFu84UalalqZhUGMhwlyOhQ"

manuscript_doc_id = seqcol_doc
# manuscript_doc_id = atacformer  # Uncomment to use the ATAC-Former manuscript

ms_cfg = {
    "doc_id": manuscript_doc_id,
    "output_path": "output/seqcol.pdf"
}

# Download just the doc as frontmatter.Post object
doc = gdp.download_doc(doc_id=manuscript_doc_id, parse_frontmatter=True)

# Process the figs folder
list_svg_files = gdp.list_svg_files(seqcol_figs)
list_svg_files
build_pdfs = gdp.process_svgs(seqcol_figs)

# But it's better if you give it the *root folder*, and then it will discover the other stuff.

results = gdp.process_drive_folder(
    folder_id=seqcol_root
)

# Configure markmeld via dictionary using in-memory content
markmeld_config = {
    "_cfg_file_path": os.getcwd() + "/temp_config.yaml",  # Required for path resolution
    "targets": {
        "manuscript_pdf": {
            "_workpath": os.getcwd(),
            "_defpath": os.getcwd(),
            "output_file": ms_cfg["output_path"],
            "data": {
                "md_content": {
                    "content": doc  # Pass the frontmatter.Post object
                },
                "yaml_content": {
                    "metadata": {
                        "title": doc.metadata.get('title', 'Google Doc Export'),
                        "author": doc.metadata.get('author', 'Generated from Google Docs'),
                        "date": doc.metadata.get('date', '\\today')
                    }
                }
            },
            "jinja_template": None,
            "bibdb": "/home/nsheff/code/papers/sheffield.bib",
            "csl": "{sciquill}/csl/biomed-central_ns.csl",
            "latex_template": "/home/nsheff/code/sciquill/tex_templates/shefflab.tex",
            "sciquill": "/home/nsheff/code/sciquill/",
            "figczar": "/home/nsheff/code/sciquill/pandoc_filters/figczar/figczar.lua",
            "change_marker": "/home/nsheff/code/sciquill/pandoc_filters/change_marker/change_marker.lua",
            "multi_refs": "/home/nsheff/code/sciquill/pandoc_filters/multi-refs/multi-refs.lua",
            "command": """    pandoc \
                                --template {latex_template} \
                                --bibliography {bibdb} \
                                --csl {csl} \
                                --lua-filter {figczar} \
                                --lua-filter {change_marker} \
                                --citeproc \
                                --lua-filter  {multi_refs} \
                                -o {output_file}"""
        }
    }
}

# Initialize MarkdownMelder with cfg
melder = MarkdownMelder(markmeld_config)

# Build PDF directly from memory
pdf_result = melder.build_target("manuscript_pdf")



