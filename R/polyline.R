#' Simplify Polyline
#'
#' simplifies a polyline using a vector-clustering algorithm
#'
#' This method computes the haversine distance between sequential sets of coordiantes,
#' and if they fall within the \code{distancetolerance} value the coordinates are discarded
#'
#' @details
#' The 'simple' \code{type} uses simple vector clustering to simplify the polyline,
#' which tests sequential coordinates to see if they fall within the \code{distanceTolerance}.
#'
#' The 'complex' \code{type} uses the recursive Douglas Peucker algorithm to simplify the polyline.
#'
#'
#' @param polyline encoded string of a polyline
#' @param type the type of algorithm used to simplify the polyline. One of 'simple' or 'complex'. See Details
#' @param distanceTolerance in metres. For \code{simple}, sequential points within this
#' distance are dropped. For \code{complex}, it is the distance away from each line
#' segment that determins if a point is kept (outside the distance is kept)
#'
#' @examples
#' \dontrun{
#'
#' library(googleway)
#'
#' dt_melbourne <- copy(googleway::melbourne)
#' setDT(dt_melbourne)
#' dt_melbourne[, dpSimple := SimplifyPolyline(polyline, 100, type = "complex")]
#' dt_melbourne[, Simple := SimplifyPolyline(polyline, 15000, type = "simple")]
#'
#' object.size(dt_melbourne$polyline)
#' object.size(dt_melbourne$dpSimple)
#' object.size(dt_melbourne$Simple)
#'
#' }
#'
#'
#'
#'
#' @export
SimplifyPolyline <- function(polyline, distanceTolerance = 100, type = c("simple", "complex")){

  if(type == "simple"){
  	## the 'simple' method uses dtDist2gc, which requires another tolerance an earth radius
  	return(rcppSimplifyPolyline(polyline, distanceTolerance, 1e+9, earthsRadius()))
  }else if(type == "complex"){
		return(rcppDouglasPeucker(polyline, distanceTolerance))
  }else{
  	stop("unknown type")
  }

}

#' Decode PL
#'
#' Decodes an encoded polyline into the series of lat/lon coordinates that specify the path
#'
#' @note
#' An encoded polyline is generated from google's polyline encoding algorithm (\url{https://developers.google.com/maps/documentation/utilities/polylinealgorithm}).
#'
#' @seealso \link{encode_pl}, \link{google_directions}
#'
#' @param encoded String. An encoded polyline
#' @return data.frame of lat/lon coordinates
#' @importFrom Rcpp evalCpp
#' @examples
#' ## polyline joining the capital cities of Australian states
#' pl <- "nnseFmpzsZgalNytrXetrG}krKsaif@kivIccvzAvvqfClp~uBlymzA~ocQ}_}iCthxo@srst@"
#'
#' df_polyline <- decode_pl(pl)
#' df_polyline
#' @export
decode_pl <- function(encoded){

	if(class(encoded) != "character" | length(encoded) != 1)
		stop("encoded must be a string of length 1")

	tryCatch({
		rcpp_decode_pl(encoded)
	},
	error = function(cond){
		message("The encoded string could not be decoded. \nYou can manually check the encoded line at https://developers.google.com/maps/documentation/utilities/polylineutility \nIf the line can successfully be manually decoded, please file an issue: https://github.com/SymbolixAU/googleway/issues ")
	})

}


#' Encode PL
#'
#' Encodes a series of lat/lon coordinates that specify a path into an encoded polyline
#'
#' @note
#' An encoded polyline is generated from google's polyline encoding algorithm (\url{https://developers.google.com/maps/documentation/utilities/polylinealgorithm}).
#'
#' @seealso \link{decode_pl}
#'
#' @param lat vector of latitude coordinates
#' @param lon vector of longitude coordinates
#'
#' @examples
#' encode_pl(lat = c(38.5, 40.7, 43.252), lon = c(-120.2, -120.95, -126.453))
#' ## "_p~iF~ps|U_ulLnnqC_mqNvxq`@"
#'
#'
#' @return string encoded polyline
#'
#' @export
encode_pl <- function(lat, lon){

	# if(!inherits(df, "data.frame"))
	#   stop("encoding algorithm only works on data.frames")

	if(length(lat) != length(lon))
		stop("lat and lon must be the same length")

	tryCatch({
		rcpp_encode_pl(lat, lon, length(lat))
	},
	error = function(cond){
		message("The coordinates could not be encoded")
	})
}
