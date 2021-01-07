
<!-- README.md is generated from README.Rmd. Please edit that file -->

# herehelper

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/mcguinlu/herehelper/workflows/R-CMD-check/badge.svg)](https://github.com/mcguinlu/herehelper/actions)
<!-- badges: end -->

The purpose of `herehelper` is singular and simple - to allow you to use
the RStudio file path auto-complete functionality and then quickly
reformat your code to match here::here() guidelines.

``` r
here::here("data/2020/06/01/data.csv")
# or
here::here("data\2020\06\01\data.csv")

# becomes

here::here("data","2020","06","01","data.csv")
```

The function will now also clean `file.path()` calls, so :

``` r
file.path("data/2020/06/01/data.csv")

# becomes

file.path("data","2020","06","01","data.csv")
```

This functionality is designed to work via an RStudio addin - simply
highlight your file path, browse to the `herehelper` section in the
RStudio Addins drop-down menu, and select “Format path for use with
here::here()”.

Alternatively you can [bind the functionality to a keyboard
shortcut](https://support.rstudio.com/hc/en-us/articles/206382178-Customizing-Keyboard-Shortcuts)
(I personally like mapping it to `CRTL+/`).

## Installation

You can install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("mcguinlu/herehelper")
library(herehelper)
```

## Motivation

## To Do

  - Make a video demonstrating the functionality.
  - Add new function to format all here::here() calls in a document
