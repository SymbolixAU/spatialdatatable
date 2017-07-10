#
# library(sp)
# library(rgdal)
# library(data.table)
# library(spatialdatatable)
# library(googleway)
# #
# # # data(meuse)
# # # coordinates(meuse) = c("x", "y")
# # # spTransform(meuse, "")
# # #
# # # meuse <- spTransform(meuse, CRS("+proj=longlat +ellps=GRS80"))
# # #
# # # data(meuse.riv)
# # # meuse.sr = SpatialPolygons(list(Polygons(list(Polygon(meuse.riv)),"meuse.riv")))
# # #
# # # dt_meuse <- toSDT(meuse)
# # # dt_meuse.sr <- toSDT(meuse.sr)
# #
# #
# # data(meuse)
# # coordinates(meuse) <- c("x", "y")
# # proj4string(meuse) <- CRS(paste("+init=epsg:28992",
# # 																"+towgs84=565.237,50.0087,465.658,-0.406857,0.350733,-1.87035,4.0812"))
# # # see http://trac.osgeo.org/gdal/ticket/1987
# # summary(meuse)
# # meuse.utm <- spTransform(meuse, CRS("+proj=utm +zone=32 +datum=WGS84"))
# # summary(meuse.utm)
# # cbind(coordinates(meuse), coordinates(meuse.utm))
# #
# #
# #
# # kiritimati_primary_roads <- readOGR(system.file("vectors",
# # 																								package = "rgdal")[1], "kiritimati_primary_roads")
# # kiritimati_primary_roads_ll <- spTransform(kiritimati_primary_roads,
# # 																					 CRS("+proj=longlat +datum=WGS84"))
# # opar <- par(mfrow=c(1,2))
# # plot(kiritimati_primary_roads, axes=TRUE)
# # plot(kiritimati_primary_roads_ll, axes=TRUE, las=1)
# # par(opar)
# # opar <- par(mfrow=c(1,2))
# #
# #
# ### scotland polygons
# scot_BNG <- readOGR(system.file("vectors", package = "rgdal")[1],
# 										"scot_BNG")
# scot_LL <- spTransform(scot_BNG, CRS("+proj=longlat +datum=WGS84"))
#
# plot(scot_LL, axes=TRUE)
#
# dt_scot <- toSDT(scot_LL)
#
# dt_sutherland <- dt_scot[data.NAME == "Sutherland"]
#
# plot(subset(scot_LL, NAME == "Sutherland"))
#
# dt_markers <- data.table(point_id = c(1:6),
# 												 lat = c(58, 57.9, 58.3, 58.3, 58.56675, 58.1),
# 												 lon = c(-4, -3.8, -4.2, -4.8, -4.508032, -3.9))
#
# #dt_markers <- dt_markers[6]
#
# map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
# google_map(key = map_key) %>%
# 	add_polylines(data = dt_sutherland, lat = "coords.V2", lon = "coords.V1") %>%
# 	add_markers(dt_markers)
#
# ptx <- dt_markers[1, (lat)]
# pty <- dt_markers[1, (lon)]
#
# dt <- copy(dt_sutherland)
# setnames(dt, c("coords.V1", "coords.V2"), c("y", "x"))
#
#
# dt_poly <- copy(dt_sutherland[, .(id, lat = coords.V2, lon = coords.V1)])
# dt_points <- copy(dt_markers)
#
# # ## testing all points against all polygons
# # dt_poly[, grpId := 1:.N, by = .(id, ringDir, hole)]
#
# PointsInPolygon(dt_poly, dt_points)
#
# dt_poly <- data.table(id = c(0,0,0,0,1,1,1,1),
# 											lat = c(28.774, 18.455, 32.321, 28.774, 28.745, 29.570, 27.339, 28.745),
# 											lon = c(-80.190, -66.118, -64.757, -80.190, -70.579, -67.514, -66.668, -70.579),
# 											ringDir = c(1,1,1,1,-1,-1,-1,-1),
# 											hole = c(F,F,F,F,T,T,T,T))
#
# dt_points <- data.table(point_id = 1:2,
# 												lat = c(28, 20),
# 												lon = c(-68, -78))
#
# google_map(key = map_key) %>%
# 	add_polylines(data = dt_poly, lat = "lat", lon = "lon", id = "id") %>%
# 	add_markers(dt_points)
#
# PointsInPolygon(dt_polygons = dt_poly,
# 								dt_points = dt_points)
#
#
