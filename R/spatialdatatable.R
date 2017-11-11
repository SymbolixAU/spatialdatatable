
## TODO:
## setSDT()  (like setDT())
## - also, setSDT(x, polyline = "polyline_column") to define the polyline attribute
##
## test that setSDT works inside functions, and HOW it works!?
## print sdt_melbourne with more than one attribute on the polyline column
##
## - merging a spatialdatatable with a datatable - which attributes does it keep?
##
## - encode argument (logical) to specify if a line/polygon should be encoded
## - need to ensure latlon projection?
##
## - keep BBOX and other info

#' Set SDT
#'
#' creates a spatial.data.table object
#'
#' @param x
#' @export
setSDT <- function(x, polyline_column = NULL, ...){

	name = as.character(substitute(x))
	if(!is.data.table(x)) setDT(x, ...)

	if(!"spatial.data.table" %in% class(x)){
		data.table::setattr(x, "class", c("spatial.data.table", class(dt)))
	# 	assign(name, x, parent.frame(), inherits = TRUE)
	#
	}
	if(!is.null(polyline_column)){
		if(!polyline_column %in% names(x)){
			warning(paste0(polyline_column, " not found in ", name))
		}else{
			data.table::setattr(x[[polyline_column]], "sdt_polyline","polyline")
		}
	}
}



# sets 'spatial.data.table' attribute on the spatial.data.table
.spatial.data.table <- function(dt){
	data.table::setattr(dt, "class", c("spatial.data.table", class(dt)))
	return(dt)
}

# sets 'polyline' attribute on the polyline column
.encode.polyline <- function(x){
	data.table::setattr(x[["polyline"]], "sdt_polyline","polyline")
	return(.spatial.data.table(x))
}

# .reset.class <- function(sdt){
# 	if(!"spatial.data.table" %in% attr(sdt, 'class'))
# 		return(.spatial.data.table(sdt))
# }

#' Polylines
#'
#'
#' gets the encoded polyline(s) from a spatial.data.table object
#'
#' @param sdt spatial.data.table object
#'
#' @export
polylines <- function(sdt) UseMethod("sdt_polyline")

#' @export
sdt_polyline.spatial.data.table <- function(sdt){

	## TODO:
	## return ALL columns if there are more than one containing a polyline

	poly_column <- polyline_column(sdt)

	if(length(poly_column) == 0){
		message("No encoded polyline available")
		return()
	}

	return(sdt[[attr(sdt[[poly_column]], "sdt_polyline")]])
}

#' @export
sdt_polyline.default <- function(sdt){
	return(NULL)
}

#' Polyline Column
#'
#' Gets the column(s) names of a spatial.data.table object containing encoded polylines
#'
#' @param sdt spatial.data.table object
#' @export
polyline_column <- function(sdt) UseMethod("sdt_polyline_col")

#' @export
sdt_polyline_col.spatial.data.table <- function(sdt){
	# ats = sapply(sdt, function(x) names(attributes(x)))
	# names(which(ats == "sdt_polyline"))
	names(which(sapply(sdt, function(x) sum(names(attributes(x)) %in% 'sdt_polyline') ) > 0))

}

#' @export
sdt_polyline_col.default <- function(sdt){
	return(NULL)
}


# #' @export
# print.spatial.data.table <- function(x, ...){
#
# 	# options("spatialdatatable.datatable.print.nrows" = getOption("datatable.print.nrows"))
# 	# print(paste0("datatable print option: ", getOption("datatable.print.nrows")))
# 	## The data.table print method will only print a subset of rows, or 100, unless
# 	## you specify otherwise
#
# 	## what I want is to go through the 'print.data.table' method to get its formatting
# 	## then to format the final column...
#
# 	poly_column <- polyline_column(x)
# 	poly_column <- poly_column[ poly_column %in% names(x) ]
#
#
# 	if( length(poly_column) > 0 ){
#
# 		## truncate just the 'polyline' columns.
# 		## data.table has the option 'datatable.prettyprint.char' that may overwrite this
#
# 		x <- x[,  lapply(.SD, function(y) {
# 			paste0(substr(y, 1, pmin(20, nchar(y))), "...")
# 		} )
# 		, by = setdiff(names(x), poly_column)
# 		, .SDcols = poly_column]
#
# 		### using 'set' modifies the object
# 		# for(col in poly_column)
# 		#  	set(x, j = col, value = paste0(strtrim(x[[col]], 20), "..."))
# 		#   x[, col := paste0(substr(dt[[col]], 1, pmin(20, nchar(dt[[col]]))), "...")]
#
#
# 	}
# 	NextMethod()
# 	## reset data.table print options
# 	options("datatable.print.nrows" = getOption("spatialdatatable.datatable.print.nrows"))
# }


# #' @export
# `[.spatial.data.table` <- function(x, ...){
#
# 	## need to keep the polyline attribute if it exists
#
# 	## detect for ':=' in 'j', and if it exists, we don't want to print
#
# 	args <- as.list(substitute(list(...)))
# 	args <- lapply(args, function(y) { grepl(":=", y) })
# 	args <- sapply(args, sum)
# 	if(sum(args) > 0){
# 		options("datatable.print.nrows" = -1L)
# 	}
# 	NextMethod()
# }



