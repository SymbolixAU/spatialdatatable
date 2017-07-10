#' toSDT
#'
#' Converts Spatial objects (from packages \code{sp} and \code{sf}) into a \code{data.table}
#'
#' @param sobj Spatial or sf object
#'
#' @examples
#' \dontrun{
#'
#' library(googleway)
#' library(sp)
#'
#' ## SpatialPointsDataFrame
#' sp <- SpatialPointsDataFrame(coords = tram_stops[, c("stop_lon", "stop_lat")],
#'     data = tram_stops[, setdiff(names(tram_stops), c("stop_lon", "stop_lat"))])
#' dt <- toSDT(sp)
#'
#' ## spLine
#' spLine <- Line(tram_route[, c("shape_pt_lat", "shape_pt_lon")])
#' dt <- toSDT(spLine)
#'
#' ## spLines
#' spLines <- Lines(Line(tram_route[, c("shape_pt_lat", "shape_pt_lon")]), ID = 1)
#' dt <- toSDT(spLines)
#'
#' ## SpatialLines
#' spLines <- SpatialLines(list(Lines(Line(tram_route[, c("shape_pt_lat", "shape_pt_lon")]), ID = 1)))
#' dt <- toSDT(spLines)
#'
#' ## SpatialLinesDataFrame
#' spdf <- SpatialLinesDataFrame(spLines, data = data.frame(route = 35, operator = "Yarra Trams"))
#' dt <- toSDT(spdf)
#'
#' ## Polygon
#' df <- data.frame(lat = c(25.774, 18.466, 32.321, 28.745, 29.570, 27.339),
#'                  lon = c(-80.190, -66.118, -64.757, -70.579, -67.514, -66.668),
#'                  id = c(rep('outer', 3), rep('inner', 3)))
#' pl_outer <- Polygon(df[df$id == "outer", c("lat", "lon")])
#' dt <- toSDT(pl_outer)
#'
#' ## Polygons
#' pl_inner <- Polygon(df[df$id == "inner", c("lat", "lon")])
#' pl <- Polygons(list(pl_outer, pl_inner), ID = "bermuda")
#' dt <- toSDT(pl)
#'
#' ## SpatialPolygons
#' sppl <- SpatialPolygons(list(pl))
#' dt <- toSDT(sppl)
#'
#' ## SpatialPolygonsDataFrame
#' spdf <- SpatialPolygonsDataFrame(sppl, data = data.frame(ID = c("bermuda")), match.ID = FALSE)
#' dt <- toSDT(spdf)
#'
#'
#'
#' library(sf)
#'
#'
#' ## sfc MULTIPOINT
#' p <- rbind(c(3.2,4), c(3,4.6), c(3.8,4.4), c(3.5,3.8), c(3.4,3.6), c(3.9,4.5))
#' mp <- st_multipoint(p)
#' dt <- toSDT(mp)
#'
#' ## sfc LINESTRING
#' s1 <- rbind(c(0,3),c(0,4),c(1,5),c(2,5))
#' ls <- st_linestring(s1)
#' toSDT(ls)
#'
#' ## sfc MULTILINESTRING
#' s2 <- rbind(c(0.2,3), c(0.2,4), c(1,4.8), c(2,4.8))
#' s3 <- rbind(c(0,4.4), c(0.6,5))
#' mls <- st_multilinestring(list(s1,s2,s3))
#' dt <- toSDT(mls)
#'
#' ## sfc POLYGONS
#' p1 <- rbind(c(0,0), c(1,0), c(3,2), c(2,4), c(1,4), c(0,0))
#' p2 <- rbind(c(1,1), c(1,2), c(2,2), c(1,1))
#' pol <-st_polygon(list(p1,p2))
#' dt <- toSDT(pol)
#'
#' ## sfc MULTIPOLYGON
#' p3 <- rbind(c(3,0), c(4,0), c(4,1), c(3,1), c(3,0))
#' p4 <- rbind(c(3.3,0.3), c(3.8,0.3), c(3.8,0.8), c(3.3,0.8), c(3.3,0.3))[5:1,]
#' p5 <- rbind(c(3,3), c(4,2), c(4,3), c(3,3))
#' mpol <- st_multipolygon(list(list(p1,p2), list(p3,p4), list(p5)))
#' dt <- toSDT(mpol)
#'
#' }
#' @export
toSDT <- function(sobj) {
	UseMethod("toSDT")
}

#' spToDT
#'
#' deprecated. Now use \link{toSDT}
#'
#' @param sobj spatial or sf object
#' @export
spToDT <- function(sobj){
	warning("I've deprecated this function. In the future please use toSDT()")
	toSDT(sp)
}


#' @export
toSDT.Line <- function(sp){

	## No ID slot
	dt = data.table::data.table(coords = slot(sp, "coords"))
	return(.spatial.data.table(dt))
}

#' @export
toSDT.Lines <- function(sp){

	dt <- data.table::rbindlist(lapply(1:length(sp), function(x){

		data.table::data.table(
			id = slot(sp, "ID"),
			coords = slot(sp@Lines[[x]], "coords")
		)

	}))
	return(.spatial.data.table(dt))
}

#' @export
toSDT.SpatialLines <- function(sp){
	toSDTMessage(sp)

	dt <- data.table::rbindlist(lapply(1:length(sp), function(x){

		data.table::data.table(
			id = slot(sp@lines[[x]], "ID"),
			coords = slot(slot(sp@lines[[x]], "Lines")[[1]], "coords")
		)
	}))
	return(.spatial.data.table(dt))
}



#' @export
toSDT.SpatialLinesDataFrame <- function(sp){

	toSDTMessage(sp)

	dt <- data.table::rbindlist(lapply(1:length(sp), function(x){

		data.table::data.table(
			id = slot(sp@lines[[x]], "ID"),
			coords = slot(slot(sp@lines[[x]], "Lines")[[1]], "coords"),
			data = slot(sp, "data")[x, ])
	}))
	return(.spatial.data.table(dt))
}


#' @export
toSDT.SpatialPoints <- function(sp){
  ## No ID slot
	toSDTMessage(sp)
	dt <- data.table::data.table(coords = slot(sp, "coords"))
	return(.spatial.data.table(dt))
}

#' @export
toSDT.SpatialPointsDataFrame <- function(sp){
  ## No ID slot
	toSDTMessage(sp)

	dt <- data.table::data.table(
		coords = slot(sp, "coords"),
		data = slot(sp, "data")
	)
	return(.spatial.data.table(dt))
}



#' @export
toSDT.Polygon <- function(sp){
  ## No ID Slot
	dt <- data.table::data.table(coords = slot(sp, "coords"),
															 hole = slot(sp, "hole"),
															 ringDir = slot(sp, "ringDir"))
	return(.spatial.data.table(dt))
}

#' @export
toSDT.Polygons <- function(sp){

	dt <- data.table::rbindlist(

		lapply(1:length(sp@Polygons), function(x){

			data.table::data.table(
				id = slot(sp, "ID"),
				lineId = x,
				hole = slot(sp@Polygons[[x]], "hole"),
				ringDir = slot(sp@Polygons[[x]], "ringDir"),
				coords = slot(sp@Polygons[[x]], "coords")
			)
		})
	)
	return(.spatial.data.table(dt))
}

#' @export
toSDT.SpatialPolygons <- function(sp){
	toSDTMessage(sp)

	dt <- data.table::rbindlist(lapply(1:length(sp), function(x){

		data.table::rbindlist(lapply(1:length(sp@polygons[[x]]@Polygons), function(y){

			data.table::data.table(
				id = slot(sp@polygons[[x]], "ID"),
				lineId = y,
				coords = slot(sp@polygons[[x]]@Polygons[[y]], "coords"),
				ringDir = slot(sp@polygons[[x]]@Polygons[[y]], "ringDir"),
				hole = slot(sp@polygons[[x]]@Polygons[[y]], "hole")
			)
		}))
	}))
	return(.spatial.data.table(dt))
}



#' @export
toSDT.SpatialPolygonsDataFrame <- function(sp){

	toSDTMessage(sp)

	dt <- data.table::rbindlist(lapply(1:length(sp), function(x){

		data.table::rbindlist(lapply(1:length(sp@polygons[[x]]@Polygons), function(y){

			data.table::data.table(
				id = slot(sp@polygons[[x]], "ID"),
				lineId = y,
				coords = slot(sp@polygons[[x]]@Polygons[[y]], "coords"),
				ringDir = slot(sp@polygons[[x]]@Polygons[[y]], "ringDir"),
				hole = slot(sp@polygons[[x]]@Polygons[[y]], "hole"),
				data = slot(sp, "data")[x, ]
			)

		}))
	}))
	return(.spatial.data.table(dt))

}

#' @export
toSDT.sf <- function(sf){

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

	dt_geom <- GeomToDT(geom)

	dt <- dt[ dt_geom, on = c(id = ".id"), nomatch = 0]
	return(.spatial.data.table(dt))
}


#' @export
toSDT.sfg <- function(sf){
	## e.g. class: "XY"  "LINESTRING"  "sfg"
	dt_geom <- GeomToDT(sf::st_geometry(sf))
	return(.spatial.data.table(dt_geom))
}



#' @export
GeomToDT <- function(geom) UseMethod("GeomToDT")

#' @export
GeomToDT.sfc_POINT <- function(geom){

	lst <- sapply(geom, `[`)

	data.table::data.table(.id = seq_along(lst),
												 coords.V1 = lst[1, ],
												 coords.V2 = lst[2, ])

}

#' @export
GeomToDT.sfc_MULTIPOINT <- function(geom){

	lst <- lapply(geom, `[`)

	data.table::rbindlist(
		lapply(lst, function(x){
			data.table::as.data.table(x)
		}), idcol = TRUE
	)
}


#' @export
GeomToDT.sfc_LINESTRING <- function(geom){

	data.table::rbindlist(
		lapply(geom, function(x){
			data.table::data.table(
				coords.V1 = x[,1],
				coords.V2 = x[,2]
			)
		}), idcol = TRUE
	)
}

#' @export
GeomToDT.sfc_MULTILINESTRING <- function(geom){

	data.table::rbindlist(
		lapply(geom, function(x){
			data.table::rbindlist(
				lapply(1:length(x), function(y){
					data.table::data.table(
						lineId = y,
						coords.V1 = x[[y]][,1],
						coords.V2 = x[[y]][,2]
					)
				})
			)
		}), idcol = T
	)
}

#' @export
GeomToDT.sfc_POLYGON <- function(geom){

	data.table::rbindlist(

		lapply(geom, function(x){

			data.table::rbindlist(
				lapply(1:length(x), function(y){

					data.table::data.table(
						lineId = y,
						coords.V1 = x[[y]][,1],
						coords.V2 = x[[y]][,2],
						hole = (y > 1)[c(T, F)]
					)
				})
			)
		}), idcol = T
	)
}

## TODO:
## MULTIPOINT
## MULTILINESTRING
## GEOMETRYCOLLECTION


#' @export
GeomToDT.sfc_MULTIPOLYGON <- function(geom){

	## a polygon consists of (Ext_ring, hole, hole, hole, ...)
	## a multipolygon consists of ((polygon),(polygon),(polygon))
	data.table::rbindlist(

		lapply(geom, function(x){

			data.table::rbindlist(

				lapply(1:length(x), function(y){

					data.table::data.table(
						lineId = y,
						coords.V1 = x[[y]][[1]][,1],
						coords.V2 = x[[y]][[1]][,2],
						hole = (y > 1)[c(T, F)]
					)
				})
			)
		}), idcol = T
	)
}

#' @export
GeomToDT.default <- function(geom){
	message(paste0("Many apologies, I don't know how to handle objects of class ", class(geom)[[1]]))
}


#' @export
toSDT.default <- function(sp){
	stop(paste0("I don't know how to convert objects of class ", paste0(class(sp), collapse = " ,")))
}

toSDTMessage <- function(sp){
	message(paste0("dropping projection attribute: ", slot(slot(sp, "proj4string"), "projargs")))
}
