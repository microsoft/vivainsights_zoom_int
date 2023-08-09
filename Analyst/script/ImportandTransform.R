  # Timestamp --------------------------------------------------------------
start_t <- Sys.time()

# Define packages that will be necessary for execution -------------------
packages <- c(
	"wpa",
  "vivainsights",
	"tidyverse",
  "data.table",
  "hms",
  "lutz"
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

source("internal/import_zoom.R")
source("internal/split_hm.R")
source("internal/zoom_to_afterhours.R")
source("internal/zoom_to_pq.R")
source("internal/stamp_time.R")

# Load config.csv --------------------------------------------------------

config_df <- suppressMessages(readr::read_csv("../config.csv"))

par_utc_offset <- config_df$value[config_df$key == "utc_offset"]
par_utc_offset <- stringr::str_trim(par_utc_offset)
hash_id <- config_df$value[config_df$key == "hash_id"]
hash_id <- stringr::str_trim(hash_id)

# Timezone offset -------------------------------------------------------

if(length(par_utc_offset) == 0){ # is of length 0

  # Calculate from system time
  use_utc_offset <-
    tz_offset(dt = Sys.Date(),
              tz = Sys.timezone()) %>%
    pull(utc_offset_h) %>%
    hms::hms(hours = .) %>%
    substr(start = 1, stop = 5)

  tz_desc <-
    tz_offset(dt = Sys.Date(),
              tz = Sys.timezone()) %>%
    pull(tz_name)

  message("...")
  message("Note! All times reported in Zoom files are based on Zoom Admin timezone")
  message("If you are based in a different timezone from the Zoom Admin, please update the config.csv")
  message("key=utc_offset, value = relevant UTC offset for the timezone. Save the file and rerun")
  message("...")
  message("If you are in the same timezone as Zoom Admin, no action needed")
  message("...")
  message("Continuing with execution..")

  message(
    glue::glue("System timezone {tz_desc} detected.")
  )

  message(
    glue::glue("Using system UTC timezone offset of {use_utc_offset}")
  )


  message("...")

} else {

  # Use provided UTC offset
  use_utc_offset <- par_utc_offset

  message(
    paste(
      "Using user-defined UTC timezone offset of ",
      use_utc_offset
    )
  )

}



#### ANALYST --------------------------------------------------------------
# Read Zoom file ----------------------------------------------------------
path_zoom <- list.files("../input/") %>%
  .[grepl(pattern = "Hashed Zoom File from Zoom Admin",
          x = .,
          ignore.case = TRUE)]

if(length(path_zoom) == 0){

  stop("Hashed zoom output not found.")

} else {

  full_path_zoom <- paste0("../input/", path_zoom)
  message("Loading in ", path_zoom, "... ", stamp_time(start_t, unit = "secs"))
  zoom_for_analyst <- import_zoom(full_path_zoom)
  message("Successfully loaded ", path_zoom, "...", stamp_time(start_t, unit = "secs"))

}

# Read Standard Meeting Query ---------------------------------------------
path_smq <- list.files("../input/") %>%
  .[grepl(pattern = "Standard meeting query",
          x = .,
          ignore.case = TRUE)]

if(length(path_smq) == 0){

  stop("Standard Meeting Query not found.")

} else {

  full_path_smq <- paste0("../input/", path_smq)
  message("Loading in ", path_smq, "...", stamp_time(start_t, unit = "secs"))
  smq <- data.table::fread(full_path_smq, encoding = "UTF-8")
  message("Successfully loaded ", path_smq, "...", stamp_time(start_t, unit = "secs"))

}

# Read in WOWA Query ------------------------------------------------------
path_wowa <- list.files("../input/") %>%
  .[grepl(pattern = "Ways of working assessment|WOWA",
          x = .,
          ignore.case = TRUE)]

if(length(path_wowa) == 0){

  stop("Ways of Working Assessment query not found.")

} else {

  full_path_wowa <- paste0("../input/", path_wowa)
  message("Loading in ", path_wowa, "...", stamp_time(start_t, unit = "secs"))
  wowa_df <- vivainsights::import_query(full_path_wowa)
  names(wowa_df)[names(wowa_df) == hash_id] <- 'HashID'
  message("Successfully loaded ", path_wowa, "...", stamp_time(start_t, unit = "secs"))

}

# Convert to Person Query -------------------------------------------------

# A list object is returned
zoom_output_list <-
  zoom_for_analyst %>%
  zoom_to_pq(mq_key = unique(smq$Subject),
             wowa_file = wowa_df,
             utc_offset = use_utc_offset, # UPDATE AS APPROPRIATE
             return = "list")

# The analyst can choose to export `zoom_output` or analyze directly
# `zoom_output` is a WOWA format person-query data frame
# You can run the following code chunk to:
#   - standardise dates
#   - create dummy after hours metric

message("Exporting Person Query ...", stamp_time(start_t, unit = "secs"))

zoom_output_list$full %>%
  write_csv(
    paste("../output/Zoom Transformed Person Query Export", # UPDATE AS APPROPRIATE
          tstamp(),
          ".csv"),
    na = ""
  )

# Save Zoom metrics separately

message("Exporting Zoom Metrics ...", stamp_time(start_t, unit = "secs"))

zoom_output_list$`zoom-metrics` %>%
  write_csv(
    paste("../output/Standalone Zoom Metrics Export", # UPDATE AS APPROPRIATE
          tstamp(),
          ".csv"),
    na = ""
  )

# Save Standard Meeting Query copy in output folder
smq %>%
  write_csv(
    paste("../output/Standard Meeting Query_", # UPDATE AS APPROPRIATE
          tstamp(),
          ".csv"),
    na = ""
  )

# Termination message ----------------------------------------------------

message("Run complete ", path_zoom, ". ", stamp_time(start_t, unit = "mins"))
