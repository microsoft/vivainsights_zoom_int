# Timestamp --------------------------------------------------------------
start_t <- Sys.time()

# Define packages that will be necessary for execution ------------------
packages <- c(
  "dplyr",
  "purrr",
  "readr",
  "stringr",
  "data.table"
  )

# Now load or install & load all -----------------------------------------

for(x in packages){

  mtry <- try(find.package(package = x))

  if (inherits(mtry, "try-error")) {
      install.packages(
        pkgs = x,
        dependencies = TRUE,
        repos = 'http://cran.us.r-project.org')
    }

	suppressPackageStartupMessages(
    suppressMessages(
      library(x, character.only = TRUE)
      )
    )

}

# Load functions ---------------------------------------------------------

source("internal/bind_and_hash.R")
source("internal/import_zoom.R")
source("internal/stamp_time.R")

#### ZOOM ADMIN -----------------------------------------------------------

# Read in file names from `../input/zoom_reports`
input_files <- list.files("../input/zoom_reports")

# Read mapping file -------------------------------------------------------

path_map <- list.files("../input/") %>%
  .[grepl(pattern = "mapping file",
          x = .,
          ignore.case = TRUE)]

if(length(path_map) == 0){

  stop("Mapping file not found.")

} else {

  full_path_map <- paste0("../input/", path_map)
}

# Output is assigned to `zoom_hashed` -------------------------------------

zoom_hashed <-
  bind_and_hash(
  path = "../input/zoom_reports",
  pattern = NULL, # UPDATE AS APPROPRIATE
  hash_path = full_path_map,
  match_only = FALSE
)

# Export Hashed Zoom File for Analyst -------------------------------------

path_zoom_hashed <- paste0(
  "../output/Hashed Zoom File from Zoom Admin_", # UPDATE AS APPROPRIATE
  wpa::tstamp(),
  ".csv"
)

zoom_hashed %>%
  data.table::fwrite(
      path_zoom_hashed
  )

message(paste("Hashed Zoom file saved to", path_zoom_hashed))
message("Please send the hashed file to Viva Insights Analyst.")

# ZOOM ADMIN SENDS OUTPUT HASH FILE TO ANALYST

# Termination message ----------------------------------------------------

message("Run complete. ", stamp_time(start_t, unit = "mins"))
