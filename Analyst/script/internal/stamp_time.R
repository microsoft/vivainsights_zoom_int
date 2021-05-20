stamp_time <- function(start_t, unit = "mins"){
  paste0(
    "(",
    round(difftime(Sys.time(), start_t, units = unit), 1), " ",
    unit, ")"
  )
}
