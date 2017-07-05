#' sf Tram Route
#'
#' Simple Features (\code{library(sf)}) object of the route 35 Tram in Melbourne
#'
#' @format A \code{sf} object of 2 observations and 1 variable
#' \describe{
#'   \item{geometry}{sfc_LINESTRING of length 2}
#' }
"sf_tramRoute"


#' Sdt Melbourne
#'
#' Polygons for Melbourne and the surrounding area
#'
#' This data set is a subset of the Statistical Area Level 2 (SA2) ASGS
#' Edition 2016 data released by the Australian Bureau of Statistics
#' \url{ http://www.abs.gov.au }
#'
#' The data is realsed under a Creative Commons Attribution 2.5 Australia licence
#' \url{https://creativecommons.org/licenses/by/2.5/au/}
#'
#'
#' @format A data frame with 397 observations and 7 variables
#' \describe{
#'   \item{polygonId}{a unique identifier for each polygon}
#'   \item{pathId}{an identifier for each path that define a polygon}
#'   \item{SA2_NAME}{statistical area 2 name of the polygon}
#'   \item{SA3_NAME}{statistical area 3 name of the polygon}
#'   \item{SA4_NAME}{statistical area 4 name of the polygon}
#'   \item{AREASQKM}{area of the SA2 polygon}
#'   \item{polyline}{encoded polyline that defines each \code{pathId}}
#' }
#'
#' @examples
#'
#' sdt <- copy(sdt_melbourne)
"sdt_melbourne"
