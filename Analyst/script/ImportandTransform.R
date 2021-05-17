# Define packages that will be necessary for execution
packages <- c(
	"wpa",
	"tidyverse",
  "data.table",
  "hms"
  )

# Now load or install & load all
package.check <- lapply(
  packages,
  FUN = function(x) {
    if (!require(x, character.only = TRUE)) {
      install.packages(x, dependencies = TRUE, repos='http://cran.us.r-project.org')
      library(x, character.only = TRUE)
    }
  }
)

source("internal/import_zoom.R")
source("internal/split_hm.R")
source("internal/zoom_to_afterhours.R")
source("internal/zoom_to_pq.R")


#### ANALYST --------------------------------------------------------------
# Read Zoom file
zoom_for_analyst <- import_zoom(
	"../input/Hashed Zoom File from Zoom Admin.csv", # UPDATE AS APPROPRIATE
)

# Read Standard Meeting Query
smq <- data.table::fread(  
	"../input/Standard meeting query Zoom Pilot.csv", # UPDATE AS APPROPRIATE
	encoding = "UTF-8"
)


# Read in WOWA Query
wowa_df <- data.table::fread(
    "../input/Ways of working assessment Zoom WpA pilot_withTimeZone.csv", # UPDATE AS APPROPRIATE
  encoding = "UTF-8"
)

# Convert to Person Query
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
    paste("../output/Zoom Transformed Person Query Export Diageo", # UPDATE AS APPROPRIATE
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