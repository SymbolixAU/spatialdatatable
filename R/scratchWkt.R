#
# library(googleway)
# library(spatialdatatable)
#
# dt <- googleway::melbourne
# setSDT(dt)
# options("datatable.prettyprint.char" = 20L)
#
# # dt[, c("lat", "lon") := decode_pl(polyline)]
#
#
# dt[, wkt := mywkt(polyline), by = polygonId]
#
#
# geom <- sf::st_as_sfc(dt[1, wkt])
# sf::st_area(geom)
# sf::st_length(geom)
#
# geom <- sf::st_as_sfc(dt[2, wkt])
# sf::st_area(geom)
# sf::st_length(geom)
#
# geom <- sf::st_as_sfc(dt[3, wkt])
# sf::st_area(geom)
# sf::st_length(geom)
#
# dt[, sf := sf::st_as_sfc(wkt)]
# dt[, area := sf::st_area(sf) * 10000]
#
#
#
#
# pl1 <- encode_pl(lat = c(0,1,1), lon = c(1,0,0))
# pl2 <- encode_pl(lat = c(2,3,4), lon = c(5,4,3))
#
# dt <- data.table(id = c(1,2), polyline = c(pl1, pl2))
#
# dt[, wkt := mywkt(polyline), by = id]
#
#
#
# library(data.table)
# dt <- data.table(id = 1:3,
# 								 lists1 = c(list(letters[1:3]), list(letters[10:20]), list(letters[24:26])),
# 								 lists2 = c(list(letters[24:26]), list(letters[10:20]), list(letters[1:3])))
#
# dt
# #    id       lists1       lists2
# # 1:  1        a,b,c        x,y,z
# # 2:  2 j,k,l,m,n,o, j,k,l,m,n,o,
# # 3:  3        x,y,z        a,b,c
#
#
#
# dt[, t(lists1), by = id]
#
#
# ## lists1 and lists2 will always be the same length at each row
#
#
# dt[, .(unlist(lists1), unlist(lists2)) ,  by = id]
#
# dt[, .(unlist(lists1,lists2)) ,  by = id]
#
# dt[, c("lat", "lon") := .(unlist(lists1), unlist(lists2)), by = id]
#
#
# dt[, lapply(.SD, unlist), .SDcols = c("lists1", "lists2"), by = id]
#
#
#
#
# library(sf)
# b0 = st_polygon(list(rbind(c(-1,-1), c(1,-1), c(1,1), c(-1,1), c(-1,-1))))
# b1 = b0 + 2
# b2 = b0 + c(-0.2, 2)
# x = st_sfc(b0, b1, b2)
# st_area(x)
#
# geom <- st_geometry(x)
#
#
#
#
# dist_vincenty = function(p1, p2, a, f) geosphere::distVincentyEllipsoid(p1, p2, a, a * (1-f), f)
# line = st_sfc(st_linestring(rbind(c(30,30), c(40,40))), crs = 4326)
# st_length(line)
# st_length(line, dist_fun = dist_vincenty)
#
# outer = matrix(c(0,0,10,0,10,10,0,10,0,0),ncol=2, byrow=TRUE)
# hole1 = matrix(c(1,1,1,2,2,2,2,1,1,1),ncol=2, byrow=TRUE)
# hole2 = matrix(c(5,5,5,6,6,6,6,5,5,5),ncol=2, byrow=TRUE)
#
# poly = st_polygon(list(outer, hole1, hole2))
# mpoly = st_multipolygon(list(
# 	list(outer, hole1, hole2),
# 	list(outer + 12, hole1 + 12)
# ))
#
# st_length(st_sfc(poly, mpoly))
# p = st_sfc(st_point(c(0,0)), st_point(c(0,1)), st_point(c(0,2)))
# st_distance(p, p)
# st_distance(p, p, by_element = TRUE)
#
#
#
#
#
# nc <- st_read(system.file("shape/nc.shp", package="sf"))
# sdtnc <- EncodeSF(nc)
#
#
# nc
# sdtnc
#
# sdtnc[, wkt := mywkt(polyline), by = .id]
#
#
# sf:::R_read_wkb("POLYGON( ( 0 0, 1 1, 2 2) )", )
#
