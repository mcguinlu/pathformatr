context("Check path replacement - full (local only)")

## Can only be run interactively!
## Spacer line

#  -- Scratch Space -- #
# here::here("inst/rstudio/test.csv")
# here::here("inst\rstudio\test.csv")
# here::here("inst","rstudio","test.csv")
# file.path("inst/rstudio/test.csv")
# file.path("inst\rstudio\test.csv")
# file.path("inst","rstudio","test.csv")
#  -- Scratch Space -- #

test_that("various APIs for interacting with an RStudio document work", {
  # Skip unless interactive
  skip_if(rstudioapi::isAvailable("0.99.796")==FALSE,
              message = "RStudio available is not available.")

  # Get details on document and save copy of file for later comparison
  context <- rstudioapi::getActiveDocumentContext()
  path <- context$path
  before <- readLines(path)

# CHECK HERE cleaning -----

  # Check forward slashes can be handled
  ranges_forward_here <- c(7,1,7,Inf)

  rstudioapi::setSelectionRanges(ranges_forward_here)

  format_path()

  # Check backward slashes can be handled
  ranges_backward_here <- c(8,1,8,Inf)

  rstudioapi::setSelectionRanges(ranges_backward_here)

  format_path()

  ctx <- rstudioapi::getActiveDocumentContext()
  after <- ctx$contents

  # Check reformatted paths agree with sample path (before[9])
  expect_equal(before[9], after[7])
  expect_equal(before[9], after[8])

  # Reset the test paths in the scratch space
  rstudioapi::insertText(ranges_forward_here,
                         paste0("# here::here","(\"inst/rstudio/test.csv\")"))
  rstudioapi::insertText(ranges_backward_here,
                         paste0("# here::here","(\"inst\\rstudio\\test.csv\")"))


# CHECK FILE.PATH cleaning -----

  # Check forward slashes can be handled
  ranges_forward_fp <- c(10,1,10,Inf)

  rstudioapi::setSelectionRanges(ranges_forward_fp)

  format_path()

  # Check backward slashes can be handled
  ranges_backward_fp <- c(11,1,11,Inf)

  rstudioapi::setSelectionRanges(ranges_backward_fp)

  format_path()

  ctx <- rstudioapi::getActiveDocumentContext()
  after <- ctx$contents

  # Check reformatted paths agree with sample path (before[9])
  expect_equal(before[12], after[10])
  expect_equal(before[12], after[11])

  # Reset the test paths in the scratch space
  rstudioapi::insertText(ranges_forward_fp,
                         paste0("# file.path","(\"inst/rstudio/test.csv\")"))
  rstudioapi::insertText(ranges_backward_fp,
                         paste0("# file.path","(\"inst\\rstudio\\test.csv\")"))

  #### - here_clean_all()

  # Clean all calls in the document
  format_all_paths()

  ctx <- rstudioapi::getActiveDocumentContext()
  after <- ctx$contents

  # Check reformatted paths agree with sample path (before[9])
  expect_equal(before[9], after[7])
  expect_equal(before[9], after[8])
  expect_equal(before[12], after[10])
  expect_equal(before[12], after[11])

  # Reset the test paths in the scratch space
  rstudioapi::insertText(ranges_forward_here,
                         paste0("# here::here","(\"inst/rstudio/test.csv\")"))
  rstudioapi::insertText(ranges_backward_here,
                         paste0("# here::here","(\"inst\\rstudio\\test.csv\")"))
  rstudioapi::insertText(ranges_forward_fp,
                         paste0("# file.path","(\"inst/rstudio/test.csv\")"))
  rstudioapi::insertText(ranges_backward_fp,
                         paste0("# file.path","(\"inst\\rstudio\\test.csv\")"))


  # Confirm length of document is the same to make sure no new lines were
  # accidentally added
  ctx <- rstudioapi::getActiveDocumentContext()
  after <- ctx$contents

  # 'readLines' will not include a final newline,
  # so accommodate that
  expect_identical(before, after[-length(after)])

})
