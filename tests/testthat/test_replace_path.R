context("Check path replacement")

test_that("Check path reformatting",{
  expect_equal(split_path("inst/rstudio/addins.dcf"),
               "inst\",\"rstudio\",\"addins.dcf")
})
