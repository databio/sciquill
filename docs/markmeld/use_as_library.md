# Using markmeld as a library

While markmeld is primarily designed as a command-line tool, it can also be used as a Python library for programmatic document generation. This is particularly useful when you need to:

- Generate documents dynamically from application data
- Integrate markmeld into larger Python applications
- Build documents without creating intermediate files
- Programmatically create and modify configurations

## Basic usage

The core class for library usage is `MarkdownMelder`. Here's a simple example:

```python
import yaml
from markmeld import MarkdownMelder, load_config_file

# Load configuration from a file
cfg = load_config_file("_markmeld.yaml")

# Create a MarkdownMelder instance
mm = MarkdownMelder(cfg)

# Build a target (render only, don't run command)
result = mm.build_target("my_target", print_only=True)

# Access the rendered output
print(result.melded_output)
```

## Direct content input (no files needed)

Starting with version 0.5.0, markmeld supports providing content directly without creating files on disk. This is achieved through two new configuration keys: `md_content` and `yaml_content`.

### Example: Markdown content from strings

```python
import yaml
from markmeld import MarkdownMelder

# Create configuration programmatically
config = {
    "_cfg_file_path": "/tmp/temp.yaml",  # Required for path resolution
    "targets": {
        "letter": {
            "_workpath": "/tmp",  # Required working directory
            "_defpath": "/tmp",   # Required definition path
            "data": {
                "md_content": {
                    "body": "Dear {{name}},\n\nThank you for your purchase of {{product}}.\n\nBest regards,\nThe Team"
                },
                "yaml_content": {
                    "customer": {
                        "name": "John Doe",
                        "product": "Premium Widget"
                    }
                }
            },
            "jinja_template": "letter_template.jinja",
            "command": None  # Just render, don't execute
        }
    }
}

# Create melder and build
mm = MarkdownMelder(config)
result = mm.build_target("letter", print_only=True)
print(result.melded_output)
```

### Example: Markdown with frontmatter

You can provide markdown content with frontmatter metadata:

```python
from markmeld import MarkdownMelder

config = {
    "_cfg_file_path": "/tmp/temp.yaml",
    "targets": {
        "blog_post": {
            "_workpath": "/tmp",
            "_defpath": "/tmp",
            "data": {
                "md_content": {
                    "post": {
                        "content": "# My Blog Post\n\nThis is the content.",
                        "frontmatter": {
                            "title": "Amazing Post",
                            "author": "Jane Smith",
                            "date": "2024-01-15",
                            "tags": ["python", "documentation"]
                        }
                    }
                }
            },
            "jinja_template": "blog_template.jinja",
            "command": None
        }
    }
}

mm = MarkdownMelder(config)
result = mm.build_target("blog_post", print_only=True)

# Frontmatter is available in _global_frontmatter
print(result.melded_input['_global_frontmatter']['dict']['title'])  # "Amazing Post"
```

### Example: Using python-frontmatter objects

If you're already working with the `python-frontmatter` library, you can pass Post objects directly:

```python
import frontmatter
from markmeld import MarkdownMelder

# Create a frontmatter Post object
post = frontmatter.Post("# Document Title\n\nDocument content here.")
post.metadata = {
    "author": "John Doe",
    "version": "1.0",
    "date": "2024-01-01"
}

config = {
    "_cfg_file_path": "/tmp/temp.yaml",
    "targets": {
        "document": {
            "_workpath": "/tmp",
            "_defpath": "/tmp",
            "data": {
                "md_content": {
                    "doc": post  # Pass the Post object directly
                }
            },
            "jinja_template": "doc_template.jinja",
            "command": None
        }
    }
}

mm = MarkdownMelder(config)
result = mm.build_target("document", print_only=True)
```

## Programmatic configuration building

You can build configurations programmatically for dynamic document generation:

```python
from markmeld import MarkdownMelder
import json

def generate_report(data_dict, template_path):
    """Generate a report from a data dictionary"""
    
    config = {
        "_cfg_file_path": "dynamic_config.yaml",
        "targets": {
            "report": {
                "_workpath": ".",
                "_defpath": ".",
                "data": {
                    "yaml_content": {
                        "report_data": data_dict
                    },
                    "md_content": {
                        "summary": f"# Report for {data_dict.get('client_name', 'Unknown')}\n\nGenerated on {data_dict.get('date', 'today')}"
                    }
                },
                "jinja_template": template_path,
                "command": "pandoc --output report.pdf"
            }
        }
    }
    
    mm = MarkdownMelder(config)
    return mm.build_target("report")

# Use the function
report_data = {
    "client_name": "Acme Corp",
    "date": "2024-01-15",
    "metrics": {
        "revenue": 1000000,
        "growth": "15%"
    }
}

result = generate_report(report_data, "templates/report.jinja")
```

## Combining file and content sources

You can mix file-based and content-based data sources:

```python
config = {
    "_cfg_file_path": "config.yaml",
    "targets": {
        "combined": {
            "_workpath": ".",
            "_defpath": ".",
            "data": {
                # From files
                "md_files": {
                    "header": "templates/header.md",
                    "footer": "templates/footer.md"
                },
                "yaml_files": {
                    "config": "config/settings.yaml"
                },
                # From memory
                "md_content": {
                    "dynamic_section": generated_markdown_content
                },
                "yaml_content": {
                    "runtime_data": {
                        "timestamp": datetime.now().isoformat(),
                        "user": os.getenv("USER")
                    }
                }
            },
            "jinja_template": "combined_template.jinja",
            "command": None
        }
    }
}
```

## Working with melded output

The `build_target` method returns a Target object with useful attributes:

```python
result = mm.build_target("my_target", print_only=True)

# Access the rendered output
print(result.melded_output)

# Access the input data that was passed to the template
print(result.melded_input.keys())

# Check the return code (0 for success)
print(result.returncode)

# Access target metadata
print(result.meta)
```

## Using with loops

You can use markmeld's loop functionality programmatically:

```python
config = {
    "_cfg_file_path": "config.yaml",
    "targets": {
        "mail_merge": {
            "_workpath": ".",
            "_defpath": ".",
            "loop": {
                "loop_data": "recipients",
                "assign_to": "recipient"
            },
            "data": {
                "yaml_content": {
                    "recipients": [
                        {"name": "Alice", "email": "alice@example.com"},
                        {"name": "Bob", "email": "bob@example.com"},
                        {"name": "Charlie", "email": "charlie@example.com"}
                    ]
                },
                "md_content": {
                    "template": "Dear {{recipient.name}},\n\nYour email is {{recipient.email}}."
                }
            },
            "jinja_template": "email.jinja",
            "output_file": "emails/{{recipient.name}}.txt",
            "command": None
        }
    }
}

mm = MarkdownMelder(config)
results = mm.build_target("mail_merge", print_only=True)

# Results will be a dict with one entry per loop iteration
for idx, result in results.items():
    print(f"Email {idx}: {result.melded_output}")
```
