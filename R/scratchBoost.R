


# library(sf)
#
# nc <- st_read(system.file("shape/nc.shp", package="sf"))
# #
# # st_geometry(nc)
# #
#
# spatialdatatable:::encodeSFWKB(sfc = st_geometry(nc[4, ]))
#
#
# library(microbenchmark)
#
# microbenchmark(
# 	wkt = { spatialdatatable:::encodeSFWKB(st_geometry(nc))},
# 	dt = { EncodeSF(nc)},
# 	times = 25
# )

# library(data.table)
# dt <- copy(nc)
# setDT(dt)
# lst <- spatialdatatable:::encodeSFWKB(st_geometry(nc))
#
# dt[, polyline := lst]
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
