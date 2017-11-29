#
#
# library(Rcpp)
# library(sf)
#
# df <- data.frame(myId = c(1,1,1,1,1,1,1,1,2,2,2,2),
# 								 lineId = c(1,1,1,1,2,2,2,2,1,1,1,2),
# 								 lon = c(-80.190, -66.118, -64.757, -80.190,  -70.579, -67.514, -66.668, -70.579, -70, -49, -51, -70),
# 								 lat = c(26.774, 18.466, 32.321, 26.774, 28.745, 29.570, 27.339, 28.745, 22, 23, 22, 22))
#
# p1 <- as.matrix(df[1:4, c("lon", "lat")])
# p2 <- as.matrix(df[5:8, c("lon", "lat")])
# p3 <- as.matrix(df[9:12, c("lon", "lat")])
#
# point <- sf::st_sfc(sf::st_point(x = c(df[1,"lon"], df[1,"lat"])))
# multipoint <- sf::st_sfc(sf::st_multipoint(x = as.matrix(df[1:2, c("lon", "lat")])))
# polygon <- sf::st_sfc(sf::st_polygon(x = list(p1, p2)))
# linestring <- sf::st_sfc(sf::st_linestring(p3))
# multilinestring <- sf::st_sfc(sf::st_multilinestring(list(p3, p3)))
#
#
# str(st_geometry(geometry))
# str(st_geometry(sf_lns))
#
#
# library(Rcpp)
#
# ## Use C++ to print the class of each geometry to the console
# cppFunction('void sfClass(Rcpp::List sfGeometry){
#
#   int n = sfGeometry.size();
#   Rcpp::Rcout << "sf size: " << n << std::endl;
#
# 	for (int i = 0; i < n; i++) {
#     Rcpp::List singleSf = sfGeometry[i];
#     Rcpp::CharacterVector cls = singleSf.attr("class");
#     Rcpp::Rcout << "class: " << cls << std::endl;
# 	}
#
# }')
#
# class(polygon)
# # [1] "sfc_POLYGON" "sfc"
# class(polygon[[1]])
# # [1] "XY"      "POLYGON" "sfg"
# sfClass(polygon)
# # sf size: 1
# # class: "XY" "POLYGON" "sfg"
#
# class(linestring)
# # [1] "sfc_LINESTRING" "sfc"
# class(linestring[[1]])
# # [1] "XY"         "LINESTRING" "sfg"
# sfClass(linestring)
# # sf size: 1
# # Error in sfClass(linestring) : Not compatible with STRSXP: [type=NULL].
#
# str(point)
# attributes(point)
# sfClass(point)
#
# str(multipoint)
# class(multipoint)
# class(multipoint[[1]])
# sfClass(multipoint)
#
#
#
# str(multilinestring)
# attributes(multilinestring)
# sfClass(multilinestring)
#
# sf <- rbind(
# 	st_sf(geo = polygon),
# 	st_sf(geo = multilinestring),
# 	st_sf(geo = linestring),
# 	st_sf(geo = point)
# 	)
#
# sfClass(st_geometry(sf))
# # sf size: 4
# # class: "XY" "POLYGON" "sfg"
# # class: "XY" "MULTILINESTRING" "sfg"
# # Error in sfClass(st_geometry(sf)) :
# # 	Not compatible with STRSXP: [type=NULL].
#
#
# sfClass(sf[3,])
#
#
# ls <- sf:::Mtrx(p3, dim = "XYZ", type = "LINESTRING")
# str(ls)
#
# sf:::getClassDim(p3, ncol(p3), dim = "XYZ", type = "LINESTRING")
#
# ls <- structure(p3, class = sf:::getClassDim(p3, ncol(p3), dim = "XYZ", type = "LINESTRING"))
# str(ls)
# class(ls)
#
# class(linestring)
# class(linestring[[1]])
#
# class(polygon)
# class(polygon[[1]])
#
#
# for (i in 1:3) {
# 	print(class(st_geometry(sf[i, ])))
# }
#
#
#
