#' Format the highlighted file path to use individual quoted and comma-separated
#' elements
#'
#' @description This function formats a file path highlighted in the source pane
#'   to work with here::here() or file.path() by separating the string into its
#'   component parts and quoting and comma-separating these elements. For best
#'   use, we recommend using this functionality via the associated AddIn, or by
#'   binding the AddIn to a keyboard shortcut, rather than calling the function
#'   interactively from the console.
#'
#' @param fns Defines the functions to target for cleaning. Default is to clean
#'   the file paths of both here() and file.path(), but one or the other can be
#'   specified if running the command interactively (i.e. not via the AddIn).
#'
#' @return Updated path as recommended by here::here(), split into individual
#'   quoted and comma-separated segments.
#'
#' @export
format_path <- function(fns = c("here","file.path")) {

  context <- rstudioapi::getSourceEditorContext()

  # Get information
  info <- get_info(context)

  # Reformat the text
  path_text <- split_path(info[["text"]], fns)

  # Update highlighted code
  rstudioapi::modifyRange(info[["range"]], path_text, info[["id"]])
}

#' Formats the file paths of all target function calls in the active document
#' using format_path()
#'
#' @description As an alternative to formatting paths one at a a time, this
#'   function allows all file paths in the active document to be formatted at
#'   once. By default, all here() and file.path() calls are targeted, but these
#'   can be removed and other user-defined targets added. The function outputs
#'   some information on the file being formatted and number of times each
#'   target function call was found.
#'
#' @param fns Target function calls to format. Defaults are "here" and
#'   "file.path"
#' @param message Logical, specifying whether or not to print information about
#'   the cleaning process (file being formatted and number of times each target
#'   function call was found) to the console
#'
#' @export

format_all_paths <- function(fns = c("here","file.path"), message = TRUE){

  # Get and store current cursor
  info <- get_info(context = rstudioapi::getSourceEditorContext())

  user_range <- info$range

  # Select the entirety of the active document
  ranges_forward <- c(1,1,Inf,Inf)

  rstudioapi::setSelectionRanges(ranges_forward, info[["id"]])

  info <- get_info(context = rstudioapi::getSourceEditorContext())

  # Post message to console with details of the
  if (message == TRUE) {
    message("Cleaning ",
            ifelse(info[["path"]] == "",
                   "\"Untitled document\"",
                   info[["path"]]),
            ":")

    for (func in fns) {
      message("|- ",
              stringr::str_count(info[["path_text"]],
                                 paste0(func, "\\(.+?\\)")),
              " ",
              func,
              "() calls.")
    }

  }


  # Reformat paths
  format_path(fns)

  # Set cursor position back to what it was
  rstudioapi::setCursorPosition(user_range, info[["id"]])
}


#' Get information on the highlighted path from the editor
#'
#' @param context Context of the text
#'
#' @keywords internal

get_info <- function(context) {

  info <- list(range = rstudioapi::primary_selection(context)[["range"]],
               text = rstudioapi::primary_selection(context)[["text"]],
               path = context[["path"]],
               id = context[["id"]])

  return(info)
}

#' Find and format paths
#'
#' @description  Find and extract paths, split them by slashes, quote and
#' comma-separate the result, and reinsert into text.
#'
#' @param text File path to reformat
#' @param fns Target function calls to clean. Defaults are "here" and
#'   "file.path"
#'
#' @keywords internal

split_path <- function(text, fns = c("here","file.path")){

  for (fn in fns) {

    # Create function to clean
    get_clean_any <- function(match, func = fn) {
      match %>%
        stringr::str_extract_all(paste0(func,"\\(.+?\\)")) %>%
        unlist() %>%
        # Replace forward slashes
        stringr::str_replace_all("/", "\",\"") %>%
        # Replace back slashes
        stringr::str_replace_all("\\\\", "\",\"") %>%
        # Replace empty commas ("") created by leading or trailing slashes
        stringr::str_replace_all(",\"\"","")
    }

    text <-
      stringr::str_replace_all(text,
                               paste0(fn, "\\(.+?\\)"),
                               get_clean_any)
  }

  return(text)
}
