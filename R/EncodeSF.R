#' Encode Simple Feature
#'
#' Converts coordinates from simple-feature objects (\code{sf}) into encoded polylines
#'
#' @param sf simple-feature object (from \code{library(sf)})
#' @param id column of \code{sf} to be used as the id. If NULL, a value from
#' 1 to .N will be assigned to a column called \code{.id}
#'
#' @examples
#' \dontrun{
#' library(sf)
#'
#' ## sf_LINESTRING
#' sf_line <- st_as_sfc(c("LINESTRING(-80.190 25.774, -66.118 18.466, -64.757 32.321)",
#'                        "LINESTRING(-70.579 28.745, -67.514 29.570, -66.668 27.339)"))
#'
#' sf <- st_sf(id = paste0("line", 1:2), sf_line)
#'
#' sdt <- EncodeSF(sf)
#' sdt <- EncodeSF(sf, id = "id")
#'
#'
#' ## sf_POLYGON
#' sf_poly <- st_as_sfc(c("POLYGON((-80.190 25.774, -66.118 18.466, -64.757 32.321))",
#'                        "POLYGON((-70.579 28.745, -67.514 29.570, -66.668 27.339))"))
#' sf <- st_sf(id = paste0("poly", 1:2), sf_poly)
#'
#' EncodeSF(sf)
#'
#' EncodeSF(sf, id = "id")
#'
#' p1 <- rbind(c(0,0), c(1,0), c(3,2), c(2,4), c(1,4), c(0,0))
#' p2 <- rbind(c(1,1), c(1,2), c(2,2), c(1,1))
#' pol <-st_polygon(list(p1,p2))
#'
#'
#' ## sf_MULTIPOLYGON
#' filename <- system.file("shape/nc.shp", package="sf")
#' nc <- st_read(filename)
#'
#' sdt <- EncodeSF(nc)
#'
#' nc$id <- 1:nrow(nc)
#' sdt <- EncodeSF(nc, id = "id")
#'
#'
#' }
#' @export
EncodeSF <- function(sf, id = NULL){

	if(!is.null(id)){
		if(!id %in% names(sf)){
			stop(paste0("I could not find the column ", id))
		}
	}

	if(is.null(id)){
		id <- ".id"
		sf[, id] <- 1:nrow(sf)
	}

	ids <- sf[[id]]
	dataCols <- setdiff(names(sf), attr(sf, 'sf_column'))

	if(length(dataCols) == 0){
		dt <- data.table::data.table(id = ids)
	}else{
		dt <- data.table::as.data.table(sf)[, dataCols, with = F]
	}

	geom <- sf::st_geometry(sf)
	dt_geom <- EncodePolyline(geom, id, ids)

	dt <- merge(dt, dt_geom, by = id, sort = F, all = T)

	return(.encode.polyline(dt))

}


EncodePolyline <- function(geom, id, ids) UseMethod("encodePolyline")

#' @export
encodePolyline.sfc_LINESTRING <- function(geom, id, ids){

		pl <- sapply(1:length(geom), function(x){
			m <- unlist(geom[[x]])
			encode_pl(m[,2],m[,1])
		})
		dt <- data.table::data.table(id = ids,
																 polyline = pl)
		data.table::setnames(dt, "id", id)
		return(.encode.polyline(dt))
}

#' @export
encodePolyline.sfc_POLYGON <- function(geom, id, ids){

	pl <- sapply(geom, function(x){
		sapply(x, function(y){
			encode_pl(y[,2],y[,1])
		})
	})
	dt <- data.table::data.table(id = ids,
															 polyline = pl,
															 stringsAsFactors = F)
	data.table::setnames(dt, "id", id)
	return(dt)
}

#' @export
encodePolyline.sfc_MULTIPOLYGON <- function(geom, id, ids){

	dt <- data.table::rbindlist(

		lapply(1:length(ids), function(x){

			data.table::rbindlist(

				lapply(geom[[x]], function(y){
					pl <- sapply(y, function(z){
						encode_pl(z[,2], z[,1])
					})
					lineId <- seq_along(pl)
					hole = lineId > 1
					data.table::data.table(
						id = ids[x],
						lineId = lineId,
						polyline = pl,
						hole = hole)
				})
			)
		}), idcol = F
	)

	data.table::setnames(dt, "id", id)

	return(dt)

}

#' @export
encodePolyline.default <- function(geom){
	message(paste0("Many apologies, I don't know how to handle objects of class ", class(geom)))
}







