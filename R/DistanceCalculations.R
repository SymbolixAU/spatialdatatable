#' dt haversine
#'
#' Calculates the Haversine distance between two points
#'
#' @param latFrom latitude
#' @param lonFrom longitude
#' @param latTo latitude
#' @param lonTo latitude
#' @param tolerance numeric. See details
#'
#' @details
#' \code{tolerance} - Floating-point precision can sometimes lead to the
#' situation `sqrt(1 - 1.00000001)`, which will introduce NAs into the result.
#'
#' The tolerance value is used in `ifelse(a > 1 & a <= tolerance, 1, a)`
#'
#' @return distance in metres
#' @examples
#' dt <- data.table(lat1 = seq(-38, -37, by = 0.1),
#'   lon1 = seq(144, 145, by = 0.1),
#'   lat2 = seq(-35, -34, by = 0.1),
#'   lon2 = seq(145, 146, by = 0.1))
#'
#' dt[, distance := dtHaversine(lat1, lon1, lat2, lon2)]
#'
#' @export
dtHaversine <- function(latFrom, lonFrom,
												latTo, lonTo,
												tolerance = 1e+9){

	rcppDistanceHaversine(latFrom, lonFrom, latTo, lonTo, tolerance)
}

#' dt cosine
#'
#' Calculates the Cosine distance between two points
#'
#' @param latFrom latitude
#' @param lonFrom longitude
#' @param latTo latitude
#' @param lonTo latitude
#'
#'
#' @return distance in metres
#' @examples
#' dt <- data.table(lat1 = seq(-38, -37, by = 0.1),
#'   lon1 = seq(144, 145, by = 0.1),
#'   lat2 = seq(-35, -34, by = 0.1),
#'   lon2 = seq(145, 146, by = 0.1))
#'
#' dt[, distance := dtCosine(lat1, lon1, lat2, lon2)]
#'
#' @export
dtCosine <- function(latFrom, lonFrom,
												latTo, lonTo){

	rcppDistanceCosine(latFrom, lonFrom, latTo, lonTo)
}


#' dt Euclidean
#'
#' Computes the Euclidean distance between two pairs of latitude / longitude coordinates
#'
#' @param latFrom latitude from
#' @param lonFrom longitude from
#' @param latTo latitude to
#' @param lonTo longitude to
#' @return Euclidean distance
#'
#' @examples
#' dt <- data.table(lat1 = seq(-38, -37, by = 0.1),
#'   lon1 = seq(144, 145, by = 0.1),
#'   lat2 = seq(-35, -34, by = 0.1),
#'   lon2 = seq(145, 146, by = 0.1))
#'
#' dt[, distance := dtEuclidean(lat1, lon1, lat2, lon2)]
#'
#' @export
dtEuclidean <- function(latFrom, lonFrom, latTo, lonTo){
	rcppDistanceEuclidean(latFrom, lonFrom, latTo, lonTo)
}


#' dt bearing
#'
#' Calculates the initial bearing between two pairs of latitude / longitude coordinates
#'
#' @note The initial bearing is sometimes called the 'forward azimuth', which if followed in a straight line along a great-circle arc will take you from teh start point to the end point
#' @param latFrom latitude from
#' @param lonFrom longitude from
#' @param latTo latitude to
#' @param lonTo longitude to
#' @param compassBearing logical indicating whether to return the value in the range 0 - 360
#' @return bearing in degrees
#' @examples
#' dtBearing(0,0,0,52)
#'
#' dtBearing(25, 0, 35, 0)
#'
#' dtBearing(25, 0, -25, 0)
#'
#' dtBearing(0, 0, 0, -1)
#' dtBearing(0, 0, 0, -1, compassBearing = TRUE)
#'
#' dtBearing(0, 0, 1, -1)
#'
#' dtBearing(0, 0, 0, 1)
#'
#' dtBearing(0, 0, 1, -0.001)
#' dtBearing(0, 0, 1, -0.001, compassBearing = TRUE)
#'
#' dtBearing(-37,144,-38,145)
#'
#' @export
dtBearing <- function(latFrom, lonFrom, latTo, lonTo, compassBearing = FALSE){
	rcppBearing(latFrom, lonFrom, latTo, lonTo, compassBearing)
}






#' dt midpoint
#'
#' Finds the half-way point along the great circle path between two points
#'
#' @param latFrom latitude from
#' @param lonFrom longitude from
#' @param latTo latitude to
#' @param lonTo longitude to
#' @return list of the latitude & longitude coordinates at the midpoint along the line
#' @examples
#' dtMidpoint(0,0,0,52)
#'
#' dtMidpoint(25, 0, -25, 0)
#'
#' dtMidpoint(-37,144,-38,145)
#'
#' dtMidpoint(25, 0, 35, 0)
#'
#' n <- 10
#' set.seed(20170511)
#' lats <- -90:90
#' lons <- -180:180
#' dt <- data.table::data.table(lat1 = sample(lats, size = n, replace = T),
#'                              lon1 = sample(lons, size = n, replace = T),
#'                              lat2 = sample(lats, size = n, replace = T),
#'                              lon2 = sample(lons, size = n, replace = T))
#'
#' dt[, c("latMid", "lonMid") := dtMidpoint(lat1, lon1, lat2, lon2)]
#'
#'
#' @export
dtMidpoint <- function(latFrom, lonFrom, latTo, lonTo){
	rcppMidpoint(latFrom, lonFrom, latTo, lonTo)
}



#' dt destination
#'
#' Calculates the destination coordinates from a starting point, initial bearing and distance travelling along a (shortest distance) great circle arc
#'
#' @param latFrom latitude from (in degrees)
#' @param lonFrom longitude from (in degrees)
#' @param distance distance in metres
#' @param bearing from north (in degrees)
#' @return list of latitude and longitude coordinates at the destination
#' @examples
#'
#' dtDestination(0, 0, earthsRadius(), 90)
#'
#' n <- 10
#' set.seed(20170511)
#' lats <- -90:90
#' lons <- -180:180
#' b <- 0:360
#' dt <- data.table::data.table(lat = sample(lats, size = n, replace = T),
#'                              lon = sample(lons, size = n, replace = T),
#'                              bearing = sample(b, size = n, replace = T))
#' dt[, c("destinationLat", "destinationLon") := dtDestination(lat, lon, 90)]
#'
#' @export
dtDestination <- function(latFrom, lonFrom, distance, bearing){
	rcppDestination(latFrom, lonFrom, distance, bearing);
}


#' dt Antipode
#'
#' Calculates the antipodal coordiantes for a given pair of coordinates
#'
#' @param lat latitude coordinate
#' @param lon longitude coordinate
#'
#' @examples
#' \dontrun{
#'
#'  dt <- data.table(lat = c(-37,-36,-35),
#'                   lon = c(143,144,145))
#'
#'  ## return just the antipodes
#'  dt[, dtAntipode(lat, lon)]
#'
#'  ## return a new columns of antipodes
#'  dt[, c("AntLat", "AntLon") := dtAntipode(lat, lon)]
#'
#' }
#'
#' @return a list of length 2, the first element being the latitude coordinates,
#' and the second element being the longitude coordinates
#'
#' @export
dtAntipode <- function(lat, lon) {
	return(list(antipodeLat(lat), antipodeLon(lon)))
}


#' Dist 2 gc
#'
#' Finds the distance of a point to a great-circle path
#'
#' Sometimes called 'cross-track' distance
#'
#' @param latFrom latitude value for the start of the path
#' @param lonFrom longitude value for the sttart of the path
#' @param latTo lattitude value for the end of the path
#' @param lonTo longitude value for the end of the path
#' @param pointLat latitude value for the point
#' @param pointLon longitude value for the point
#' @param tolerance
#'
#' @examples
#' dt <- data.table(lat1 = c(0, 0),
#'                  lon1 = c(0, 0),
#'                  lat2 = c(20, -20),
#'                  lon2 = c(0, 0),
#'                  plat = c(10, -10),
#'                  plon = c(22, 22))
#'
#' dt[, dist := dtDist2gc(lat1, lon1, lat2, lon2, plat, plon)]
#'
#' @return distance in metres. The sign of the result indicates if the point
#' is to the left (negative) or right (positive) of the line when traveling
#' from `latFrom,lonFrom` to `latTo,lonTo`.
#'
#' @export
dtDist2gc <- function(latFrom, lonFrom, latTo, lonTo, pointLat, pointLon,
											tolerance = 1e+9){

	## TODO:
	## - specify the distance function to use in the calculationg
	## - (currently uses haversine)

	rcppDist2gc(latFrom, lonFrom, latTo, lonTo, pointLat, pointLon,
							tolerance)
}

#' Along Track Distance
#'
#' Calculates the distance along a great-circle to the cross-track point
#'
#' @param latFrom latitude value for the start of the path
#' @param lonFrom longitude value for the sttart of the path
#' @param latTo lattitude value for the end of the path
#' @param lonTo longitude value for the end of the path
#' @param pointLat latitude value for the point
#' @param pointLon longitude value for the point
#' @param tolerance
#'
#' @seealso dtDist2gc
#'
#' @export
dtAlongTrackDistance <- function(latFrom, lonFrom, latTo, lonTo, pointLat, pointLon,
																 tolerance = 1e+9){

	rcppAlongTrack(latFrom, lonFrom, latTo, lonTo, pointLat, pointLon, tolerance)
}


antipodeLat <- function(lat) return(-lat)
antipodeLon <- function(lon) return((lon %% 360) - 180)


#' Earths Radius
#'
#' Returns an approximation of the radius of the earth in metres
#'
#' @examples
#' earthsRadius()
#' @export
earthsRadius <- function() rcppEarthRadius()


toRadians <- function(x) return(x * (pi / 180))
toDegrees <- function(x) return(x / (pi / 180))

