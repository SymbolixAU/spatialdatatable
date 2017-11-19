

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
