# SPI-ASJ Handbook & Bylaws

Editable RMarkdown source for the Sisters of Perpetual Indulgence, Abbey of St. Joan's Handbook and Bylaws. Renders to Word (.docx) or PDF from the terminal — no RStudio required.

## Quick start

**First time only** — install packages and generate the Word style template:

```bash
Rscript -e 'renv::install(c("rmarkdown", "knitr")); renv::snapshot()'
Rscript -e 'rmarkdown::render("src/handbook.rmd", output_format = rmarkdown::word_document(), output_file = "../styles/reference.docx")'
```

**Render all documents:**

```bash
Rscript render.R
```

Output files are written to `output/`.

## Editing

Open `src/handbook.rmd` or `src/bylaws.rmd` in any text editor. The files are plain Markdown with a short YAML header — no R knowledge needed.

## Outputs

| Document | Word | PDF |
| --- | --- | --- |
| Handbook | `output/handbook.docx` | `output/handbook.pdf` |
| Bylaws | `output/bylaws.docx` | `output/bylaws.pdf` |

## Word styles

`styles/reference.docx` controls heading and body styles in all `.docx` output. To restyle: open it in Word, edit the built-in styles (Heading 1–4, Normal, Title), save, and re-render. Do not change the document content.

## Dependencies

- R 4.5+
- `rmarkdown`, `knitr` (installed via `init.R`)
- For PDF output: TinyTeX — `tinytex::install_tinytex()`

See [Manifest.md](Manifest.md) for full project documentation.
