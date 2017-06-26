#' Nearest Points
#'
#' Finds the nearest points between two data tables.
#'
#' @note \code{dt1} and \code{dt2} get updated by reference within the function call, which modifies the original \code{data.table} objects.
#' To avoid this behaviour you can use a \code{data.table::copy()} of the objects as the arguments for \code{dt1} and \code{dt2}. See Examples
#'
#' @param dt1 \code{data.table} containing the points to be matched onto
#' @param dt2 \code{data.table} containing the points for which you want to find a match in \code{dt1}
#' @param dt1Coords vector containing the names of the columns of \code{dt1} containing the latitude and longitude (in that order) coordinates. If NULL, a 'best-guess' will be made
#' @param dt1Coords vector containing the names of the columns of \code{dt2} containing the latitude and longitude (in that order) coordinates. If NULL, a 'best-guess' will be made
#' @param dt2Id string specifying the column of \code{dt2} containing a unique id for each point. If NULL, a value of the point's row index will be assigned
#' @param distanceCalculation distance measure
#'
#' @examples
#' library(googleway) ## for the tram stops and routes data
#' library(data.table)
#'
#' dt_stops <- as.data.table(tram_stops)
#' dt_route <- as.data.table(tram_route)
#' dtNearestPoints(dt1 = copy(dt_route),
#'   dt2 = copy(dt_stops),
#'   dt1Coords = c("shape_pt_lat", "shape_pt_lon"),
#'   dt2Coords = c("stop_lat","stop_lon"))
#'
#' @export
dtNearestPoints <- function(dt1, dt2,
														dt1Coords = NULL, dt2Coords = NULL,
														dt2Id = NULL,
														distanceCalculation = c("haversine")){


	if(is.null(dt1Coords)){
		dt1Coords <- c(find_lat_column(names(dt1), "dtNearestPoints - dt1"),
									 find_lon_column(names(dt1), "dtNearestPoints - dt1"))
	}else{
		check_for_columns(dt1, dt1Coords, "dt2")
	}

	if(is.null(dt2Coords)){
		dt2Coords <- c(find_lat_column(names(dt2), "dtNearestPoints - dt2"),
									 find_lon_column(names(dt2), "dtNearestPoints - dt2"))
	}else{
		check_for_columns(dt2, dt2Coords, "dt2")
	}

	if(is.null(dt2Id)){
		dt2[, idx := .I][]
	}

	## append .x and .y to column names
	data.table::setnames(dt1, dt1Coords, paste0(dt1Coords, ".x"))
	data.table::setnames(dt2, dt2Coords, paste0(dt2Coords, ".y"))

	dt1Coords <- paste0(dt1Coords, ".x")
	dt2Coords <- paste0(dt2Coords, ".y")

	dt1[, key.x := 1][]
	dt2[, key.y := 1][]

	dt <- dt1[ dt2, on = c(key.x = "key.y"), allow.cartesian = T]
	dt[, distance := dtHaversine(get(dt1Coords[1]), get(dt1Coords[2]), get(dt2Coords[1]), get(dt2Coords[2]))][]

	return(dt[ dt[, .I[which.min(distance)], by = idx]$V1 ])

}


#' Point In Polygon
#'
#' Determins if points lie within the boundaries of polygons
#'
#' @details
#' Calculates the winding number (\url{https://en.wikipedia.org/wiki/Winding_number})
#'
#' @examples
#' \dontrun{
#'  ## example
#' }
#' @param dt_polygons \code{data.table} object containing the polygon coordinates
#' @param polyColumns character vector of column names containing the id, lineId, x, y and hole fields (in that order)
#' @param dt_points \code{data.table} object containing the point coordinates
#' @param pointColumns character vector of column names containing the id, x and y fields (in that order)
#' @return \code{data.table} giving the ids of the points and the polygons within which they fall
#'
#' @export
PointInPolygon <- function(dt_polygons, polyColumns, dt_points, pointColumns){

	if(!inherits(dt_polygons, "data.table")) data.table::setDT(dt_polygons)
	if(!inherits(dt_points, "data.table")) data.table::setDT(dt_points)

	## put every point against every polygon

	dt_poly <- dt_polygons[, polyColumns, with = FALSE]
	dt_point <- dt_points[, pointColumns, with = FALSE]

	data.table::setnames(dt_poly, polyColumns, c("id","lineId", "lat", "lon", "hole"))
	data.table::setnames(dt_point, pointColumns, c("point_id","lat","lon"))

	dt_poly[, key := 1]
	dt_point[, key := 1]

	dt <- dt_poly[ dt_point, on = "key", allow.cartesian = T]

	dt[, vy_lte_py := get("lon") <= get("i.lon")]
	dt[, vy1_gte_y := shift(get("lon"), type = "lead") > get("i.lon"), by = c("id", "lineId", "point_id")]
	dt[, vy1_lte_py := shift(get("lon"), type = "lead") <= get("i.lon"), by = c("id","lineId", "point_id")]

	dt[, isLeft := isLeft(i.lat, i.lon,
												shift(lat, type = "lead"),
												shift(lon, type = "lead"), lat, lon),
		 by = .(id, lineId, point_id)]

	# ## wn +1
	# dt[vy_lte_py & vy1_gte_y & isLeft > 0, .N, by = .(id, point_id)]
	#
	# ## wn -1
	# dt[!vy_lte_py & vy1_lte_py  & isLeft < 0, .N, by = .(id, point_id)]
	dt <- merge( x = dt[vy_lte_py & vy1_gte_y & isLeft > 0, .N, by = c("id","lineId", "point_id", "hole")],
							 y = dt[!vy_lte_py & vy1_lte_py  & isLeft < 0, .N, by = c("id","lineId", "point_id", "hole")],
							 by = c("id","lineId", "point_id", "hole"),
							 all = TRUE,
							 sort = F)

	## last enclosure can't be a hole
	dt[
		(is.na(N.x) | is.na(N.y) | N.x != N.y), c("id", "lineId", "point_id","hole")
		]

	## if the point is in a 'hole', then it's NOT in the polygon

}

#' Is Left
#'
#' Tests if a point is Left|On|Right of an infinite line
#' Returns:
#'  > 0 : P2 is left of the line through P0, P1
#'  = 0 : P2 is on the line
#'  < 0 : P2 is right of the line through P0, P1
isLeft <- function(p0x, p0y, p1x, p1y, p2x, p2y){
	return((p1x - p0x) * (p2y - p0y) - (p2x - p0x) * (p1y - p0y))
}





