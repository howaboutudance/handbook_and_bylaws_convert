# One-time setup: install required packages for document rendering.
# Run this script once, then use render.R to produce output.

renv::install(c("rmarkdown", "knitr"))
renv::snapshot()

# For PDF output, also install TinyTeX (a minimal LaTeX distribution):
# renv::install("tinytex")
# tinytex::install_tinytex()
