library(rmarkdown)

# Render both documents to both Word and PDF formats.
# Output files are written to output/

render("src/handbook.rmd", output_format = "all", output_dir = "output")
render("src/bylaws.rmd",   output_format = "all", output_dir = "output")
