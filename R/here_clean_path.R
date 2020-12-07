#' Correctly format the highlighted path to match here::here() guidelines
#'
#' @description This function formats a file path highlighted in the source pane
#'   to work with here::here() by separating the string into its component
#'   parts and quoting and comma-separating these elements. For best use, we
#'   recommend using this functionality via the associated AddIn, or by binding
#'   the AddIn to a keyboard shortcut, rather than calling the function
#'   interactively from the console.
#'
#' @return Updated path as recommended by here::here(), split into individual
#'   quoted and comma-separated segments.
#' @export
here_clean_path <- function() {

  # Get information
  info <- get_info(context = rstudioapi::getSourceEditorContext())

  # Get code
  path_text <- split_path(info[["path_text"]])

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

  info <- list(range = range, path_text = path_text, id = id)

  return(info)
}

#' Split path by slashes and quote and comma-separate result.
#'
#' @param text File path to reformat
#'
#' @return
split_path <- function(text){

  # Replace forward-slash
  text <- stringr::str_replace_all(text,"/","\",\"")

  # Replace back-slash
  text <- stringr::str_replace_all(text,"\\\\","\",\"")

  text <- stringr::str_replace(text,",\"\"","")
  text <- stringr::str_replace(text,"\"\",","")

  return(text)
}
