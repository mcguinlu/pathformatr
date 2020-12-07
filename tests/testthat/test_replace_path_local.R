context("Check path replacement - full (local only)")

## The tests contained in this file 'pass' if, after sourcing
## in RStudio, the contents don't change. :) Can only be run interactively!

#  -- Scratch Space -- #
# here::here("inst/rstudio/test.csv")
# here::here("inst\rstudio\test.csv")
# here::here("inst","rstudio","test.csv")
#  -- Scratch Space -- #

test_that("Add-in works", {
  # Skip unless interactive
  skip_if(rstudioapi::isAvailable("0.99.796")==FALSE,
              message = "RStudio available is not available.")

  # Get details on document and save copy of file for later comparison
  context <- rstudioapi::getActiveDocumentContext()
  path <- context$path
  before <- readLines(path)

  # Check forward slashes can be handled
  ranges_forward <- c(7,1,7,Inf)

  rstudioapi::setSelectionRanges(ranges_forward)

  here_clean_path()

  # Check backward slashes can be handled
  ranges_backward <- c(8,1,8,Inf)

  rstudioapi::setSelectionRanges(ranges_backward)

  here_clean_path()

  ctx <- rstudioapi::getActiveDocumentContext()
  after <- ctx$contents

  # Check reformatted paths agree with sample path (before[9])
  expect_equal(before[9], after[7])
  expect_equal(before[9], after[8])

  # Reset the test paths in the scratch space
  rstudioapi::insertText(ranges_forward,
                         "# here::here(\"inst/rstudio/test.csv\")")
  rstudioapi::insertText(ranges_backward,
                         "# here::here(\"inst\\rstudio\\test.csv\")")

  # Confirm length of document is the same to make sure no new lines were
  # accidentally added
  ctx <- rstudioapi::getActiveDocumentContext()
  after <- ctx$contents

  # 'readLines' will not include a final newline,
  # so accommodate that
  expect_identical(before, after[-length(after)])

})
