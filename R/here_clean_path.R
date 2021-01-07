#' Correctly format the highlighted path to match here::here() guidelines
#'
#' @description This function formats a file path highlighted in the source pane
#'   to work with here::here() by separating the string into its component parts
#'   and quoting and comma-separating these elements. For best use, we recommend
#'   using this functionality via the associated AddIn, or by binding the AddIn
#'   to a keyboard shortcut, rather than calling the function interactively from
#'   the console.
#'
#' @param fns Defines the functions to target for cleaning. Default is to clean
#'   the file paths of both here() and file.path(), but one or the other can be
#'   specified.
#'
#' @return Updated path as recommended by here::here(), split into individual
#'   quoted and comma-separated segments.
#' @export
here_clean_path <- function(fns = c("here","file.path")) {

  context <- rstudioapi::getSourceEditorContext()

  # Get information
  info <- get_info(context)

  # Get code
  path_text <- split_path(info[["path_text"]], fns)

  # Update highlighted code
  rstudioapi::modifyRange(info[["range"]], path_text, info[["id"]])
}

#' Get information on the highlighted path from the editor
#'
#' @param context Context of the text
#'
#' @return Information about the highlighted text
get_info <- function(context) {

  id <- context[["id"]]

  path_text <- rstudioapi::primary_selection(context)[["text"]]

  range <- rstudioapi::primary_selection(context)[["range"]]

  path <-context[["path"]]

  info <- list(range = range, path_text = path_text, path = path, id = id)

  return(info)
}

#' Split path by slashes and quote and comma-separate result.
#'
#' @param text File path to reformat
#'
#' @return
split_path <- function(text, fns = c("here","file.path")){

  for (fun in fns) {

    get_clean_any <- function(match, func = fun) {
      match %>%
        stringr::str_extract_all(paste0(func,"\\(.+?\\)")) %>%
        unlist() %>%
        stringr::str_replace_all("/", "\",\"") %>%
        stringr::str_replace_all("\\\\", "\",\"") %>%
        stringr::str_replace_all(",\"\"","")
    }

    text <-
      stringr::str_replace_all(text,
                               paste0(fun, "\\(.+?\\)"),
                               get_clean_any)
  }

  return(text)
}


#' Clean paths in all here::here() and file.path() in the active document
#'
#' @param fns Function to
#' @param message Logical, specifying whether or not to print information about
#'   the cleaning process (file being cleaned and number of here() and
#'   file.path() calls)
#'
#' @export

here_clean_all <- function(fns = c("here","file.path"), message = TRUE){

  info <- get_info(context = rstudioapi::getSourceEditorContext())

  user_range <- info$range

  ranges_forward <- c(1,1,Inf,Inf)

  rstudioapi::setSelectionRanges(ranges_forward, info[["id"]])

  info <- get_info(context = rstudioapi::getSourceEditorContext())

  # Post message to
  if (message == TRUE) {

  message("Cleaning ", ifelse(info[["path"]] == "", "\"Untitled document\"", info[["path"]]),":")

  for (func in fns) {
    message("|- ",
            stringr::str_count(info[["path_text"]], paste0(func,"\\(.+?\\)")),
            " ",func,"() calls.")
  }

  }

  here_clean_path(fns)

  rstudioapi::setCursorPosition(user_range,info[["id"]])
}
