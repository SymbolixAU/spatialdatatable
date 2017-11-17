


# library(sf)
#
# nc <- st_read(system.file("shape/nc.shp", package="sf"))
# #
# # st_geometry(nc)
# #
#
# spatialdatatable:::encodeSFWKB(sfc = st_geometry(nc[1:4, ]))
#
#
# library(microbenchmark)
#
# microbenchmark(
# 	wkt = { spatialdatatable:::encodeSFWKB(st_geometry(nc))},
# 	dt = { EncodeSF(nc)},
# 	times = 25
# )
