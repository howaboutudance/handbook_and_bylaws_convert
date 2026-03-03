# styles/

Place `reference.docx` here. This file controls Word heading and body styles for all `.docx` output.

## Generating the initial template

This must be done **once before** running `render.R`. The command below renders
the handbook using Word's built-in defaults (bypassing the missing
`reference.docx`) to produce the template file itself:

```bash
Rscript -e 'rmarkdown::render("src/handbook.rmd", output_format = rmarkdown::word_document(), output_file = "../styles/reference.docx")'
```

Two things to note:

- `output_format = rmarkdown::word_document()` (the function, not the string `"word_document"`) bypasses the YAML `reference_docx` setting, avoiding the circular dependency
- `output_file = "../styles/reference.docx"` uses `..` because rmarkdown resolves relative paths from the **input file's directory** (`src/`), not the working directory

## Customizing styles

1. Open `reference.docx` in Microsoft Word
2. Modify the built-in styles (Heading 1–4, Normal, Title, Subtitle) — change font, size, color, spacing as desired
3. Do **not** change or add content in the document body
4. Save and close — re-render the `.rmd` files to pick up the new styles
