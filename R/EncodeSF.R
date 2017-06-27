#' Encode Simple Feature
#'
#' Converts coordinates from simple-feature objects (\code{sf}) into encoded polylines
#'
#' @param sf simple-feature object (from \code{library(sf)})
#'
#' @examples
#' library(sf)
#'
#' sf_poly <- st_as_sfc(c("POLYGON((-80.190 25.774, -66.118 18.466, -64.757 32.321))",
#'                        "POLYGON((-70.579 28.745, -67.514 29.570, -66.668 27.339))"))
#' sf <- st_sf(id = paste0("poly", 1:2), sf_poly)
#'
#' EncodeSF(sf)
#'
#' @export
EncodeSF <- function(sf){

	dataCols <- setdiff(names(sf), attr(sf, 'sf_column'))
	if(length(dataCols) == 0){
		dt <- data.table::data.table(id = 1:nrow(sf))
	}else{
		dt <- data.table::as.data.table(sf)[, dataCols, with = F]
		## TODO:
		## accept an ID column
		dt[, id := .I]
	}

	geom <- sf::st_geometry(sf)

	dt_geom <- EncodePolyline(geom)

	return(dt_geom)
	#return(dt[ dt_geom, on = c(id = ".id"), nomatch = 0])

}


EncodePolyline <- function(geom) UseMethod("encodePolyline")

# sets 'polyline' attribute on the polyline column
.encode.polyline <- function(x){
	attr(x, "polyline") <- "spdt_polyline"
	return(.spatialdatatable(x))
}


#' @export
encodePolyline.sfc_LINESTRING <- function(geom){

		pl <- sapply(1:length(geom), function(x){
			m <- unlist(geom[[x]])
			encode_pl(m[,2],m[,1])
		})

		dt <- data.table::data.table(.id = 1:length(geom),
																	polyline = pl)

		return(.encode.polyline(dt))
}

# gets the encoded polyline from the spdt
#' @export
spdt_polyline <- function(spdt) UseMethod("spdt_polyline")

#' @export
spdt_polyline.spatialdatatable <- function(spdt){
	spdt[[attr(spdt, "spdt_polyline")]]
}

#' @export
spdt_polyline.default <- function(obj){
	return(NULL)
}

#' @export
spdt_polyline_col <- function(spdt) UseMethod("spdt_polyline_col")

#' @export
spdt_polyline_col.spatialdatatable <- function(spdt){
	names(spdt)[names(spdt) %in% attr(spdt, "spdt_polyline")]
}

#' @export
spdt_polyline_col.default <- function(spdt){
	return(NULL)
}





#' @export
encodePolyline.sfc_POLYGON <- function(geom){

	dt <- data.table::rbindlist(
		lapply(geom, function(x){
				data.table::data.table(
					polyline = sapply(x, function(y){
						encode_pl(y[,2],y[,1])
						})
				)
		}), idcol = T
	)

	return(.encode.polyline(dt))

}

#' @export
encodePolyline.sfc_MULTIPOLYGON <- function(geom){

	dt <- data.table::rbindlist(

		lapply(geom, function(x){

			data.table::rbindlist(

				lapply(x, function(y){
					pl <- sapply(y, function(z){
						encode_pl(z[,2], z[,1])
					})
					lineId <- seq_along(pl)
					hole = lineId > 1
					data.table::data.table(lineId = lineId, polyline = pl, hole = hole)
				})
			)
		}), idcol = T
	)

	return(.encode.polyline(dt))

}

#' @export
encodePolyline.default <- function(geom){
	message(paste0("Many apologies, I don't know how to handle objects of class ", class(geom)))
}







