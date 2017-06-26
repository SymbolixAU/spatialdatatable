# library(rgdal)
# library(rgeos)
# library(sf)
# library(spatial.data.table)
# library(data.table)
# library(googleway)


# sf <- st_read("~/Documents/Data/Shapefiles/1259030001_sla11aaust_shape/SLA11aAust.shp")

# shp <- readOGR("../../Data/Shapefiles/1259030001_sla11aaust_shape",
# 							 layer = "SLA11aAust")
#
# sf <- st_read("~/Documents/Data/Shapefiles/1270055003_lga_2011_aust_shape/LGA_2011_AUST.shp")
#
# shp <- readOGR("../../Data/Shapefiles/1270055003_lga_2011_aust_shape/",
# 							 layer = "LGA_2011_AUST")
#
# shp_vic <- subset(shp, shp@data$STE_CODE11 == 2)
# # plot(shp_vic)
#
# sf_vic <- st_as_sf(shp_vic)
#
# spToDT(sf_vic)
#
# shp_fis <- subset(shp, shp@data$SLA_CODE11 == 255208529)
# plot(shp_fis)
#
# ## polygons with many lines
# mapKey <- read.dcf("~/Documents/.googleAPI", fields = "GOOGLE_MAP_KEY")
#
# dt_polygons <- spToDT(shp_vic)
# dt_points <- data.table(id = 1:3,
# 												lat = c(-38.402, -38.3, -38.4),
# 												lon = c(145.23, 145.3, 145.275))
#
#
# PointInPolygon(dt_polygons, c("id","lineId","coords.V2","coords.V1", "hole"),
# 							 dt_points, c("id","lat","lon"))
#
#
#
# sf_fis <- st_as_sf(shp_fis)
#
# length(sf_fis$geometry[[1]])

# spatial.data.table:::PointInPolygon(dt_polygons,c("id", "coords.V2", "coords.V1", "hole"),
# 																		dt_points,c("id", "lat", "lon"))
#
#
# point.in.polygon(1:10,1:10,c(3,5,5,3),c(3,3,5,5))
# point.in.polygon(1:10,rep(4,10),c(3,5,5,3,3),c(3,3,5,5,3))
#




#
# google_map(key = mapKey) %>%
# 	add_polylines(data = dt_polygons[lineId %in% c(2,3)], lat = "coords.V2", lon = "coords.V1", id = "lineId") %>%
# 	add_markers(data = dt_points, info_window = "id")


