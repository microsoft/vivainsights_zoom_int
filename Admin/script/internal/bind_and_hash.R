#' @title
#' Read in csv files with the same column structure, row-bind, and hash
#'
#' @description
#' csv files with a matched pattern in the file name in the given file
#' path are read in, and a row-bind operation is run to combine them. Pattern
#' matching is optional, and the user can choose whether to return a combined
#' data frame or save the output with the same name in the directory.
#'
#' The combined data is merged with a hash file.
#'
#'
#' @param path String containing the file path to the csv files.
#' @param pattern String containing pattern to match in the file name. Optional
#' and defaults to `NULL` (all csv files in path will be read in).
#' @param hash_file string containing the path to the .csv file containing the
#' hash IDs. The file should contain only two columns with the following
#' headers:
#'   - `PersonID`: column containing email addresses that map to the Zoom
#'   `User_Name` columns.
#'   - `HashID`: column containing HashIDs which will be uploaded as
#'   organizational attributes to Workplace Analytics.
#' @param match_only logical. Determines whether to include only rows where
#' there is a corresponding match on the hash file. Defaults to `FALSE`.
#'
#' @return
#' When `save_csv` is set to `FALSE`, a data frame is returned. When set to
#' `TRUE`, a csv file containing the combined data frame is saved in the same
#' folder as the provided path.
#'
#' @section How to Run:
#' ```
#' # Read files in and save output to path
#' bind_csv(
#'   path = "data",
#'   pattern = "2021-04-05",
#'   save_csv = TRUE
#' )
#'
#' # Read files in and return data frame
#' bind_csv(
#'   path = "data"
#' )
#' ```
#'
#' @export
bind_and_hash <- function(path,
                          pattern = NULL,
                          hash_path,
                          match_only = FALSE){

  start_t <- Sys.time()

  # Read in hash file upfront -----------------------------------------------

  hash_dt <- data.table::fread(hash_path, encoding = "UTF-8")

  # List all files in path --------------------------------------------------

  file_str <- list.files(path = path)

  # List csv file in path ---------------------------------------------------
  csv_str <- file_str[grepl(pattern = "\\.csv$",
                            x = file_str,
                            ignore.case = TRUE)]

  # Match all files with pattern --------------------------------------------
  if(is.null(pattern)){

    csv_match_str <- csv_str # No pattern matching

  } else {

    csv_match_str <- csv_str[grepl(pattern = pattern,
                                   x = csv_str,
                                   ignore.case = FALSE)]

  }

  # Append file path --------------------------------------------------------

  csv_match_str <- paste0(path, "/", csv_match_str)

  # Read all csv files in ---------------------------------------------------
  # Run `clean_zoom()` on each file

  readin_list <-
    seq(1, length(csv_match_str)) %>%
    purrr::map(
      function(i){

        message(
          paste0("Reading in ", i,
                 " out of ", length(csv_match_str),
                 " data files..."))

        clean_zoom(
          suppressMessages(
            suppressWarnings(
              readr::read_csv(file = csv_match_str[[i]])
            )
          )
        )
      })

  # Column name cleaning ----------------------------------------------------

  zoom_dt <- data.table::as.data.table(dplyr::bind_rows(readin_list))

  # Drop unnecessary columns ------------------------------------------------

  zoom_dt[, User_Name := NULL]
  # zoom_dt[, X13 := NULL]
  # zoom_dt[, Display_name := NULL]
  # zoom_dt[, Phone_numberName_Original_Name := NULL]

  # Standardize cases prior to replacement ----------------------------------

  hash_dt[, PersonID := str_trim(tolower(PersonID))]
  zoom_dt[, User_Email_1 := str_trim(tolower(User_Email_1))]
  zoom_dt[, User_Email_2 := str_trim(tolower(User_Email_2))]

  # Replace `User_Email_1` --------------------------------------------------
  setkey(zoom_dt, "User_Email_1")
  setkey(hash_dt, "PersonID")

  zoom_dt <- hash_dt[zoom_dt]

  zoom_dt[, User_Email_1 := HashID]
  zoom_dt[, HashID := NULL] # Drop `HashID`

  # Replace `User_Email_2` --------------------------------------------------
  setkey(zoom_dt, "User_Email_2")
  zoom_dt <- hash_dt[zoom_dt]

  zoom_dt[, User_Email_2 := HashID]
  zoom_dt[, HashID := NULL] # Drop `HashID`

  # Drop unnecessary columns ------------------------------------------------

  zoom_dt[, PersonID := NULL]
  zoom_dt[, i.PersonID := NULL]

  # Print timestamp ---------------------------------------------------------
  message(
    paste("Total runtime for `bind_and_hash()`: ",
          round(difftime(Sys.time(), start_t, units = "mins"), 1),
          "minutes.")
  )

  message(
    paste("Total number of rows in output data: ",
          nrow(zoom_dt))
  )

  message(
    paste("Total number of columns in output data: ",
          ncol(zoom_dt))
  )

  message(
    paste("Total number of users in output data: ",
          zoom_dt %>%
          dplyr::pull(User_Email_1) %>%
          dplyr::n_distinct())
  )

  # Remove non-matches ------------------------------------------------------

  if(match_only == TRUE){

    zoom_dt %>%
      .[!is.na(User_Email_1)] %>%
      .[!is.na(User_Email_2)]

  } else {

    zoom_dt[]

  }

}
