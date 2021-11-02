context("Check path replacement 1 - indicator")

# This is a short indicator test. To fully test the functionality, the
# test_replace_path_local.R needs to be sourced interactively.

test_that("Check path reformatting",{
  # Check it works for here()
  expect_equal(split_path("here(\"inst/rstudio/addins.dcf\")"),
               "here(\"inst\", \"rstudio\", \"addins.dcf\")")

  # Check it works for file.path()
  expect_equal(split_path("file.path(\"inst/rstudio/addins.dcf\")"),
               "file.path(\"inst\", \"rstudio\", \"addins.dcf\")")

  # Check it works for random user-defined function (e.g. "test")
  expect_equal(
    split_path(
      "test(\"inst/rstudio/addins.dcf\") file.path(\"inst/rstudio/addins.dcf\")",
      fns = "test"
    ),
    "test(\"inst\", \"rstudio\", \"addins.dcf\") file.path(\"inst/rstudio/addins.dcf\")"
  )

  # Check it doesn't replace arbitrary parenthesized file paths
  expect_equal(split_path("(\"inst/rstudio/addins.dcf\")"),
               "(\"inst/rstudio/addins.dcf\")")

  # Check it works with here namespace
  expect_equal(split_path("here::here(inst/rstudio/addins.dcf)"),
               "here::here(inst\", \"rstudio\", \"addins.dcf)")

  # Check trailing slash is replaced properly
  expect_equal(split_path("here::here(\"inst/rstudio/addins/\")"),
               "here::here(\"inst\", \"rstudio\", \"addins\")")

  # Check regex is sufficiently specific
  expect_equal(split_path("here::here(\"inst/rstudio/addins\") read.csv(\"test/test2.csv\")"),
               "here::here(\"inst\", \"rstudio\", \"addins\") read.csv(\"test/test2.csv\")")

  expect_equal(split_path("read.csv(\"test/test2.csv\")here::here(\"inst/rstudio/addins\")"),
               "read.csv(\"test/test2.csv\")here::here(\"inst\", \"rstudio\", \"addins\")")
})
