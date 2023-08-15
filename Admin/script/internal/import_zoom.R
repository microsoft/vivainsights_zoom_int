import_zoom <- function(path, date_format = "%d/%m/%Y %H:%M"){

  dt <-
    suppressWarnings(
      data.table::fread(path, encoding = "UTF-8"),
      )

  # return_dt <- dt
  return_dt <- clean_zoom(dt)

  return_dt
}

clean_zoom <- function(x, date_format = "%d/%m/%Y %H:%M"){

  x %>%
    # Remove blanks -------------------------------------------------------
  dplyr::filter(
    !is.na(Topic),
    !is.na(`MeetingID`),
    !is.na(`User_Name`)
  ) %>%
    set_names(gsub(pattern = " ", replacement = "_", x = names(.))) %>%
    set_names(gsub(pattern = "[?]|\\(|\\)", replacement = "", x = names(.))) %>%
    set_names(gsub(pattern = "[...]", replacement = "", x = names(.))) %>%
#    dplyr::rename(
#     User_Email_2 = "User_Email_1",
#      User_Email_1 = "User_Email",
#      Duration_Minutes_2 = "Duration_Minutes_1",
#      Duration_Minutes_1 = "Duration_Minutes"
#    )  %>%
	
	# Remove blank participants --------------------------------------------
	# This represents unusable data
	# Participants is itself a column available in the data
	
	filter(!is.na(User_Email_2)) %>%

    # Enforce variable type ------------------------------------------------
	  mutate(
		across(
		  .cols =
			c(Join_Time,
			  Leave_Time,
			  Creation_Time,
			  Start_Time,
			  End_Time),
		  .fns = ~as.POSIXct(x = ., format = date_format, tz = "UTC")
		)
	  )
}
