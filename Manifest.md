# SPI-ASJ Handbook & Bylaws — Project Manifest

## Purpose

Convert the Sisters of Perpetual Indulgence, Abbey of St. Joan's Handbook and Bylaws from a static PDF into maintainable, editable RMarkdown source files. The Parliamentarian and committees can edit the source directly and re-render to Word (.docx) or PDF as needed.

## Output Documents

Two separate documents are produced from two separate source files:

| Document | Source | Word Output | PDF Output |
| --- | --- | --- | --- |
| Handbook | `src/handbook.rmd` | `output/handbook.docx` | `output/handbook.pdf` |
| Bylaws | `src/bylaws.rmd` | `output/bylaws.docx` | `output/bylaws.pdf` |

## File Structure

```text
handbook_and_bylaws_convert/
├── input/
│   └── src_bylaws.pdf          # original source PDF (read-only reference)
├── src/
│   ├── handbook.rmd            # Handbook source (edit this)
│   └── bylaws.rmd              # Bylaws source (edit this)
├── styles/
│   └── reference.docx          # Word style template (customize heading/body styles here)
├── output/                     # rendered files (do not edit directly)
│   ├── handbook.docx
│   ├── handbook.pdf
│   ├── bylaws.docx
│   └── bylaws.pdf
├── Manifest.md                 # this file
├── init.R                      # one-time package installation
├── render.R                    # renders all documents to all formats
├── renv.lock                   # locked package versions
└── .Rprofile                   # renv auto-loader
```

## Workflow

### First-time setup

```r
# Install required packages
source("init.R")
```

### Editing content

Edit `src/handbook.rmd` or `src/bylaws.rmd` directly. These are plain text Markdown files with an RMarkdown YAML header. No R coding knowledge is required — just Markdown formatting.

### Rendering

From the terminal:

```bash
Rscript render.R
```

Or to render a single document to a specific format:

```bash
Rscript -e 'rmarkdown::render("src/handbook.rmd", output_format = "word_document", output_dir = "output")'
Rscript -e 'rmarkdown::render("src/bylaws.rmd", output_format = "pdf_document", output_dir = "output")'
```

### Customizing Word styles

The file `styles/reference.docx` controls the heading and body styles used in all `.docx` output. To customize:

1. Open `styles/reference.docx` in Microsoft Word
2. Modify the built-in styles (Heading 1, Heading 2, Normal, etc.) — do **not** change the content
3. Save and re-render

## Dependencies

- R 4.5+
- `rmarkdown`
- `knitr`
- A LaTeX distribution for PDF output (e.g., TinyTeX: `tinytex::install_tinytex()`)

## Source Reference

`input/src_bylaws.pdf` is the original document. Do not edit it. The `.rmd` source files are the canonical editable versions going forward.
