

#' @export
print.spatialdatatable <- function(x, ...){
	# cat("spatialdatatable")

	## TODO:
	## handle printing a subset of columns
	# spdt_melbourne[, .(polygonId, polyline)]

	## replace the polyine with just 20 chars
	pl <- spdt_polyline_col(x)
	if(!is.null(pl)){
		x[[pl]] <- paste0(substr(x[[pl]], 1, pmin(20, nchar(x[[pl]]) ) ), "...")
	}

	NextMethod()
}

