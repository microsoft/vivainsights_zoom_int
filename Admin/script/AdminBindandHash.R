# Define packages that will be necessary for execution
packages <- c(
	"wpa",
	"tidyverse",
  "data.table"
  )

# Now load or install & load all
package.check <- lapply(
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE, repos='http://cran.us.r-project.org')      
    }
	suppressPackageStartupMessages(library(x, character.only = TRUE))
  }
)

source("../script/bind_csv.R")
source("../script/hash_zoom.R")
source("../script/import_zoom.R")

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

# Combine multiple CSV files from Zoom ------------------------------------
# Takes a few minutes, files are big
# Saves a file in the same source directory

bind_csv(
  path = "../input",
  pattern = "^2021-04-05", # UPDATE AS APPROPRIATE
  save_csv = TRUE
)

# Read in Combined Zoom and Hash File and Replace IDs ---------------------
# Check whether duplicates exist
input_files <- list.files("../input") # Refresh

matched_zoom <- input_files[grepl(pattern = "combinedzoomparticipant_", x = input_files)]

if(length(matched_zoom) > 1){
  stop("More than one file with name containing 'combinedzoomparticipant_' found in directory.")
}

# Output is assigned to `zoom_hashed`
zoom_hashed <-
  hash_zoom(
  zoom_path = paste0("../input/", matched_zoom), # UPDATE AS APPROPRIATE
  hash_path = "../input/WpA Zoom Pilot mapping file.csv", # UPDATE AS APPROPRIATE
  match_only = FALSE
)

# Export Hashed Zoom File for Analyst -------------------------------------

zoom_hashed %>%
  data.table::fwrite(
      "../output/Hashed Zoom File from Zoom Admin.csv" # UPDATE AS APPROPRIATE    
  )

# ZOOM ADMIN SENDS OUTPUT HASH FILE TO ANALYST