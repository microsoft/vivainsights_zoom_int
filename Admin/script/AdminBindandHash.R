# Timestamp --------------------------------------------------------------
start_t <- Sys.time()

# Define packages that will be necessary for execution ------------------
packages <- c(
	"dplyr",
  "purrr",
  "readr",
  "stringr",
  "data.table",
	"logr"
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

# Initiate log -----------------------------------------------------------
# Create log file location
# tmp <- file.path(tempdir(), paste0(start_t, ".log"))
tmp <- file.path(tempdir(), "log.log")

# Open log
lf <- log_open(tmp)

# Load functions ---------------------------------------------------------

source("internal/bind_and_hash.R")
source("internal/import_zoom.R")
source("internal/stamp_time.R")

#### ZOOM ADMIN -----------------------------------------------------------

logr::log_print("Listing files from Zoom...", console = FALSE)

# Read in file names from `../input/zoom_reports`
input_files <- list.files("../input/zoom_reports")

# Match csv files only
input_files <- input_files[grepl(pattern = "csv$",
                                 x = input_files,
                                 ignore.case = TRUE)]

logr::log_print(input_files, console = FALSE)

# Read mapping file -------------------------------------------------------

logr::log_print("Reading in mapping file...", console = FALSE)

path_map <- list.files("../input/") %>%
  .[grepl(pattern = "mapping file",
          x = .,
          ignore.case = TRUE)]

if(length(path_map) == 0){

  stop("Mapping file not found.")

} else {

  full_path_map <- paste0("../input/", path_map)
}

logr::log_print(full_path_map, console = FALSE)

# Output is assigned to `zoom_hashed` -------------------------------------

zoom_hashed <-
  bind_and_hash(
  path = "../input/zoom_reports",
  pattern = NULL, # UPDATE AS APPROPRIATE
  hash_path = full_path_map,
  match_only = FALSE
)

# Export Hashed Zoom File for Analyst -------------------------------------

path_zoom_hashed <- "../output/Hashed Zoom File from Zoom Admin.csv" # UPDATE AS APPROPRIATE

zoom_hashed %>%
  data.table::fwrite(
      path_zoom_hashed
  )

# message(paste("Hashed Zoom file saved to", path_zoom_hashed))
logr::log_print(paste("Hashed Zoom file saved to", path_zoom_hashed), console = TRUE)

message("Please send the hashed file to Workplace Analytics Analyst.")

# ZOOM ADMIN SENDS OUTPUT HASH FILE TO ANALYST

# Termination message ----------------------------------------------------

message("Run complete. ", stamp_time(start_t, unit = "mins"))

# Print log --------------------------------------------------------------

writeLines(text = readLines(lf), "../output/log.log")
