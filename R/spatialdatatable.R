

.spatialdatatable <- function(dt){
	data.table::setattr(dt, "class", c("spatialdatatable", class(dt)))
	return(dt)
}

# sets 'polyline' attribute on the polyline column
.encode.polyline <- function(x){
	data.table::setattr(x[["polyline"]], "spdt_polyline","polyline")
	#attributes(x[["polyline"]]) <- list(spdt_polyline = "polyline")
	return(.spatialdatatable(x))
}


# gets the encoded polyline from the spdt
#' @export
spdt_polyline <- function(spdt) UseMethod("spdt_polyline")

#' @export
spdt_polyline.spatialdatatable <- function(spdt){
	spdt[[attr(spdt, "spdt_polyline")]]
}

#' @export
spdt_polyline.default <- function(obj){
	return(NULL)
}

#' @export
spdt_polyline_col <- function(spdt) UseMethod("spdt_polyline_col")

#' @export
spdt_polyline_col.spatialdatatable <- function(spdt){
	# names(spdt)[names(spdt) %in% attr(spdt, "spdt_polyline")]
	# names(spdt)[which(sapply(spdt, function(x) !is.null(attributes(x))))]
	attributes = sapply(spdt, function(x) names(attributes(x)))
	names(which(attributes == "spdt_polyline"))
}

#' @export
spdt_polyline_col.default <- function(spdt){
	return(NULL)
}


#' @export
print.spatialdatatable <- function(x, ...){


	## The data.table print method will only print a subset of rows, or 100, unless
	## you specify otherwise

	## what I want is to go through the 'print.data.table' method to get its formatting
	## then to format the final column...

	poly_column <- spdt_polyline_col(x)
	poly_column <- poly_column[ poly_column %in% names(x) ]


	if( length(poly_column) > 0 ){

		## truncate just the 'polyline' columns.
		## data.table has the option 'datatable.prettyprint.char' that may overwrite this

		x <- x[,  lapply(.SD, function(y) {
			paste0(substr(y, 1, pmin(20, nchar(y))), "...")
		} )
		, by = setdiff(names(x), poly_column)
		, .SDcols = poly_column]

		# for(col in poly_column)
		#  	set(x, j = col, value = paste0(strtrim(x[[col]], 20), "..."))
		#   x[, col := paste0(substr(dt[[col]], 1, pmin(20, nchar(dt[[col]]))), "...")]


	}
	NextMethod()
	## reset data.table print options
	options("datatable.print.nrows" = 100L)
}


#' @export
`[.spatialdatatable` <- function(x, ...){

	## need to keep the polyline attribute if it exists

	## detect for ':=' in 'j', and if it exists, we don't want to print

	args <- as.list(substitute(list(...)))
	args <- lapply(args, function(y) { grepl(":=", y) })
	args <- sapply(args, sum)
	if(sum(args) > 0){
		options("datatable.print.nrows" = -1L)
	}

	NextMethod()
}



