context("Check path replacement 1 - indicator")

# This is a short indicator test. To fully test the functionality, the
# test_replace_path_local.R needs to be sourced interactively.

test_that("Check path reformatting",{
  expect_equal(split_path("inst/rstudio/addins.dcf"),
               "inst\",\"rstudio\",\"addins.dcf")
})
