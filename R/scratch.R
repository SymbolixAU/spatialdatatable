
# working through
# http://www.movable-type.co.uk/scripts/latlong.html
#
#  dt <- data.table(lat1 = seq(-38, -37, by = 0.1),
#    lon1 = seq(144, 145, by = 0.1),
#    lat2 = seq(-35, -34, by = 0.1),
#    lon2 = seq(145, 146, by = 0.1))
#
#  dt[, distance := dt.haversine(lat1, lon1, lat2, lon2)]


# sp <- readOGR(dsn = "../../SVNStuff/Clients/HT0_HydroTasmania/MRBU_MRWF_BUS_surveys/Data/Received_BUSData/GIS",
#                layer = "Roads_line")
# #
# #
# spdf <- readOGR(dsn = "../../SVNStuff/Clients/HT0_HydroTasmania/MRBU_MRWF_BUS_surveys/Data/Received_BUSData/GIS",
# 								layer = "Mainlands_poly")
#
# spToDT(sp)
#
# spToDT(spdf)

# library(data.table)
# library(sp)
# library(googleway)
#
# tram_stops
#
# sp <- SpatialPointsDataFrame(coords = tram_stops[, c("stop_lon", "stop_lat")], data = tram_stops)
#
# spToDT(sp)
#
# sp <- SpatialPoints(coords = tram_stops[, c("stop_lon", "stop_lat")])
#
# spToDT(sp)
#
# library(data.table)
# dt_stops <- as.data.table(tram_stops)
# dt_route <- as.data.table(tram_route)
#
#
# dtNearestPoints(dt1 = copy(dt_route),
# 								dt2 = copy(dt_stops),
# 								dt1Coords = c("shape_pt_lat", "shape_pt_lon"),
# 								dt2Coords = c("stop_lat","stop_lon"))



# library(data.table)
#
# dt <- data.table(x = c(-1,1,1,-1,-1), y = c(-1,-1,1,1,-1), ptx = c(0.5), pty = c(0.5))
# plot(dt$x, dt$y,"l")
#
#
# ## x & y denote our polygon (V of points)
# ## ptx and pty denote our point (P point)
#
#
# dt[, vy_lte_py := y <= pty]
# dt[, vy1_gte_y := shift(y, type = "lead") > pty]
#
#
# dt[, vy1_lte_py := shift(y, type = "lead") <= pty]
#
# dt[, isLeft := isLeft(x, y, shift(x, type = "lead"), shift(y, type = "lead"), ptx, pty)]
#
#
# dt[vy_lte_py == TRUE & vy1_gte_y & isLeft > 0]
# ## wn +1
#
# dt[vy_lte_py == FALSE & vy1_lte_py == TRUE & isLeft < 0]
# ## wn -1
#
# ## else wn == 0
#
# isLeft <- function(p0x, p0y, p1x, p1y, p2x, p2y){
# 	return((p1x - p0x) * (p2y - p0y) - (p2x - p0x) * (p1y - p0y))
# }


# sf <- sf::read_sf("~/Documents/SVNStuff/Clients/HT0_HydroTasmania/MRBU_MRWF_BUS_surveys/Data/Received_BUSData/GIS/Roads_line.shp")
# spToDT(sf)
#
# map_key <- symbolix.utils::mapKey()
#
# google_map(key = map_key) %>%
# 	add_polylines(data = shp)
#
#
# library(spatial.data.table)
# library(sf)
# nc <- st_read(system.file("shape/nc.shp", package="sf"))
#
# geom <- sf::st_geometry(nc)
# class(geom)
#
# dt.nc <- spToDT(nc)
#
#
#
# str(nc)
# nc$geom
#
# class(nc$geom)
# str(nc$geom)
# nc$geom[[1]][[1]]
#
# geomCol <- attr(sf, "sf_column")
#
# class(sf[[geomCol]])
#
# as.data.frame(sf[[geomCol]])

# sf <- rbind(c(0,3),c(0,4),c(1,5),c(2,5))
# sf <- st_linestring(sf)
#
# spToDT(sf)
#
# geom <- st_geometry(sf)
#
# class(geom)
#
# length(geom)
#
# lst <- lapply(geom, function(x){
# 	m <- unlist(x)
# 	googleway::encode_pl(m[,2],m[,1])
# })
#
# lapply(lst, function(x){
# 	coords = data.frame(lat = x[,2],
# 											lon = x[,1])
# })
#
# #
# encoding polylines
# library(data.table)
# library(sp)
# library(googleway)
#
# dt_stops <- as.data.table(tram_stops)
# dt_stops[1:25, id := 1]
# dt_stops[26:51, id := 2]
#
# lst <- lapply(1:2, function(x){
# 	Lines(Line(dt_stops[id == x, .(stop_lon, stop_lat)]), ID = x)
# })
#
# sp <- SpatialLines(lst)
#
# sf_tramRoute <- sf::st_as_sf(sp)
#
# spdf <- SpatialLinesDataFrame(sp, data = dt_stops)
#
# dt <- EncodeSF(sf)
#
# mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# google_map(key = mapKey) %>%
# 	add_polylines(data = dt, polyline = "polyline")


# library(sf)
# s1 <- rbind(c(0,3),c(0,4),c(1,5),c(2,5))
# ls <- st_linestring(s1)
#
# s2 <- rbind(c(0.2,3), c(0.2,4), c(1,4.8), c(2,4.8))
# s3 <- rbind(c(0,4.4), c(0.6,5))
# mls <- st_multilinestring(list(s1,s2,s3))



## encoding polygons with holes
# library(rgdal)
# library(sf)
# shp_postcode <- readOGR(dsn = path.expand("~/Documents/SVNStuff/Clients/CCC_CalvaryCommunityCare/DataStore/Received/1270055003_poa_2011_aust_shape"), layer = "POA_2011_AUST")
#
# sf <- st_as_sf(shp_postcode)
#
# dt <- spToDT(sf)
#
# dt_poly <- EncodeSF(sf)
#
# ## hole postcode
# ## 3168
#
# ## multiple rings
# ## 0822
#
# shp_tiwi <- shp_postcode[shp_postcode$POA_CODE == "0822", ]
#
# save(shp_tiwi, file = "~/Documents/github/spatial.data.table/shp_tiwi")
#
# sf_hole <- sf[sf$POA_CODE == "3168",]
# sf_multi <- sf[sf$POA_CODE == "0822",]
#
# shp_demo <- shp_postcode[shp_postcode$POA_CODE %in% c("3168","0822"),]
#
# geom_hole <- st_geometry(sf_hole)
# geom_multi <- st_geometry(sf_multi)
#
# dt[POA_CODE == "3168"]
#
# dt_poly <- EncodeSF(sf)
#
# # dt_plot <- unique(dt_poly[POA_CODE == "0822", .(POA_NAME, polyline)])
#
#

# map_key <- symbolix.utils::mapKey()
#
# dt_poly <- aggregate(polyline ~ .id, data = dt_poly, list)
# data.table::setDT(dt_poly)
#
# library(googleway)
# library(data.table)
# google_map(key = map_key, data = dt_poly[1:2]) %>%
# 	add_polygons(polyline = "polyline", info_window = ".id", mouse_over = ".id")
#
#
# library(leaflet)
#
# leaflet() %>%
# 	addTiles() %>%
# 	addPolygons(data = shp_postcode[1:1000, ])
#
# sf_tiwi <- st_as_sf(shp_tiwi)
#
# dt_tiwi <- EncodeSF(sf_tiwi)
#
# dt_tiwi <- aggregate(polyline ~ .id, data = dt_tiwi, list)
# data.table::setDT(dt_tiwi)
#
#
# google_map(key = map_key, data = dt_tiwi) %>%
# 	add_polygons(polyline = "polyline", info_window = ".id")





# exterior <- data.frame(lat = c(3, -3, -3, 3, 3),
# 											 lon = c(3, 3, -3, -3, 3))
#
# hole1 <- data.frame(lat = c(0, 0, 1, 1, 0),
# 										lon = c(0, 1, 1, 0, 0))
#
#
# exterior2 <- data.frame(lat = c(4, 5, 5, 4, 4),
# 												lon = c(0, 0, 1, 1, 0))
#
# df = data.frame(ID = c(1, 2))
# row.names(df) <- c(1,2)
#
# sp <- SpatialPolygonsDataFrame(
# 	SpatialPolygons(
# 		list(
# 			Polygons(list(
# 				Polygon(exterior, hole = FALSE),
# 				Polygon(hole1, hole = TRUE)),
# 				ID = 1
# 				),
# 			Polygons(list(
# 				Polygon(exterior2, hole = FALSE)
# 			),
# 			ID = 2
# 			)
# 			)
# 	),
# 	data = df
# )
#
#
# sf <- sf::st_as_sf(sp)
#
#
# nc <- st_read(system.file("shape/nc.shp", package = "sf"))
#
# class(nc)
#
#
# nc1 <- nc[1, ]
#
# geom <- st_geometry(nc)
# geom1 <- st_geometry(nc1)


## sfc_POINTS
# library(sf)
#
# sf_point <- readRDS("~/Downloads/melb_centroid.rds")
#
#
# spToDT(sf_point)
#
# library(data.table)
#
# geom <- st_geometry(sf_point)
#
#
#
# as.data.table(t(lst))



# polys <- st_as_sfc(c("POLYGON((0 0 , 0 1 , 1 1 , 1 0, 0 0))",
# 										 "POLYGON((0 0 , 0 2 , 2 2 , 2 0, 0 0 ))",
# 										 "POLYGON((0 0 , 0 -1 , -1 -1 , -1 0, 0 0))")) %>%
# 	st_sf()
#
# pts <- st_as_sfc(c("POINT(0.5 0.5)",
# 									 "POINT(0.6 0.6)",
# 									 "POINT(3 3)")) %>%
# 	st_sf()
#
# dt_polys <- spToDT(polys)
# dt_pts <- spToDT(pts)
#
# PointInPolygon(dt_polygons = dt_polys,
# 							 polyColumns = c("id", "lineId", "coords.V1", "coords.V2", "hole"),
# 							 dt_points = dt_pts,
# 							 pointColumns = c("id", "coords.V1", "coords.V2"))



## Encode SF
# library(sf)
# library(magrittr)
#
# sf_poly <- st_as_sfc(c("POLYGON((-80.190 25.774, -66.118 18.466, -64.757 32.321))",
# 											 "POLYGON((-70.579 28.745, -67.514 29.570, -66.668 27.339))")) %>%
# 	st_sf()
#
# df <- EncodeSF(sf_poly)

# library(googleway)
#
# google_map(key = read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")) %>%
# 	add_polygons(data = df, polyline = "polyline")

### Antipodes
# library(geosphere)
# LA <- c(-118.40, 33.95)
# NY <- c(-73.78, 40.63)
#
# SF <- c(-122.44, 37.74)
# AM <- c(4.75, 52.31)
#
# antipode(LA)
# spatial.data.table:::dtAntipode(rev(LA))


### CPP

## benchmarking cpp version of distHaversine
# n <- 1000000
# set.seed(20170511)
# lats <- seq(-90, 90, by = 1)
# lons <- seq(-180, 180, by = 1)
# dt <- data.table(lat1 = sample(lats, size = n, replace = T),
# 								 lon1 = sample(lons, size = n, replace = T),
# 								 lat2 = sample(lats, size = n, replace = T),
# 								 lon2 = sample(lons, size = n, replace = T))
#
# dt <- dt[lat1 != lat2]
# dt <- dt[lon1 != lon2]
#
# dt2 <- copy(dt)
#
# library(microbenchmark)
#
# microbenchmark(
# 	r = {dt[, distance := dtHaversine(lat1, lon1, lat2, lon2)]},
# 	cpp = {dt2[, distance := cppHaversine(lat1, lon1, lat2, lon2)]}
# )



# ## points in polygon
# # https://gis.stackexchange.com/questions/110117/counts-the-number-of-points-in-a-polygon-in-r
#
# library(raster)
# library(sp)
#
# x <- getData('GADM', country='ITA', level=1)
# class(x)
# # [1] "SpatialPolygonsDataFrame"
# # attr(,"package")
# # [1] "sp"
#
# set.seed(1)
# # sample random points
# p <- spsample(x, n=300, type="random")
# p <- SpatialPointsDataFrame(p, data.frame(id=1:300))
#
# proj4string(x)
# # [1] " +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"
# proj4string(p)
# # [1] " +proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs +towgs84=0,0,0"
#
# plot(x)
# plot(p, col="red" , add=TRUE)
#
# res <- over(p, x)
# table(res$NAME_1)
#
#
# dt_x <- spToDT(x)
# dt_p <- spToDT(p)
#
# dt_res <- PointInPolygon(dt_polygons = dt_x,
# 												 polyColumns = c("id","lineId","coords.V2","coords.V1","hole"),
# 												 dt_points = dt_p,
# 												 pointColumns = c("data.id","coords.y","coords.x"))
#
#
# dt_res[, .N, by = id][ unique(dt_x[, .(id, data.NAME_1)]), on = "id", nomatch = 0][order(data.NAME_1)]
#
#
#
#
# # https://www.rdocumentation.org/packages/sp/versions/1.2-3/topics/over-methods
#
# r1 = cbind(c(180114, 180553, 181127, 181477, 181294, 181007, 180409,
# 						 180162, 180114), c(332349, 332057, 332342, 333250, 333558, 333676,
# 						 									 332618, 332413, 332349))
# r2 = cbind(c(180042, 180545, 180553, 180314, 179955, 179142, 179437,
# 						 179524, 179979, 180042), c(332373, 332026, 331426, 330889, 330683,
# 						 													 331133, 331623, 332152, 332357, 332373))
# r3 = cbind(c(179110, 179907, 180433, 180712, 180752, 180329, 179875,
# 						 179668, 179572, 179269, 178879, 178600, 178544, 179046, 179110),
# 					 c(331086, 330620, 330494, 330265, 330075, 330233, 330336, 330004,
# 					 	329783, 329665, 329720, 329933, 330478, 331062, 331086))
# r4 = cbind(c(180304, 180403,179632,179420,180304),
# 					 c(332791, 333204, 333635, 333058, 332791))
#
# sr1=Polygons(list(Polygon(r1)),"r1")
# sr2=Polygons(list(Polygon(r2)),"r2")
# sr3=Polygons(list(Polygon(r3)),"r3")
# sr4=Polygons(list(Polygon(r4)),"r4")
# sr=SpatialPolygons(list(sr1,sr2,sr3,sr4))
# srdf=SpatialPolygonsDataFrame(sr, data.frame(cbind(1:4,5:2),
# 																						 row.names=c("r1","r2","r3","r4")))
#
# data(meuse)
# coordinates(meuse) = ~x+y
#
# plot(meuse)
# polygon(r1)
# polygon(r2)
# polygon(r3)
# polygon(r4)
# # retrieve mean heavy metal concentrations per polygon:
# over(sr, meuse[,1:4], fn = mean)
#
# over(sr, meuse)
#
#
# dt_sr <- spToDT(sr)
# dt_meuse <- spToDT(meuse)
# dt_meuse[, id := .I]
#
# PointInPolygon(dt_polygons = dt_sr,
# 							 polyColumns = c("id","lineId","coords.V1","coords.V2", "hole"),
# 							 dt_points = dt_meuse,
# 							 pointColumns = c("id","coords.x","coords.y"))
#
#
# # point.in.polygon(point.x = meuse@coords[,1],
# # 								 point.y = meuse@coords[,2],
# # 								 pol.x = sr@polygons[[1]]@Polygons[[1]]@coords[,1],
# # 								 pol.y = sr@polygons[[1]]@Polygons[[1]]@coords[,2])
#
#
# lapply(sr@polygons, function(x){
# 	point.in.polygon(point.x = meuse@coords[,1],
# 									 point.y = meuse@coords[,2],
# 									 pol.x = x@Polygons[[1]]@coords[,1],
# 									 pol.y = x@Polygons[[1]]@coords[,2])
# })
#
#
#
# library(microbenchmark)
#
# microbenchmark(
# 	dt = {
# 		PointInPolygon(dt_polygons = dt_sr,
# 									 polyColumns = c("id","lineId","coords.V1","coords.V2", "hole"),
# 									 dt_points = dt_meuse,
# 									 pointColumns = c("id","coords.x","coords.y"))
#
# 	},
# 	sp = {
#
# 		lapply(sr@polygons, function(x){
# 			point.in.polygon(point.x = meuse@coords[,1],
# 											 point.y = meuse@coords[,2],
# 											 pol.x = x@Polygons[[1]]@coords[,1],
# 											 pol.y = x@Polygons[[1]]@coords[,2])
# 		})
#
# 	}
# )



# # return the number of points in each polygon:
# sapply(over(sr, geometry(meuse), returnList = TRUE), length)
#
# data(meuse.grid)
# coordinates(meuse.grid) = ~x+y
# gridded(meuse.grid) = TRUE
#
# over(sr, geometry(meuse))
# over(sr, meuse)
# over(sr, geometry(meuse), returnList = TRUE)
# over(sr, meuse, returnList = TRUE)
#
# over(meuse, sr)
# over(meuse, srdf)
#
# # same thing, with grid:
# over(sr, meuse.grid)
# over(sr, meuse.grid, fn = mean)
# over(sr, meuse.grid, returnList = TRUE)
#
# over(meuse.grid, sr)
# over(meuse.grid, srdf, fn = mean)
# over(as(meuse.grid, "SpatialPoints"), sr)
# over(as(meuse.grid, "SpatialPoints"), srdf)












# ## http://stackoverflow.com/questions/21971447/check-if-point-is-in-spatial-object-which-consists-of-multiple-polygons-holes
# library(maptools)
# library(rgdal)
# library(rgeos)
# library(ggplot2)
# library(sp)
#
# URL <- "http://www.geodatenzentrum.de/auftrag1/archiv/vektor/vg250_ebenen/2012/vg250_2012-01-01.utm32s.shape.ebenen.zip"
# td <- tempdir()
# setwd(td)
# temp <- tempfile(fileext = ".zip")
# download.file(URL, temp)
# unzip(temp)
#
# # Get shape file
# shp <- file.path(tempdir(),"vg250_0101.utm32s.shape.ebenen/vg250_ebenen/vg250_gem.shp")
#
# # Read in shape file
# map <- readShapeSpatial(shp, proj4string = CRS("+init=epsg:25832"))
#
# # Transform the geocoding from UTM to Longitude/Latitude
# map <- spTransform(map, CRS("+proj=longlat +datum=WGS84"))





# # Pick an geographic area which consists of multiple polygons
# # ---------------------------------------------------------------------------
# # Output a frequency table of areas with N polygons
# nPolys <- sapply(map@polygons, function(x)length(x@Polygons))
#
# # Get geographic area with the most polygons
# polygon.with.max.polygons <- which(nPolys==max(nPolys))
#
# # Get shape for the geographic area with the most polygons
# Poly.coords <- map[which(nPolys==max(nPolys)),]




# filename <- system.file("shape/nc.shp", package="sf")
# nc <- st_read(filename)
#
# st_intersects(nc[1:5,], nc[1:4,])
#
# st_intersects(nc[1:5,], nc[1:4,], sparse = FALSE)




### winding number

# library(Rcpp)
#
# cppFunction('double myWindingNumber(double pointX, double pointY,
# 												 NumericVector vectorX, NumericVector vectorY){
#
# 	int windingNumber = 0;  // winding number counter
#
# 		int n = vectorX.size(); // number of rows of the polygon vector
# 	// compute winding number
#
# 	// loop all points in the polygon vector
# 	for (int i = 0; i < n; i++){   //
# 		if (vectorY[i] <= pointY){
# 			if (vectorY[i + 1] > pointY){
# 				//if (isLeft(vectorX[i], vectorY[i], vectorX[i + 1], vectorY[i + 1], pointX, pointY) > 0){
# 				if ( ((vectorX[i+1] - vectorX[i]) * (pointY - vectorY[i]) - (pointX - vectorX[i]) * (vectorY[i + 1] - vectorY[i])) > 0){
# 					++windingNumber;
# 				}
# 			}
# 		}else{
# 			if (vectorY[i + 1] <= pointY){
# 				//if (isLeft(vectorX[i], vectorY[i], vectorX[i + 1], vectorY[i + 1], pointX, pointY) < 0){
# 				if( ((vectorX[i+1] - vectorX[i]) * (pointY - vectorY[i]) - (pointX - vectorX[i]) * (vectorY[i + 1] - vectorY[i])) < 0){
# 					--windingNumber;
# 				}
# 			}
# 		}
# 	}
# 	return windingNumber;
# }')
#

## Point in Polygon cpp
# library(googleway)
# mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
#
# polyX = c(51.5, 51.9, 51.9, 51.5, 51.5)
# polyY = c(1.05, 1.05, -1.05, -1.05, 1.05)
#
# ## roughly Greenwhich
# pointX = c(51.6, 51.2, 52, 51.55)
# pointY = c(0, -1, 1, 0.5)
#
# df_poly <- data.frame(lat = polyX, lon = polyY, drag = TRUE)
# df_point <- data.frame(lat = pointX, lon = pointY, colour = "green")
#
# google_map(key = mapKey) %>%
# 	add_markers(data = df_poly, draggable = "drag") %>%
# 	add_polylines(data = df_poly, lat = "lat", lon = "lon") %>%
# 	add_markers(data = df_point, colour = "colour")
#
# library(data.table)
# dt_poly <- data.table(df_poly)
# dt_points <- data.table(df_point)
#
# dt_poly[, polygonId := 1]
# dt_poly[, lineId := 1]
# dt_points[, pointId := .I]
#
# ## for each polygon, calculate the winding number
#
# dt_poly[, PointsInPolygon(vectorX = lat, vectorY = lon,
# 													pointsX = dt_points$lat, pointsY = dt_points$lon,
# 													pointsId = dt_points$pointId)
# 				, by = .(polygonId, lineId)]


# ## multiple polygons
# dt_poly <- data.table(lat = c(51.5, 51.9,  51.9,  51.5, 51.5, 51.5, 52.1, 52.1, 51.5, 51.5),
# 											lon = c(1.05, 1.05, -1.05, -1.05, 1.05, 1.05, 1.05, 0, 0, 1.05),
# 											polygonId = c(rep(1,5), rep(2, 5)),
# 											lineId = c(rep(1, 5), rep(1, 5)))
#
# dt_poly[, info := paste0("lat: ", lat, ", lon: ", lon)]
# dt_poly[, drag := TRUE]
#
# ## roughly Greenwhich
# dt_point <- data.table(lat = c(51.6, 51.2, 52, 51.55),
# 											 lon = c(0, -1, 1, 0.5),
# 											 pointId = 1:4,
# 											 colour = "green")
#
# google_map(key = mapKey) %>%
# 	add_markers(data = dt_poly, info_window = "info", draggable = "drag") %>%
# 	add_polylines(data = dt_poly, lat = "lat", lon = "lon", id = "polygonId") %>%
# 	add_markers(data = dt_point, colour = "colour")
#
# dt_poly[, PointsInPolygon(vectorX = lat, vectorY = lon,
# 													pointsX = dt_points$lat, pointsY = dt_points$lon,
# 													pointsId = dt_points$pointId)
# 				, by = .(polygonId, lineId)]


## multiple polygons with hole
# dt_poly <- data.table(lat = c(51.5, 51.9,  51.9,  51.5, 51.5, 51.5,51.6,51.6,51.5,51.5, 51.5, 52.1, 52.1, 51.5, 51.5),
# 											lon = c(1.05, 1.05, -1.05, -1.05, 1.05, 0.6,0.6,0.4,0.4,0.6, 1.05, 1.05, 0, 0, 1.05),
# 											polygonId = c(rep(1,5), rep(1, 5), rep(2, 5)),
# 											lineId = c(rep(1, 5), rep(2, 5), rep(1, 5)),
# 											hole = FALSE)
#
# dt_poly[lineId == 2, hole := TRUE]
# dt_poly[, info := paste0("lat: ", lat, ", lon: ", lon)]
# dt_poly[, drag := TRUE]
#
# ## roughly Greenwhich
# dt_point <- data.table(lat = c(51.6, 51.2, 52, 51.55),
# 											 lon = c(0, -1, 1, 0.5),
# 											 pointId = 1:4,
# 											 colour = "green")
#
# google_map(key = mapKey) %>%
# 	add_markers(data = dt_poly, info_window = "info", draggable = "drag") %>%
# 	add_polylines(data = dt_poly, lat = "lat", lon = "lon", id = "polygonId") %>%
# 	add_markers(data = dt_point, colour = "colour", info_window = "pointId")
#
# dt_poly[, .(pointId = PointsInPolygon(vectorX = lat, vectorY = lon,
# 													pointsX = dt_point$lat, pointsY = dt_point$lon,
# 													pointsId = dt_point$pointId))
# 				, by = .(polygonId, lineId, hole)]

# library(googleway)
#
# dt_melbourne <- as.data.table(melbourne)
#
# dt_melbourne <- dt_melbourne[, decode_pl(polyline), by = .(polygonId, pathId)]
#
# dt_stops <- tram_stops
# setDT(dt_stops)
# dt_stops[, id := .I]
#
# google_map(key = mapKey) %>%
# 	add_polygons(data = dt_melbourne, polyline = "polyline", id = "polygonId",
# 							 pathId = "pathId") %>%
# 	add_markers(data = dt_stops, lat = "stop_lat", lon = "stop_lon")
#
# dt_melbourne[, PointsInPolygon(vectorX = lat,
# 															 vectorY = lon,
# 															 pointsX = dt_stops$stop_lat,
# 															 pointsY = dt_stops$stop_lon,
# 															 pointsId = dt_stops$id),
# 						 by = .(polygonId, pathId)]


### Simplify polyline
# pl <- "jnxeFeaxsZ}u@ngDebEyDa}DjU}|@hkCdDlnBsu@zIy}BrV{dA_}C{VauKynBeZ{yBcn@ssDuSqyAt|@qrAvbEycDtcAeyC_Vg~Fsi@utAcuAqjC_e@mnF_oAeeEgfF{xD|Bg|CoCekCo~B_tA}|@seFyX{bEjKwvFqjBm|B`F}oDyaAewHy`AiiBwlAsnElWapDMexDajBuv@u_AiAckE}{CyqDe}@{yB}jFcyCkrAkuC_xEedHygGapXmrHmmQj]ehFarAa`CgqBqLkhCwmEktDujForCucCi_CknE_pEqxLmtBonJdVcuD}zBodFmXegDnb@ohD_v@mjDcxCysH_jCmjCydBkh@}mA}oGoeDy{Le_@s_GmyAi~Ac}FwbEy~BkgMuhAssCugEquAurBvx@u~Cyi@suSkhOswBm{BenA{_NqOegG{uAi|EkbEyhDc|B_gDihB{zKnOmfFltCo|GhJgvEpE}}Cyx@g|@okCkgBa|EwwG_bDutAcfH{uBcdFrK}m@_sAw@avDxCw}Bsf@aaEgSurDkaAkdFezDwwBy~E_nCwk@qdB_gBepBqlC}zA_fAeeCchEcqC_yEga@k}F_uMsj@cnHslJktLagCg|DuqE_l@_tHcvD_uAoWskCusDorEu~DeaEidDogBclAaqBfI}wCpgBitC_m@qhEg_LsbH{kHosCcvE_eE{cBu^g`GggBo`EaxBkaFyE_iGhH{dCykC}}DcxAmfFo~B}jDmnDci@w{A}wAimImf@}lAgdDggCweBuhB}kBgnDhd@knAskE}aB{dD}jAg~Fc|CivDixBqjByz@keDsCkeKj@wmF}yAy`Jnl@mwPjCcmGreAayC}f@krCa{DouCgy@qvDoZ}yIjIsnFxjFqnLtIkkFlsBm`D~k@qhIy\\meDkaAi}CdG{nDcwE}yN{RqvLrjEw}PbOusHcYegG_\\mqH}v@ikCnW_tDbP{aIa}@q{D{mAe_Ckc@uiEkR_mMyl@auBcrC{bA_pAm{D`OonElm@uvAuAgjHa@eqF{dBgiI_cEgmFemEqvHakAgwBoOkyCaeAkmCqk@k~FkfAwfEooAweBijC_eCksGckDqzF_cEaaD}bBah@oxBcqBwqEkxBc|OiyCq_GiaLsyHebIkhNgpG{uCukI{zIq}BuxBchCiNy{GubDgfDanAueCwuEqyAulAwxC}WuzDiwEyhD_}AmhBqxFjr@emIoi@{iJu@ifLa]mfHnfAq_Da`AkbEy^}lAar@rBc`Fac@s`ChYhQd["
#
# googleway::decode_pl(pl)
# SimplifyPolyline(pl, 100000)
#
# pl <- googleway::melbourne[1, "polyline"]
#
# pl2 <- SimplifyPolyline(polyline = pl, distanceTolerance = 10000)
#
# mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# google_map(key = mapKey) %>%
# 	add_polylines(data = data.frame(polyline = pl), polyline = "polyline")
#
# nchar(pl)
# nchar(pl2)
#
# google_map(key = mapKey) %>%
# 	add_polylines(data = data.frame(polyline = pl2), polyline = "polyline")
#

# dt <- copy(googleway::melbourne)
# setDT(dt)
#
# google_map(key = mapKey) %>%
# 	add_polygons(data = dt, polyline = "polyline", id = "polygonId", pathId = "pathId", info_window = "polygonId")
#
# object.size(dt)
# hist(dt[, nchar(polyline)])
#
# dt[, polyline := SimplifyPolyline(polyline, distanceTolerance = 5000), by = .(polygonId, pathId)]
#
# object.size(dt)
# hist(dt[, nchar(polyline)])
#
# google_map(key = mapKey) %>%
# 	add_polygons(data = dt, polyline = "polyline", id = "polygonId", pathId = "pathId")
#
# pl <- dt[1, polyline]
# simplePl <- SimplifyPolyline(polyline = pl, 10000, type = "complex")
#
# google_map(key = mapKey) %>%
# 	add_polylines(data = data.frame(poly = pl), polyline = "poly")
#
#
# google_map(key = mapKey) %>%
# 	add_polylines(data = data.frame(poly = simplePl), polyline = "poly")
#
# dt_melbourne <- copy(googleway::melbourne[1, ])
# setDT(dt_melbourne)
# nchar(dt_melbourne[, polyline])
#
# dt_melbourne[, simplified := SimplifyPolyline(polyline, 100, type = "complex")]
# dt_melbourne[, simplified2 := SimplifyPolyline(polyline, 15000, type = "simple")]
#
# nchar(dt_melbourne[, simplified])
# nchar(dt_melbourne[, simplified2])
#
# google_map(key = mapKey, data = dt_melbourne[, ]) %>%
# 	# add_polygons(polyline = "polyline")
# 	add_polygons(polyline = "simplified2")


# mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
# sdt <- copy(sdt_melbourne)
# sdt[, polyline2 := SimplifyPolyline(polyline, type = "complex")]
#
# google_map(key = mapKey) %>%
# 	add_polylines(data = sdt[1, .(polyline)], polyline = "polyline")
#
# google_map(key = mapKey) %>%
# 	add_polylines(data = sdt[1, .(polyline2)], polyline = "polyline2")
#
# sdt <- copy(sdt_melbourne)
# sdt[, polyline2 := SimplifyPolyline(polyline, type = "complex")]
#
# PolylineDistance(sdt[1, polyline])
# PolylineDistance(sdt[1, polyline2])
#
#
# dt1 <- decode_pl(sdt[1, polyline])
# dt2 <- decode_pl(sdt[1, polyline2])
#
# setDT(dt1)
# setDT(dt2)
#
# dt1[, `:=`(latt = shift(lat, type = "lead"),
# 					 lont = shift(lon, type = "lead"))]
#
# dt1[, dist := dtHaversine(lat, lon, latt, lont)]
#
# dt2[, `:=`(latt = shift(lat, type = "lead"),
# 					 lont = shift(lon, type = "lead"))]
#
# dt2[, dist := dtHaversine(lat, lon, latt, lont)]
#
# dt1[, sum(dist, na.rm = T)]
# dt2[, sum(dist, na.rm = T)]
#
# library(Rcpp)
#
# cppFunction('double dHaversine(double latf, double lonf, double latt, double lont,
#                          double tolerance, double earthRadius){
# 						double d;
# 						double dlat = latt - latf;
# 						double dlon =  lont - lonf;
#
# 						d = (sin(dlat * 0.5) * sin(dlat * 0.5)) + (cos(latf) * cos(latt)) * (sin(dlon * 0.5) * sin(dlon * 0.5));
# 						if(d > 1 && d <= tolerance){
# 						d = 1;
# 						}
#
# 						return 2 * atan2(sqrt(d), sqrt(1 - d)) * earthRadius;
# 						}')
#
# dHaversine(-37.5549, 144.1877, -37.55483, 144.1877, 1000000000, 6378137.0)
#
# dtHaversine(-37.5549, 144.1877, -37.55483, 144.1877, 1000000000, 6378137.0)
# dtHaversine(dt1[1, lat], dt1[1, lon], dt1[1, latt], dt1[1, lont], 1000000000, 6378137.0)
# geosphere::distHaversine(p1 = rev(c(-37.5549, 144.1877)), p2 = rev(c(-37.55483, 144.1877)))
#


## Area calculations
# library(sf)
# library(spatialdatatable)
# nc <- st_read(system.file("shape/nc.shp", package="sf"))
# nc <- rbind(nc, nc, nc, nc, nc, nc, nc, nc, nc, nc, nc, nc, nc, nc, nc, nc, nc, nc, nc, nc)
# sdt <- EncodeSF(nc)
#
# library(microbenchmark)
#
# microbenchmark(
# 	sf = {
# 		st_area(nc)
# 	},
# 	sdt = {
# 		sdt[, polyArea := PolylineArea(polyline)]
# 	}
# )

## :=

# sdt <- copy(sdt_melbourne)
# sdt[, polyline2 := polyline]
# sdt[, polygonId2 := polygonId]
# sdt[, `:=`(pathId2 = pathId, SA2_NAME2 = SA2_NAME)]
# sdt$SA3_NAME2 <- sdt$SA3_NAME
# PolylineArea(sdt[1:2,])









