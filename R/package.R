#' @useDynLib spatialdatatable
#' @importFrom Rcpp sourceCpp
NULL

#' @import data.table
#' @import sf
NULL


## TODO:
## - include a 'sequence' column to show the points in sequence
## - need an 'id' for polygons with holes, and non-simple (i.e., a polygon defined by two regions)
## - decode_pl() to accept a vector of polylines
## - methods for polylines
## -- length
##
## - if 'SimplifyPolyline' is called on a 'sdt_polyline' column, return a 'spdt_polyline column
##
## - re-building the package prevents := from working
