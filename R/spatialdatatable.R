

#' @export
print.spatialdatatable <- function(x, ...){
	## TODO:
	## handle printing a subset of columns
	# spdt_melbourne[, .(polygonId, polyline)]

	## replace the polyine with just 20 chars
	# print(str(x))
	# print(x)
	# pl <- spdt_polyline_col(x)
	# print(pl)
	# print(str(x))

	# if(length(pl) > 0){
	# 	print("polyline exists")
	#  	x[[pl]] <- paste0(substr(x[[pl]], 1, pmin(20, nchar(x[[pl]]) ) ), "...")
	# }else{
	# 	print("no polyline")
	# }
	NextMethod()
}


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

