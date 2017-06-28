

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


#' #' @export
#' `[.spatialdatatable` <- function(x, ...){
#'
#' 	## need to keep the polyline attribute if it exists
#' 	print("subsetting")
#' 	NextMethod()
#' }
#'
#'
#' as.test <- function(x) {
#' 	class(x) <- c('test', class(x))
#' 	attr(x, "test_col") <- "y"
#' 	attr(x[["y"]], "test_col_") <- "the column"
#' 	x
#' }
#'
#' print.test <- function(x) {
#' 	testCol <- names(x)[names(x) %in% attr(x, "test_col")]
#' 	print( paste0("testCol: ", testCol))
#' 	if(!is.null(testCol)){
#' 		x[['y']] <- "more tests"
#' 	}
#' 	NextMethod()
#' }
#'
#' find.test.col <- function(x) UseMethod("find_test_col")
#'
#' find_test_col.test <- function(x){
#' 	names(x)[names(x) %in% attr(x, "test_col")]
#' }
#'
#' a <- data.table(x = 1:5, y = 1:5)
#' b <- as.test(a)
#'
#' b
#' str(b)
#' b[1:2, ]
#' str(b[1:2, ])

