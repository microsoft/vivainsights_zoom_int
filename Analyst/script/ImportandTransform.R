# Timestamp --------------------------------------------------------------
start_t <- Sys.time()

# Define packages that will be necessary for execution -------------------
packages <- c(
	"wpa",
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
  .[grepl(pattern = "Hashed Zoom File from Zoom Admin.csv",
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
  .[grepl(pattern = "Standard meeting query.csv",
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
  .[grepl(pattern = "Ways of working assessment query.csv",
          x = .,
          ignore.case = TRUE)]

if(length(path_wowa) == 0){

  stop("Ways of Working Assessment query not found.")

} else {

  full_path_wowa <- paste0("../input/", path_wowa)
  message("Loading in ", path_wowa, "...", stamp_time(start_t, unit = "secs"))
  wowa_df <- data.table::fread(full_path_wowa, encoding = "UTF-8")
  message("Successfully loaded ", path_wowa, "...", stamp_time(start_t, unit = "secs"))

}

# Convert to Person Query -------------------------------------------------
zoom_output <- zoom_for_analyst %>%
  zoom_to_pq(mq_key = unique(smq$Subject),
             wowa_file = wowa_df,
             utc_offset = "01:00", # UPDATE AS APPROPRIATE
             return = "full")

# The analyst can choose to export `zoom_output` or analyze directly
# `zoom_output` is a WOWA format person-query data frame
# You can run the following code chunk to:
#   - standardise dates
#   - create dummy after hours metric

zoom_output %>%
  mutate(Date = format(Date, "%m/%d/%Y")) %>%
  as_tibble() %>%
  write_csv(
    paste("../output/Zoom Transformed Person Query Export", # UPDATE AS APPROPRIATE
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
