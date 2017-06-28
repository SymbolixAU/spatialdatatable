

#' @export
print.spatialdatatable <- function(x, ...){
	## TODO:
	## handle printing a subset of columns
	# spdt_melbourne[, .(polygonId, polyline)]

	poly_column <- attr(x, "spdt_polyline")
	if(!is.null(poly_column) ){
		if(poly_column %in% names(x)){
			x[[poly_column]] <- paste0(substr(x[[poly_column]], 1, pmin(20, nchar(x[[poly_column]] ) ) ), "...")
		}
	}
	NextMethod()
}

# poly_column <- "polyline"
# attr(spdt_melbourne, "spdt_polyline") <- poly_column
#
# attributes(spdt_melbourne$polyline) <- NULL
# str(spdt_melbourne)
#
# poly_col <- attr(spdt_melbourne, "spdt_polyline")

# as.test <- function(x) {
# 	class(x) <- c('test', class(x))
# 	attr(x, "test_col") <- "y"
# 	x
# }
#
# print.test <- function(x) {
# 	testCol <- names(x)[names(x) %in% attr(x, "test_col")]
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

