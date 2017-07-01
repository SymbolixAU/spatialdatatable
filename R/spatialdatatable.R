
## TODO:
## setSpDT()  (like setDT())
## - also, setSpDT(x, polyline = "polyline_column") to define the polyline attribute

#' set spdt
#'
#' creates a spatialdatatable object
#'
#' @param x
#' @export
setSpDT <- function(x, polyline_column = NULL, ...){

	name = as.character(substitute(x))
	if(!is.data.table(x)) setDT(x, ...)

	if(!"spatialdatatable" %in% class(x)){
		data.table::setattr(x, "class", c("spatialdatatable", class(dt)))
	# 	assign(name, x, parent.frame(), inherits = TRUE)
	#
	}
	if(!is.null(polyline_column)){
		if(!polyline_column %in% names(x)){
			warning(paste0(polyline_column, " not found in ", name))
		}else{
			data.table::setattr(x[[polyline_column]], "spdt_polyline","polyline")
		}
	}
}



# sets 'spatialdatatable' attribute on the spatialdatatable
.spatialdatatable <- function(dt){
	data.table::setattr(dt, "class", c("spatialdatatable", class(dt)))
	return(dt)
}

# sets 'polyline' attribute on the polyline column
.encode.polyline <- function(x){
	data.table::setattr(x[["polyline"]], "spdt_polyline","polyline")
	return(.spatialdatatable(x))
}

#' Polylines
#'
#'
#' gets the encoded polyline(s) from a spatialdatatable object
#'
#' @param spdt spatialdatatable
#'
#' @export
polylines <- function(spdt) UseMethod("spdt_polyline")

#' @export
spdt_polyline.spatialdatatable <- function(spdt){

	## TODO:
	## return ALL columns if there are more than one containing a polyline

	poly_column <- polyline_column(spdt)

	if(length(poly_column) == 0){
		message("No encoded polyline available")
		return()
	}

	return(spdt[[attr(spdt[[poly_column]], "spdt_polyline")]])
}

#' @export
spdt_polyline.default <- function(spdt){
	return(NULL)
}

#' Polyline Column
#'
#' Gets the column(s) names of a spatialdatatable object containing encoded polylines
#'
#' @param spdt spatialdatatable object
#' @export
polyline_column <- function(spdt) UseMethod("spdt_polyline_col")

#' @export
spdt_polyline_col.spatialdatatable <- function(spdt){
	attributes = sapply(spdt, function(x) names(attributes(x)))
	names(which(attributes == "spdt_polyline"))
}

#' @export
spdt_polyline_col.default <- function(spdt){
	return(NULL)
}


#' @export
print.spatialdatatable <- function(x, ...){

	# options("spatialdatatable.datatable.print.nrows" = getOption("datatable.print.nrows"))
	# print(paste0("datatable print option: ", getOption("datatable.print.nrows")))
	## The data.table print method will only print a subset of rows, or 100, unless
	## you specify otherwise

	## what I want is to go through the 'print.data.table' method to get its formatting
	## then to format the final column...

	poly_column <- polyline_column(x)
	poly_column <- poly_column[ poly_column %in% names(x) ]


	if( length(poly_column) > 0 ){

		## truncate just the 'polyline' columns.
		## data.table has the option 'datatable.prettyprint.char' that may overwrite this

		x <- x[,  lapply(.SD, function(y) {
			paste0(substr(y, 1, pmin(20, nchar(y))), "...")
		} )
		, by = setdiff(names(x), poly_column)
		, .SDcols = poly_column]

		### using 'set' modifies the object
		# for(col in poly_column)
		#  	set(x, j = col, value = paste0(strtrim(x[[col]], 20), "..."))
		#   x[, col := paste0(substr(dt[[col]], 1, pmin(20, nchar(dt[[col]]))), "...")]


	}
	NextMethod()
	## reset data.table print options
	options("datatable.print.nrows" = getOption("spatialdatatable.datatable.print.nrows"))
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



