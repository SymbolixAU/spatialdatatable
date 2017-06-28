

.spatialdatatable <- function(dt){
	setattr(dt, "class", c("spatialdatatable", class(dt)))
	return(dt)
}

# sets 'polyline' attribute on the polyline column
.encode.polyline <- function(x){
	attributes(x[["polyline"]]) <- list(spdt_polyline = "polyline")
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
	## TODO:
	## handle printing a subset of columns
	# spdt_melbourne[, .(polygonId, polyline)]

	## update-by-reference (:=) is just printing, not updating

	poly_column <- spdt_polyline_col(x)

	# print(paste0("print polyline column: ", poly_column) )

	poly_column <- poly_column[ poly_column %in% names(x) ]

	if( length(poly_column) > 0 ){

		# print("truncating characters")
		x <- x[,  lapply(.SD, function(y) {
			paste0(substr(y, 1, pmin(20, nchar(y))), "...")
		} )
		, by = setdiff(names(x), poly_column)
		, .SDcols = poly_column]

		# x[, (poly_column) := lapply(poly_column, function(y) {
		# 	paste0(substr(get(y), 1, pmin(20, nchar(get(y)))), "...")
		# } ) ]

		# for(col in poly_column)
		# 	set(x, j = col, value = paste0(substr(dt[[col]], 1, 5), "..."))
			# x[, col := paste0(substr(dt[[col]], 1, pmin(20, nchar(dt[[col]]))), "...")]


	}
	NextMethod()
}


#' @export
`[.spatialdatatable` <- function(x, ...){

	## need to keep the polyline attribute if it exists
	# print("subsetting")
	# poly_column <- attr(x, "spdt_polyline")
	# poly_column <- spdt_polyline_col(x)
	# print(paste0("subset polyline column: ", poly_column) )
	NextMethod()
	# print("finsished subestting")
}
#'
#'
#
# as.test <- function(x) {
# 	class(x) <- c('test', class(x))
# 	attr(x, "test_col") <- "y"
# 	attr(x[["y"]], "test_col_") <- "the column"
# 	x
# }
#
# print.test <- function(x) {
# 	testCol <- names(x)[names(x) %in% attr(x, "test_col")]
# 	print( paste0("testCol: ", testCol))
# 	if(!is.null(testCol)){
# 		x[['y']] <- "more tests"
# 	}
# 	NextMethod()
# }
#
# find.test.col <- function(x) UseMethod("find_test_col")
#
# find_test_col.test <- function(x){
# 	names(x)[names(x) %in% attr(x, "test_col")]
# }
#
# a <- data.table(x = 1:5, y = 1:5)
# b <- as.test(a)
#
# b
# str(b)
# b[1:2, ]
# str(b[1:2, ])


dt <- data.table(id = c(1,2),
								 polyline = c("fajlfadlksflkdasjfladsfjldsafjldsa", "adfjkladsjfldsajfkldsaflkajds"),
								 polyline2 = c("jflkadsjflkdasjfladsjflkadjsfkl", "fadsfdas"))


poly_col <- c("polyline", "polyline2")

pols <- sapply(poly_col, function(y){
	paste0( substr(dt[[y]], 1, pmin(20, nchar(dt[[y]]) ) ), "...")
})

pols

dt[, lapply(.SD, function(y) {
		paste0(substr(y, 1, pmin(20, nchar(y))), "...")
	} ),
	by = setdiff(names(dt), poly_col)
	, .SDcols = poly_col
	]



