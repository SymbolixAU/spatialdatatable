## TODO:
### ----------------------------------------------------------------------------
## - does WindingNumber require clockwise / anti-clockwise path
## - the test using lat/lon coords sometimes gives 0, sometimes gives -1
## - when using lat/lon, which one is X and which is Y ?
## -- and does the geodecisity get accounted for?
## - does the WindingNumber 'for' loop go up to n or (n - 1) ?
## --- because the last point is the same as the first one?

## - some of the test-cases appear to struggle when the point is 'close' to the line
## -- however, I couldn't replicate this issue when using 'cppFunction()'
### ----------------------------------------------------------------------------

### ----------------------------------------------------------------------------
## - use bounding box to reduce compuation
### ----------------------------------------------------------------------------

### ----------------------------------------------------------------------------
### This may not be needed - this assumes the 'lineId's are listed in a sequential order
### however, this may not be the case, so we can leave it as a task for the user to filter
### out those in the holes
## - only return points where the last 'PointsInPolygon' is not in a hole
## - start from the 'max' lineId for each polygon. If the result is TRUE, and
## - it's a hole, can ignore the rest of the polygon.
## - or indeed if the first TRUE is a hole (when working backwards), can ignore the rest
## - of the polygon as the point is in a hole.
### ----------------------------------------------------------------------------

### ----------------------------------------------------------------------------
## - does the 'id', 'lineId', 'pointId' have to be integers?
### ----------------------------------------------------------------------------


#' Points In Polygon
#'
#' Determins if a set of points fall within a polygon
#'
#' @details
#' Calculates the winding number (\url{https://en.wikipedia.org/wiki/Winding_number})
#'
#' @examples
#' \dontrun{
#'  ## example
#' }
#' @param vectorX
#' @param vectorY
#' @param pointsX
#' @param pointsY
#'
#'
#' @export
PointsInPolygon <- function(vectorX, vectorY, pointsX, pointsY, pointsIds){
	rcppPointsInPolygon(pointsIds, pointsX, pointsY, vectorX, vectorY)
}

#' Winding Number
#'
#' Calculates the winding number for a point and polygon. Returns 0 when the point
#' is outside the polygon.
#'
#'
#' @param pointX x-coordinate of a point (typically 'latitude')
#' @param pointY y-coordinate of a point (typically 'longitude')
#' @param polyX x-coordinates of the polygon
#' @param polyY y-coordinates of thepolygon
#'
#' @export
WindingNumber <- function(pointX, pointY, polyX, polyY){
	rcppWindingNumber(pointX, pointY, polyX, polyY)

}

#' Test Close Polygon
#'
#' tests close polygon
#'
#' @param v
#' @export
#'
testClosePolygon <- function(v){
	rcppClosePolygon(v)
}

#' Test Is Closed
#'
#' Tests if polygon is closed
#'
#' @param v
#' @export
testIsClosed <- function(x1, x2, y1, y2){
	rcppIsPolygonClosed(x1, x2, y1, y2)
}
