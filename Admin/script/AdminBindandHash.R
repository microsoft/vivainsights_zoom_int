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
# Check if files in `input` contain string "combinedwpa_" -----------------

input_files <- list.files("../input")

if(
  any(
      grepl(pattern = "combinedzoomparticipant_",
         x = input_files)
  )
  ){
    stop("There is already a file with name 'combinedzoomparticipant_' in the 'input' directory. ",
         "Please move or delete this file before proceeding.")
  }


# Output is assigned to `zoom_hashed` -------------------------------------

zoom_hashed <-
  bind_and_hash(
  path = "../input",
  pattern = "2021-04-05", # UPDATE AS APPROPRIATE
  hash_path = "../input/WpA Zoom Pilot mapping file.csv", # UPDATE AS APPROPRIATE
  match_only = FALSE
)

# Export Hashed Zoom File for Analyst -------------------------------------

path_zoom_hashed <- "../output/Hashed Zoom File from Zoom Admin.csv" # UPDATE AS APPROPRIATE

zoom_hashed %>%
  data.table::fwrite(
      path_zoom_hashed
  )

message(paste("Hashed Zoom file saved to", path_zoom_hashed))
message("Please send the hashed file to Workplace Analytics Analyst.")

# ZOOM ADMIN SENDS OUTPUT HASH FILE TO ANALYST

# Termination message ----------------------------------------------------

message("Run complete. ", stamp_time(start_t, unit = "mins"))
