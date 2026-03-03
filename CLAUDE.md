# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project purpose

Convert the Sisters of Perpetual Indulgence, Abbey of St. Joan's Handbook and Bylaws from a static PDF into maintainable RMarkdown source files. Outputs are Word (.docx) and PDF. No RStudio — all commands run from the terminal via `Rscript`.

## Key commands

**First-time setup** (installs packages and syncs renv lockfile):
```bash
Rscript -e 'source("init.R")'
```

**Render all documents** to `output/`:
```bash
Rscript render.R
```

**Render a single document to a specific format:**
```bash
Rscript -e 'rmarkdown::render("src/bylaws.rmd", output_format = "word_document", output_dir = "output")'
```

**Bootstrap `styles/reference.docx`** (required once before first render; `output_file` path is relative to the input file's directory, hence `../styles/`):
```bash
Rscript -e 'rmarkdown::render("src/handbook.rmd", output_format = rmarkdown::word_document(), output_file = "../styles/reference.docx")'
```

**Run tests:**
```bash
Rscript -e 'testthat::test_file("tests/test-bylaws-numbering.R")'
```

## Architecture

### Document pipeline

```
src/handbook.rmd  ─────────────────────────────► output/handbook.{docx,pdf}
src/bylaws.rmd  ──► filters/bylaws-numbering.lua ► output/bylaws.{docx,pdf}
                          ▲
                   styles/reference.docx (Word styles template)
```

Both `.rmd` files have dual YAML output blocks (`word_document` + `pdf_document`). `render.R` calls `rmarkdown::render(..., output_format = "all")` on each.

### Auto-numbering (bylaws only)

`filters/bylaws-numbering.lua` is a pandoc Lua filter that injects "Article N:", "Section N:", "Subsection A:" prefixes at render time. The `.rmd` source contains **only descriptive titles** — no static numbers. Counter resets:

- `##` (Article) → increments; resets Section and Subsection counters
- `###` (Section) → increments per Article; resets Subsection counter
- `####` (Subsection) → alphabetic (A, B, C…), resets per Section

The filter is registered in `src/bylaws.rmd`'s YAML via `pandoc_args: ["--lua-filter=../filters/bylaws-numbering.lua"]`. The handbook does **not** use this filter.

### Word style template

`styles/reference.docx` controls all heading and body styles in `.docx` output. It must exist before rendering. Edit built-in Word styles (Heading 1–4, Normal, Title) inside the file — do not change its content. Re-render to pick up style changes.

### renv

Packages are managed with `renv`. After installing new packages, run `renv::snapshot()` to update `renv.lock`. Use `renv::install()` rather than `install.packages()` so renv tracks the dependency.

## Editing content

`src/handbook.rmd` and `src/bylaws.rmd` are plain Markdown with a YAML header. Paths in YAML (e.g., `reference_docx`, `--lua-filter`) are relative to the **input file's directory** (`src/`), not the working directory — hence `../styles/` and `../filters/`.
