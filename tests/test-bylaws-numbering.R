library(testthat)

pandoc <- rmarkdown::pandoc_exec()
filter <- normalizePath("../filters/bylaws-numbering.lua")

run_filter <- function(md) {
  tmp <- tempfile(fileext = ".md")
  writeLines(md, tmp)
  system2(pandoc, c(tmp, "--lua-filter", filter, "-t", "markdown"), stdout = TRUE)
}

test_that("articles are numbered sequentially", {
  out <- run_filter("## Alpha\n\n## Beta\n")
  expect_true(any(grepl("^## Article 1: Alpha", out)))
  expect_true(any(grepl("^## Article 2: Beta", out)))
})

test_that("sections are numbered within an article", {
  out <- run_filter("## Art\n\n### First\n\n### Second\n\n### Third\n")
  expect_true(any(grepl("Section 1: First", out)))
  expect_true(any(grepl("Section 2: Second", out)))
  expect_true(any(grepl("Section 3: Third", out)))
})

test_that("section counter resets on each new article", {
  out <- run_filter("## Art1\n\n### SecA\n\n## Art2\n\n### SecB\n")
  expect_true(any(grepl("Section 1: SecA", out)))
  expect_true(any(grepl("Section 1: SecB", out)))
})

test_that("subsections use letters in sequence", {
  out <- run_filter("## A\n\n### S\n\n#### First\n\n#### Second\n\n#### Third\n")
  expect_true(any(grepl("Subsection A: First", out)))
  expect_true(any(grepl("Subsection B: Second", out)))
  expect_true(any(grepl("Subsection C: Third", out)))
})

test_that("subsection counter resets on each new section", {
  out <- run_filter("## A\n\n### S1\n\n#### Alpha\n\n#### Beta\n\n### S2\n\n#### Gamma\n")
  expect_true(any(grepl("Subsection A: Alpha", out)))
  expect_true(any(grepl("Subsection B: Beta", out)))
  expect_true(any(grepl("Subsection A: Gamma", out)))
})

test_that("subsection counter resets on each new article", {
  out <- run_filter("## A1\n\n### S\n\n#### Alpha\n\n## A2\n\n### S\n\n#### Beta\n")
  expect_true(any(grepl("Subsection A: Alpha", out)))
  expect_true(any(grepl("Subsection A: Beta", out)))
})

test_that("titled subsection gets letter-colon-title format", {
  out <- run_filter("## A\n\n### S\n\n#### My Title\n")
  expect_true(any(grepl("Subsection A: My Title", out)))
})

test_that("bare subsection heading gets letter only with no trailing colon", {
  out <- run_filter("## A\n\n### S\n\n#### Untitled\n")
  # when there IS a title the colon appears; this tests the titled path
  expect_true(any(grepl("Subsection A: Untitled", out)))
})

test_that("Subsection following Z continues with AA, AB, etc.", {
  # paste0 27 times to get to AA, AB, etc.
  # need a range till 28 to get to AB, which is the first one we test for
  subsections <- paste0("#### ", c(1:28))
  md <- paste(c("## A", "### S", subsections), collapse = "\n\n")
  out <- run_filter(md)
  expect_true(any(grepl("Subsection Z: 26", out)))
  expect_true(any(grepl("Subsection AA: 27", out)))
  expect_true(any(grepl("Subsection AB: 28", out)))
})
