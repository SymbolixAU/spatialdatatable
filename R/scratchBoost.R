### -------------------------------------------------------
# library(sf)
# library(data.table)
# library(symbolix.utils)
# library(googleway)
# library(mongolite)
# library(geojsonio)
#
# nc <- st_read(system.file("shape/nc.shp", package="sf"))
# dt <- as.data.table(nc)
#
# dt[, polyline := spatialdatatable:::encodeGeometry(st_geometry(nc)) ]
#
# str(dt[4, ])
#
# google_map(key = mapKey()) %>%
# 	add_polygons(data = dt[4, ], polyline = "polyline")
#
# ## plottilng a multipolygon with multi polygons
#
# qry <- '{ "properties.STE_NAME16" : "South Australia" }'
# con <- ConnectToMongo(collection = "SA1_2016", db = "ABS", usr = "db_user")
# res <- con$find(query = qry, ndjson = T)
# rm(con); gc()
# sf_lst <- lapply(res, sf:::read_sf)
# sf <- do.call(sf:::rbind.sf, sf_lst)
#
# # plot(sf[, c("SA2_NAME16", "geometry")])
#
# dt <- as.data.table(sf)
# dt[, polyline := spatialdatatable:::encodeGeometry(st_geometry(sf))]
#
# google_map(key = mapKey()) %>%
# 	add_polygons(data = dt,  polyline = "polyline",
# 							 info_window = "SA2_NAME16",
# 							 mouse_over_group = "SA1_MAIN16")
#
#
# dt[SA2_NAME16 == "Kadina"]
# sf[sf$SA2_NAME16 == "Kadina", c("SA2_NAME16", "geometry")]
#
# sf[sf$SA2_NAME16 == "Eyre Peninsula", "geometry"]
#
#
#
#
#
# df <- data.frame(myId = c(1,1,1,1,1,1,1,1,2,2,2,2),
# 								 lineId = c(1,1,1,1,2,2,2,2,1,1,1,2),
# 								 lat = c(26.774, 18.466, 32.321, 26.774, 28.745, 29.570, 27.339, 28.745, 22, 23, 22, 22),
# 								 lon = c(-80.190, -66.118, -64.757, -80.190,  -70.579, -67.514, -66.668, -70.579, -50, -49, -51, -50),
# 								 stringsAsFactors = FALSE)
#
# p1 <- list(as.matrix(df[1:4, c("lon", "lat")]))
# p2 <- list(as.matrix(df[5:8, c("lon", "lat")]))
# p3 <- list(as.matrix(df[9:12, c("lon", "lat")]))
#
# mp <- sf::st_multipolygon(x = list(p1, p2, p3))
#
# sf <- sf::st_sf(sf::st_sfc(mp))
#
# plot(sf)
#
# sf$polyline <- spatialdatatable:::encodeGeometry(st_geometry(sf))
#
# google_map(key = mapKey() )%>%
#  	add_polygons(data = sf, polyline = "polyline")
#
# f <- paste0("polyline", " ~ " , paste0(setdiff(names(sf), "polyline"), collapse = "+") )
# stats::aggregate(stats::formula(f), data = sf, list)
#
# dt <- as.data.table(sf)
#
# google_map(key = mapKey() )%>%
# 	add_polygons(data = dt, polyline = "polyline")



### -------------------------------------------------------
# library(sf)

# outer = matrix(c(0,0,10,0,10,10,0,10,0,0),ncol=2, byrow=TRUE)
# hole1 = matrix(c(1,1,1,2,2,2,2,1,1,1),ncol=2, byrow=TRUE)
# hole2 = matrix(c(5,5,5,6,6,6,6,5,5,5),ncol=2, byrow=TRUE)
# pts = list(outer, hole1, hole2)
# (ml1 = st_multilinestring(pts))
# ml2 = st_multilinestring(list(hole2, hole1, outer))
#
# sf <- sf::st_sf(sf::st_sfc(list(ml1, ml2) ))
#
# spatialdatatable:::encodeGeometry(st_geometry(sf))

#
#
# sf <- st_sf(mix)
#
# spatialdatatable:::encodeGeometry(st_geometry(sf[2, ]))
#
# str(st_geometry(sf[2, ]))

# ## -------------------------------------------------------
# library(sf)
#
# nc <- st_read(system.file("shape/nc.shp", package="sf"))
#
# spatialdatatable:::encodeGeometry(sfc = st_geometry(nc[, ]))
#
# library(microbenchmark)
#
# microbenchmark(
# 	wkt = { spatialdatatable:::encodeGeometry(st_geometry(nc))},
# 	dt = { EncodeSF(nc)},
# 	times = 25
# )
#
# # Unit: milliseconds
# # expr       min        lq       mean    median        uq       max neval
# # wkt   1.376192  1.484347   1.877932  1.534506  1.702152   8.54406    25
# # dt   70.445816 77.721602 103.421258 82.933516 98.641371 209.08351    25

# library(data.table)
# dt <- copy(nc)
# setDT(dt)
# lst <- spatialdatatable:::encodeGeometry(st_geometry(nc))
#
# dt[, polyline := spatialdatatable:::encodeGeometry(geometry)]
# dt[, geometry := NULL]
#
# library(googleway)
#
# map_key <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# google_map(key = map_key) %>%
# 	add_polylines(data = dt, polyline = "polyline")

# m <- matrix(unlist(st_geometry(nc[1, ])), ncol = 2)
# lats <- m[,1]
# lons <- m[,2]
# data.table(pl = encode_pl(lats, lons))
