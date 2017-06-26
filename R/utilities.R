
#' Check For ID
#'
#' Checks the existence of an 'ID' column in the data. If it exits,
#' an 'ID.sdt' is appended
CheckForID <- function(x){

	if('ID' %in% x){
		## finds any columns with 'ID.sdt', and if exists,
		## creates a new column name with .x

	}

}

#' Find Lat Column
#'
#' Attempts to find the column of a data.frame containing the latitude values
find_lat_column = function(names, msg, stopOnFailure = TRUE) {

	lats = names[grep("^(lat|lats|latitude|latitudes)$", names, ignore.case = TRUE)]

	if (length(lats) == 1) {
		return(lats)
	}

	if (stopOnFailure) {
		stop(paste0("Couldn't infer latitude column for ", msg))
	}

	list(lat = NA)
}

#' Find Lon Column
#'
#' Attempts to find the column of a data.frame containing the longitude values
find_lon_column = function(names, msg, stopOnFailure = TRUE) {

	lons = names[grep("^(lon|lons|lng|lngs|long|longs|longitude|longitudes)$", names, ignore.case = TRUE)]

	if (length(lons) == 1) {
		return(lons)
	}

	if (stopOnFailure) {
		stop(paste0("Couldn't infer longitude columns for ", msg))
	}

	list(lon = NA)
}


check_for_columns <- function(df, cols, msg){

	## check to see if the specified columns exist
	if(!all(cols %in% names(df)))
		stop(paste0("Could not find columns: "
								, paste0(cols[!cols %in% names(df)], collapse = ", ")
								, " in ", msg))

}
